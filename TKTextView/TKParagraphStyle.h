#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

enum
{
	TKLineBreakByWordWrapping		= kCTLineBreakByWordWrapping,
	TKLineBreakByCharWrapping		= kCTLineBreakByCharWrapping,
	TKLineBreakByClipping			= kCTLineBreakByClipping,
	TKLineBreakByTruncatingHead		= kCTLineBreakByTruncatingHead,
	TKLineBreakByTruncatingTail		= kCTLineBreakByTruncatingTail,
	TKLineBreakByTruncatingMiddle = kCTLineBreakByTruncatingMiddle
};
typedef uint8_t TKLineBreakMode;

enum
{
	TKTextAlignmentLeft			= kCTLeftTextAlignment,
	TKTextAlignmentRight		= kCTRightTextAlignment,
	TKTextAlignmentCenter		= kCTCenterTextAlignment,
	TKTextAlignmentJustified	= kCTJustifiedTextAlignment,
	TKTextAlignmentNatural		= kCTNaturalTextAlignment
};
typedef uint8_t TKTextAlignment;

@interface TKParagraphStyle : NSObject 
{
	TKTextAlignment _textAlignment;
	CGFloat			_firstLineHeadIndent;
	CGFloat			_headIndent;
	TKLineBreakMode _lineBreakMode;
	CGFloat			_lineHeightMultiple;
	CGFloat			_lineSpacing;
	CGFloat			_maximumLineHeight;
	CGFloat			_minimumLineHeight;
	CGFloat			_paragraphSpacing;
	CGFloat			_paragraphSpacingBefore;
	CGFloat			_tailIndent;	
}

@property (nonatomic, assign) TKTextAlignment textAlignment;
@property (nonatomic, assign) CGFloat firstLineHeadIndent;
@property (nonatomic, assign) CGFloat headIndent;
@property (nonatomic, assign) TKLineBreakMode lineBreakMode;
@property (nonatomic, assign) CGFloat lineHeightMultiple;
@property (nonatomic, assign) CGFloat lineSpacing;
@property (nonatomic, assign) CGFloat maximumLineHeight;
@property (nonatomic, assign) CGFloat minimumLineHeight;
@property (nonatomic, assign) CGFloat lineHeight;
@property (nonatomic, assign) CGFloat paragraphSpacing;
@property (nonatomic, assign) CGFloat paragraphSpacingBefore;
@property (nonatomic, assign) CGFloat tailIndent;

@end
