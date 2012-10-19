#import <UIKit/UIKit.h>

@class TKTextPosition;

@interface TKTextRange : UITextRange <NSCopying>
{
	CFRange _range; 
}

- (id)initWithRange:(CFRange)range;
- (id)initWithStandardRange:(NSRange)range;

- (id)initWithStart:(UITextPosition *)start end:(UITextPosition *)end;
- (id)initWithStart:(UITextPosition *)start length:(NSUInteger)length;


+ (id)rangeWithRange:(CFRange)range;
+ (id)rangeWithStandardRange:(NSRange)range;

+ (id)rangeWithStart:(UITextPosition *)start end:(UITextPosition *)end;
+ (id)rangeWithStart:(UITextPosition *)start length:(NSUInteger)length;

@property(nonatomic, readonly) CFRange range;
@property(nonatomic, readonly) NSRange standardRange;
@property(nonatomic, readonly, getter=isEmpty) BOOL empty;

@property(nonatomic, readonly) UITextPosition *start;

@property(nonatomic, readonly) UITextPosition *end;

@end
