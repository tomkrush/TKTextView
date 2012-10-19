#import <UIKit/UIKit.h>

@interface TKTextPosition : UITextPosition 
{
	NSInteger _position;
}

- (id)initWithPosition:(NSInteger)position;

+ (id)textPositionWithPosition:(NSInteger)position;

+ (id)textPositionWithPosition:(NSInteger)position offset:(NSInteger)offset;

+ (id)textPositionWithTextPosition:(UITextPosition *)position offset:(NSInteger)offset;

- (NSComparisonResult)compare:(UITextPosition *)textPosition;


@property (nonatomic, readonly) NSInteger position;
@property (nonatomic, readonly) NSInteger index;

@end
