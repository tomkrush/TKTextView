#import "TKTextPosition.h"

@implementation TKTextPosition

@synthesize position = _position;

- (id)initWithPosition:(NSInteger)position
{
	if ( self = [super init] )
	{
		_position = position;
	}
		
	return self;
}

+ (id)textPositionWithPosition:(NSInteger)position
{
	return [[[TKTextPosition alloc] initWithPosition:position] autorelease];
}

+ (id)textPositionWithPosition:(NSInteger)position offset:(NSInteger)offset
{
	return [[[TKTextPosition alloc] initWithPosition:position + offset] autorelease];
}

+ (id)textPositionWithTextPosition:(TKTextPosition *)position offset:(NSInteger)offset
{
	return [[[TKTextPosition alloc] initWithPosition:position.position + offset] autorelease];
}

- (NSInteger)index
{
	return _position;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%d", _position];
}

- (NSComparisonResult)compare:(TKTextPosition *)textPosition;
{
	NSInteger position = textPosition.index;

	if ( _position < position )
	{
		return NSOrderedAscending;
	}
	else if ( _position == position )
	{
		return NSOrderedSame;
	}
	
	return NSOrderedDescending;
}

@end
