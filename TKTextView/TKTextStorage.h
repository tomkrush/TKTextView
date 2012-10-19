#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
#import "TKParagraphStyle.h"

const NSString *TKTextBackgroundAttributeName;
const NSString *TKTextLinkAttributeName;

enum
{
	TKTextUnderlineNone			= kCTUnderlineStyleNone,
	TKTextUnderlineSingle		= kCTUnderlineStyleSingle,
	TKTextUnderlineThick		= kCTUnderlineStyleThick,
	TKTextUnderlineDouble		= kCTUnderlineStyleDouble
};
typedef int32_t TKTextUnderlineStyle;

@interface TKTextStorage : NSMutableAttributedString
{
	NSMutableAttributedString *_mutableAttributedString;
	
	CFMutableDictionaryRef _cachedFonts;
}

- (id)init;

- (id)initWithString:(NSString *)string;

- (id)initWithString:(NSString *)string links:(BOOL)links;

- (void)setFont:(UIFont *)font;
- (void)setFont:(UIFont *)font forRange:(CFRange)range;

- (void)setKerning:(CGFloat)kerning;
- (void)setKerning:(CGFloat)kerning forRange:(CFRange)range;

- (void)setLink:(NSURL *)url;
- (void)setLink:(NSURL *)url forRange:(CFRange)range;

- (void)setUnderline:(TKTextUnderlineStyle)textUnderlineMode;
- (void)setUnderline:(TKTextUnderlineStyle)textUnderlineMode forRange:(CFRange)range;

- (void)setUnderlineColor:(UIColor *)color;
- (void)setUnderlineColor:(UIColor *)color forRange:(CFRange)range;

- (void)setStrokeColor:(UIColor *)color;
- (void)setStrokeColor:(UIColor *)color forRange:(CFRange)range;

- (void)setStrokeWidth:(CGFloat)width;
- (void)setStrokeWidth:(CGFloat)width forRange:(CFRange)range;

- (void)setForegroundColor:(UIColor *)color;
- (void)setForegroundColor:(UIColor *)color forRange:(CFRange)range;

- (void)setBackgroundColor:(UIColor *)color;
- (void)setBackgroundColor:(UIColor *)color forRange:(CFRange)range;

- (void)setParagraphStyle:(TKParagraphStyle *)paragraphStyle;
- (void)setParagraphStyle:(TKParagraphStyle *)paragraphStyle forRange:(CFRange)range;

- (void)beginEditing;
- (void)endEditing;

@property (nonatomic, copy) NSString *text;
@property (nonatomic, readonly) NSMutableAttributedString *attributedString;

@end
