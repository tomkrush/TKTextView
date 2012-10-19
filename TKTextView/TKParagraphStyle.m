#import "TKParagraphStyle.h"


@implementation TKParagraphStyle

@synthesize textAlignment			= _textAlignment;
@synthesize firstLineHeadIndent		= _firstLineHeadIndent;
@synthesize headIndent				= _headIndent;
@synthesize lineBreakMode			= _lineBreakMode;
@synthesize lineHeightMultiple		= _lineHeightMultiple;
@synthesize lineSpacing				= _lineSpacing;
@synthesize maximumLineHeight		= _maximumLineHeight;
@synthesize minimumLineHeight		= _minimumLineHeight;
@synthesize paragraphSpacing		= _paragraphSpacing;
@synthesize paragraphSpacingBefore	= _paragraphSpacingBefore;
@synthesize tailIndent				= _tailIndent;

- (void)setLineHeight:(CGFloat)lineHeight
{
	self.minimumLineHeight = lineHeight;
	self.maximumLineHeight = lineHeight;
}

- (CGFloat)lineHeight
{
	return self.minimumLineHeight;
}

@end