#import "TKTextView.h"
#import <QuartzCore/QuartzCore.h>
#import "TKTextRange.h"
#import "TKTextPosition.h"
#import "TKScanner.h"

@implementation TKTextView

@synthesize text = _text;
@synthesize inset = _inset;

@synthesize beginningOfDocument = _beginningOfDocument;
@synthesize endOfDocument = _endOfDocument;
@synthesize markedTextStyle = _markedTextStyle;
@synthesize markedTextRange = _markedTextRange;
@synthesize selectedTextRange = _selectedTextRange;
@synthesize inputDelegate = _inputDelegate;
@synthesize tokenizer = _tokenizer;
@synthesize showLinks = _showLinks;


- (id)initWithText:(NSString *)text showLinks:(BOOL)showLinks
{
    if ( self = [super init] ) {  
        self.showLinks = showLinks;
        self.text = text;
        _frame = NULL;
                
        [self addGestureRecognizer:self.tapGesture];
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    if ( ! [_text isEqualToString:text] )
    {
        [_text release];
        _text = text;
        [_text retain];
                
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            TKScanner *scanner = [[TKScanner alloc] initWithString:text];
            NSInteger inset = 0;
            NSMutableString *final_text = [[NSMutableString alloc] init];
            
            NSMutableArray *links = [[NSMutableArray alloc] init];
                                
            while( ! [scanner eos] )
            {
                NSString *scan = [scanner scan:@"<a href=\""];
            
                if ( scan )
                {
                    NSMutableString *urlString = [[NSMutableString alloc] init];
                    NSInteger start = 0;
                    NSInteger end = 0;
                    inset += [scan length];
                    
                    while ( ! [scanner eos] ) {
                        NSString *character = [scanner getch];
                        
                        if ( [character isEqualToString:@"\""] )
                        {
                            inset += 1;
                            break;
                        }
                        
                        [urlString appendString:character];
                    }
                                    
                    inset += [urlString length];
                    
                    scan = [scanner scan_until:@">"];
                    
                    if ( scan )
                    {
                        inset += [scan length];
                        start = [scanner pos] - inset;
                    }
                    
                    while ( ! [scanner eos] )
                    {
                        scan = [scanner scan:@"</a>"];
                        
                        if ( scan )
                        {
                            end = [scanner pos] - [scan length] - inset;
                            break;
                        }
                        else
                        {
                            [final_text appendString:[scanner getch]];
                        }
                    }
                    
                    NSURL *url = [[NSURL alloc] initWithString:urlString];
                    [urlString release];
                    
                    NSValue *range = [NSValue valueWithRange:NSMakeRange(start, end-start)];
                                    
                    NSDictionary *link = [[NSDictionary alloc] initWithObjectsAndKeys:url, @"url", range, @"range", nil]; 
                    [url release];
                    
                    [links addObject:link];
                    [link release];                             
                }
                else
                {
                    [final_text appendString:[scanner getch]];
                }
            }
            
            [self.textStorage.mutableString appendString:final_text];
            [final_text release];
            
            [scanner release];       

            [self.textStorage setFont:[UIFont fontWithName:@"Helvetica Neue" size:14.0f]];
            
            TKParagraphStyle *paragraphStyle = [[TKParagraphStyle alloc] init];
            [paragraphStyle setLineHeight:22.0f];
            [self.textStorage setParagraphStyle:paragraphStyle];
            [self.textStorage setForegroundColor:[UIColor blackColor]];

            [paragraphStyle release];
            
            if ( self.showLinks )
            {
                for ( NSDictionary *link in links)
                {
                    NSURL *url = [link valueForKey:@"url"];
                    NSRange range = [[link valueForKey:@"range"] rangeValue];
                
                    [self.textStorage setLink:url forRange:CFRangeMake(range.location, range.length)];
                }
            }
                        
            [links release];
                        
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setNeedsDisplay];
            });
        });
    }
}

- (TKTextStorage *)textStorage {
    if ( ! _textStorage ) {
        _textStorage = [[TKTextStorage alloc] initWithString:@""];
    }
    
    return _textStorage;
}

- (UITapGestureRecognizer *)tapGesture
{
    if ( ! _tapGesture )
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        _tapGesture.delegate = self;
    }
    
    return _tapGesture;
}

- (void)tap:(UITapGestureRecognizer *)tapGesture
{
    @try {
        if ( _frame )
        {
            CGPoint touch = [tapGesture locationOfTouch:0 inView:self];

            TKTextPosition *position = (TKTextPosition *)[self closestPositionToPoint:touch];
            
            NSRange effectedRange;
            NSDictionary *attributes = [self.textStorage attributesAtIndex:position.index effectiveRange:&effectedRange];
            
            NSURL *url = [attributes valueForKey:@"TATextLink"];
                
            if ( tapGesture.state == UIGestureRecognizerStateEnded ) 
            {
                self.selectedTextRange = nil;
            
                [[UIApplication sharedApplication] openURL:url];
            }
        }

    }
    @catch (NSException *exception) {
        NSLog(@"exception");
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    if ( self.textStorage )
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSaveGState(context);
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.textStorage);
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGRect textRect = UIEdgeInsetsInsetRect(rect, self.inset);
        
        CGPathAddRect(path, NULL, textRect);
        
        if ( _frame )
        {
            CFRelease(_frame);
        }
        
        _frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
        CFRelease(path);
        
        CGContextTranslateCTM(context, 0, rect.size.height);
        
        CGContextScaleCTM(context, 1.0, -1.0);
        
        CTFrameDraw(_frame, context);
        
        CFRelease(framesetter);
        
        CGContextRestoreGState(context);
    }
}

- (NSString *)textInRange:(TKTextRange *)textRange
{
	CFRange range = textRange.range;
	NSInteger length = [self.text length];
	
	range.location = range.location < 0 ? 0 : range.location;
	
	if ( (range.location + range.length) <= length )
	{
		return [self.text substringWithRange:NSMakeRange(range.location, range.length)];
	}
	
	return nil;
}

- (void)replaceRange:(UITextRange *)range withText:(NSString *)text
{

}

- (void)setMarkedText:(NSString *)markedText selectedRange:(NSRange)selectedRange
{

}

- (void)unmarkText
{

}

- (UITextRange *)textRangeFromPosition:(UITextPosition *)fromPosition toPosition:(UITextPosition *)toPosition
{
	return [TKTextRange rangeWithStart:fromPosition end:toPosition];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position offset:(NSInteger)offset
{
    return [self positionFromPosition:position inDirection:UITextLayoutDirectionRight offset:offset];
}

- (UITextPosition *)positionFromPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction offset:(NSInteger)offset
{
	return [TKTextPosition textPositionWithTextPosition:position offset:offset];
}

- (NSComparisonResult)comparePosition:(TKTextPosition *)position toPosition:(TKTextPosition *)other
{
	return [position compare:other];
}

- (NSInteger)offsetFromPosition:(TKTextPosition *)fromPosition toPosition:(TKTextPosition *)toPosition
{
	return toPosition.index - fromPosition.index;
}

- (UITextPosition *)positionWithinRange:(UITextRange *)range farthestInDirection:(UITextLayoutDirection)direction
{
    return nil;
}

- (UITextRange *)characterRangeByExtendingPosition:(UITextPosition *)position inDirection:(UITextLayoutDirection)direction
{
    return nil;
}

- (UITextWritingDirection)baseWritingDirectionForPosition:(UITextPosition *)position inDirection:(UITextStorageDirection)direction
{
	return UITextWritingDirectionLeftToRight;
}

- (void)setBaseWritingDirection:(UITextWritingDirection)writingDirection forRange:(UITextRange *)range
{

}

- (CGRect)firstRectForRange:(TKTextRange *)range
{
	return CGRectZero;
}

- (CGRect)caretRectForPosition:(UITextPosition *)position
{
    return CGRectZero;
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point
{
    return [self closestPositionToPoint:point withinRange:nil];
}

- (UITextPosition *)closestPositionToPoint:(CGPoint)point withinRange:(UITextRange *)range
{
    point.x -= self.inset.left;
	point.y += self.inset.top;

	CFArrayRef lines = CTFrameGetLines(_frame);
	CFIndex numLines = CFArrayGetCount(lines);
	
	CFIndex position = 0;
	CGPoint lineOrigin = CGPointZero;
	
	for(CFIndex index = 0; index < numLines; index++)
	{
		CTLineRef line = (CTLineRef) CFArrayGetValueAtIndex(lines, index);
		
		// Get the y-offest line origin
		CTFrameGetLineOrigins(_frame, CFRangeMake(index, 1), &lineOrigin);
		
		// Tricky: lines a 0 in bottom left
		if ((self.bounds.size.height - lineOrigin.y) >= point.y ) 
		{
			// The first line to match will be the one we're looking for.
			position = CTLineGetStringIndexForPosition(line, point);
			
			break;
		}
	}

	if (position == 0 && !CGPointEqualToPoint(lineOrigin, CGPointZero) ) 
	{
		// Touch was below the last line. 
		return [self endOfDocument]; 
	}
	
	return [TKTextPosition textPositionWithPosition:position];
}

- (UITextRange *)characterRangeAtPoint:(CGPoint)point
{
    return nil;
}

- (BOOL)hasText {
    return self.text ? YES : NO;
}

- (void)insertText:(NSString *)text {

}

- (void)deleteBackward {

}


#pragma mark - UITextInput Protocol
    
- (void)dealloc {
    if ( _frame )
	{
		CFRelease(_frame);
	}

    [_textStorage release];
    [_tapGesture release];
	[_tokenizer release];
    [_selectedTextRange release];
    [_beginningOfDocument release];
	[_endOfDocument release];
	[_markedTextStyle release];
    [_markedTextRange release];

    [_text release];
    [super dealloc];
}

@end
