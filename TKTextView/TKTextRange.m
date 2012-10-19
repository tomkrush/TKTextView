#import "TKTextRange.h"
#import "TKTextPosition.h"

@implementation TKTextRange

@synthesize range = _range;

- (id)initWithRange:(CFRange)range
{
	if ( self = [super init] )
	{
		_range = range;
	}
	
	return self;
}

- (id)initWithStandardRange:(NSRange)range
{
	return [self initWithRange:CFRangeMake(range.location, range.length)];
}

- (id)initWithStart:(TKTextPosition *)start end:(TKTextPosition *)end
{
	return [self initWithRange:CFRangeMake(start.position, end.position - start.position)];
}

- (id)initWithStart:(TKTextPosition *)start length:(NSUInteger)length
{
	return [self initWithRange:CFRangeMake(start.index, length)];
}

+ (id)rangeWithRange:(CFRange)range
{
	return [[[TKTextRange alloc] initWithRange:range] autorelease];
}

+ (id)rangeWithStandardRange:(NSRange)range
{
	return [[[TKTextRange alloc] initWithStandardRange:range] autorelease];
}

+ (id)rangeWithStart:(TKTextPosition *)start end:(TKTextPosition *)end
{
	return [[[TKTextRange alloc] initWithStart:start end:end] autorelease];
}

+ (id)rangeWithStart:(TKTextPosition *)start length:(NSUInteger)length
{
	return [[[TKTextRange alloc] initWithStart:start length:length] autorelease];
}

- (NSRange)standardRange
{
	return NSMakeRange(_range.location, _range.length);
}

- (BOOL)isEmpty
{
	return _range.location - _range.length == 0;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"start:%@ end: %@", [TKTextPosition textPositionWithPosition:_range.location], [TKTextPosition textPositionWithPosition:_range.location + _range.length] ];
}

- (UITextPosition *)start
{
	return [TKTextPosition textPositionWithPosition:_range.location];
}

- (UITextPosition *)end
{
	return [TKTextPosition textPositionWithPosition:_range.location + _range.length];
}

#pragma mark -
#pragma mark NSCopying;

- (id)copyWithZone:(NSZone *)zone
{
	TKTextRange *copy = [[[self class] allocWithZone: zone] initWithStart:[self start] end:[self end]];
	
	return copy;
}

@end
