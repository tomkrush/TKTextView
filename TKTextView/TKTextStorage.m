#import "TKTextStorage.h"
#import <CoreText/CoreText.h>

const NSString *TKTextBackgroundAttributeName = @"TKTextBackground";
const NSString *TKTextLinkAttributeName = @"TKTextLink";

@implementation TKTextStorage

- (id)init
{
    if ( self = [super init] ) 
	{
        _mutableAttributedString = [[NSMutableAttributedString allocWithZone:[self zone]] init];
        _cachedFonts = NULL;
    }
	
    return self;
}

- (id)initWithString:(NSString *)string
{
    return [self initWithString:string links:NO];
    
}

- (id)initWithString:(NSString *)string links:(BOOL)links
{
    if ( self = [self init] )
	{
		self.text = string;
        
        [self setForegroundColor:[UIColor blueColor] forRange:CFRangeMake(0, [string length])];
	}
	
	return self;
}

- (NSMutableAttributedString *)attributedString
{	
	return _mutableAttributedString;
}

- (void)setKerning:(CGFloat)kerning
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setKerning:kerning forRange:range];
}

- (void)setKerning:(CGFloat)kerning forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);

	CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloat32Type, &kerning);

	[self addAttribute:(id)kCTKernAttributeName value:(id)number range:internalRange];

	CFRelease(number);
}

- (void)setLink:(NSURL *)url
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setLink:url forRange:range];
}

- (void)setLink:(NSURL *)url forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);
	
	[self addAttribute:(id)TKTextLinkAttributeName value:url range:internalRange];
    
    [self setForegroundColor:[UIColor blackColor] forRange:range];
    [self setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:14.0f]  forRange:range];
}

- (void)setUnderline:(TKTextUnderlineStyle)textUnderlineMode
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setUnderline:textUnderlineMode forRange:range];
}

- (void)setUnderline:(TKTextUnderlineStyle)textUnderlineMode forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);

	CFNumberRef number = CFNumberCreate(NULL, kCFNumberSInt32Type, &textUnderlineMode);

	[self addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)number range:internalRange];
	
	CFRelease(number);
}

- (void)setUnderlineColor:(UIColor *)color
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setUnderlineColor:color forRange:range];
}

- (void)setUnderlineColor:(UIColor *)color forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);
	
	[self addAttribute:(id)kCTUnderlineColorAttributeName value:(id)color.CGColor range:internalRange];
}

- (void)setStrokeColor:(UIColor *)color
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setStrokeColor:color forRange:range];
}

- (void)setStrokeColor:(UIColor *)color forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);
	
	[self addAttribute:(id)kCTStrokeColorAttributeName value:(id)color.CGColor range:internalRange];
}

- (void)setStrokeWidth:(CGFloat)width
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setStrokeWidth:width forRange:range];
}

- (void)setStrokeWidth:(CGFloat)width forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);

	CFNumberRef number = CFNumberCreate(NULL, kCFNumberFloat32Type, &width);

	[self addAttribute:(id)kCTStrokeWidthAttributeName value:(id)number range:internalRange];
	
	CFRelease(number);
}

- (void)setFont:(UIFont *)font
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setFont:font forRange:range];
}

- (void)setFont:(UIFont *)font forRange:(CFRange)range
{
	if ( ! _cachedFonts )
	{
		_cachedFonts = CFDictionaryCreateMutable(kCFAllocatorDefault, 0, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
	}

	NSRange internalRange = NSMakeRange(range.location, range.length);
	CFStringRef fontName = (CFStringRef)font.fontName;

	CFTypeRef internalFont = NULL;

	BOOL exists = CFDictionaryGetValueIfPresent(_cachedFonts, fontName, &internalFont);

	if ( exists == FALSE )
	{	
		internalFont = CTFontCreateWithName(fontName, font.pointSize, NULL);
		
		CFDictionaryAddValue(_cachedFonts, fontName, internalFont);
		
		[self addAttribute:(id)kCTFontAttributeName value:(id)internalFont range:internalRange];
		
		CFRelease(internalFont);
	}
	else
	{	
		[self addAttribute:(id)kCTFontAttributeName value:(id)internalFont range:internalRange];
	}
}

- (void)setForegroundColor:(UIColor *)color
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setForegroundColor:color forRange:range];
}

- (void)setForegroundColor:(UIColor *)color forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);

	[self addAttribute:(id)kCTForegroundColorAttributeName value:(id)color.CGColor range:internalRange];
}

- (void)setBackgroundColor:(UIColor *)color
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setBackgroundColor:color forRange:range];
}

- (void)setBackgroundColor:(UIColor *)color forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);
	
	[self addAttribute:(id)TKTextBackgroundAttributeName value:(id)color.CGColor range:internalRange];
}

- (void)setParagraphStyle:(TKParagraphStyle *)paragraphStyle
{
	CFRange range = CFRangeMake(0, [self.attributedString.mutableString length]);

	[self setParagraphStyle:paragraphStyle forRange:range];
}

- (void)setParagraphStyle:(TKParagraphStyle *)paragraphStyle forRange:(CFRange)range
{
	NSRange internalRange = NSMakeRange(range.location, range.length);
	
	TKTextAlignment textAlignment = paragraphStyle.textAlignment;
	CGFloat firstLineHeadIndent = paragraphStyle.firstLineHeadIndent;
	CGFloat headIndent = paragraphStyle.headIndent;
	TKLineBreakMode lineBreakMode = paragraphStyle.lineBreakMode;
	CGFloat lineHeightMultiple = paragraphStyle.lineHeightMultiple;
	CGFloat lineSpacing = paragraphStyle.lineSpacing;
	CGFloat maximumLineHeight = paragraphStyle.maximumLineHeight;
	CGFloat minimumLineHeight = paragraphStyle.minimumLineHeight;
	CGFloat paragraphSpacingBefore = paragraphStyle.paragraphSpacingBefore;
	CGFloat paragraphSpacing = paragraphStyle.paragraphSpacing;
	CGFloat tailIndent = paragraphStyle.tailIndent;
	
	CFIndex theNumberOfSettings = 11;
	CTParagraphStyleSetting theSettings[] =
	{
		{ kCTParagraphStyleSpecifierAlignment, sizeof(TKTextAlignment), &textAlignment },
		{ kCTParagraphStyleSpecifierFirstLineHeadIndent, sizeof(CGFloat), &firstLineHeadIndent},
		{ kCTParagraphStyleSpecifierHeadIndent, sizeof(CGFloat), &headIndent},
		{ kCTParagraphStyleSpecifierLineBreakMode, sizeof(TKLineBreakMode), &lineBreakMode},
		{ kCTParagraphStyleSpecifierLineHeightMultiple, sizeof(CGFloat), &lineHeightMultiple},
		{ kCTParagraphStyleSpecifierLineSpacing, sizeof(CGFloat), &lineSpacing},
		{ kCTParagraphStyleSpecifierMaximumLineHeight, sizeof(CGFloat), &maximumLineHeight},
		{ kCTParagraphStyleSpecifierMinimumLineHeight, sizeof(CGFloat), &minimumLineHeight},
		{ kCTParagraphStyleSpecifierParagraphSpacing, sizeof(CGFloat), &paragraphSpacing},
		{ kCTParagraphStyleSpecifierParagraphSpacingBefore, sizeof(CGFloat), &paragraphSpacingBefore},
		{ kCTParagraphStyleSpecifierTailIndent, sizeof(CGFloat), &tailIndent},
	};
		
	CTParagraphStyleRef internalParagraphStyle = CTParagraphStyleCreate(theSettings, theNumberOfSettings);

	[self addAttribute:(id)kCTParagraphStyleAttributeName value:(id)internalParagraphStyle range:internalRange];
    
    CFRelease(internalParagraphStyle);
}

- (NSString *)text
{
	return self.mutableString;
}

- (void)setText:(NSString *)text
{
	[self.mutableString setString:text];
}

- (void)beginEditing
{
    [self.attributedString beginEditing];
}

- (void)endEditing
{
    [self.attributedString endEditing];
}

#pragma mark -
#pragma mark Primitive Methods

- (NSString *)string
{
	return [_mutableAttributedString string];
}

- (NSUInteger)length
{
	return [_mutableAttributedString length];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    @try {
        return [_mutableAttributedString attributesAtIndex:index effectiveRange:aRange];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
    
	return nil;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)aRange inRange:(NSRange)rangeLimit
{
    @try {
        return [_mutableAttributedString attributesAtIndex:index longestEffectiveRange:aRange inRange:rangeLimit];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
    
	return nil;
}

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    @try {
        return [_mutableAttributedString attribute:attributeName atIndex:index effectiveRange:aRange];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
    
	return nil;
}

- (id)attribute:(NSString *)attributeName atIndex:(NSUInteger)index longestEffectiveRange:(NSRangePointer)aRange inRange:(NSRange)rangeLimit
{
    @try {
        return [_mutableAttributedString attribute:attributeName atIndex:index longestEffectiveRange:aRange inRange:rangeLimit];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
    
	return nil;
}

- (BOOL)isEqualToAttributedString:(NSAttributedString *)otherString
{
	return [_mutableAttributedString isEqualToAttributedString:otherString];
}

- (NSAttributedString *)attributedSubstringFromRange:(NSRange)aRange
{
    @try {
        return [_mutableAttributedString attributedSubstringFromRange:aRange];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
    
	return nil;
}

- (void)enumerateAttribute:(NSString *)attrName inRange:(NSRange)enumerationRange options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(id value, NSRange range, BOOL *stop))block
{
    @try {
        [_mutableAttributedString enumerateAttribute:attrName inRange:enumerationRange options:opts usingBlock:block];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}

- (void)enumerateAttributesInRange:(NSRange)enumerationRange options:(NSAttributedStringEnumerationOptions)opts usingBlock:(void (^)(NSDictionary *attrs, NSRange range, BOOL *stop))block
{
    @try {
        [_mutableAttributedString enumerateAttributesInRange:enumerationRange options:opts usingBlock:block];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}

- (NSMutableString *)mutableString
{
	return [_mutableAttributedString mutableString];
}

- (void)replaceCharactersInRange:(NSRange)aRange withString:(NSString *)aString
{
    @try {
        [_mutableAttributedString replaceCharactersInRange:aRange withString:aString];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}

- (void)deleteCharactersInRange:(NSRange)aRange
{
    @try {
        [_mutableAttributedString deleteCharactersInRange:aRange];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}

- (void)setAttributes:(NSDictionary *)attributes range:(NSRange)aRange
{
    @try {
        [_mutableAttributedString setAttributes:attributes range:aRange];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}

- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)aRange
{
    @try {
        [_mutableAttributedString addAttribute:name value:value range:aRange];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}

- (void)addAttributes:(NSDictionary *)attributes range:(NSRange)aRange
{
    @try {
        [_mutableAttributedString addAttributes:attributes range:aRange];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}

- (void)removeAttribute:(NSString *)name range:(NSRange)aRange
{
    @try {
        [_mutableAttributedString removeAttribute:name range:aRange];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception");
    }
}

- (void)appendAttributedString:(NSAttributedString *)attributedString
{
	[_mutableAttributedString appendAttributedString:attributedString];
}

- (void)insertAttributedString:(NSAttributedString *)attributedString atIndex:(NSUInteger)index
{
	[_mutableAttributedString insertAttributedString:attributedString atIndex:index];
}

- (void)replaceCharactersInRange:(NSRange)aRange withAttributedString:(NSAttributedString *)attributedString
{
	[_mutableAttributedString replaceCharactersInRange:aRange withAttributedString:attributedString];
}

- (void)setAttributedString:(NSAttributedString *)attributedString
{
	[_mutableAttributedString setAttributedString:attributedString];
}

- (void)dealloc
{
    if ( _cachedFonts )
    {
        CFRelease(_cachedFonts);
    }
	[_mutableAttributedString release];
	[super dealloc];
}

@end