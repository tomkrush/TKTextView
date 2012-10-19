//
//  TKScanner.m
//  TKScanner
//
//  Created by Tom Krush on 10/18/12.
//  Copyright (c) 2012 Tom Krush. All rights reserved.
//

#import "TKScanner.h"

const NSInteger TKScannerNoResult = -1;

NSString* m(NSString *expression, NSString *context, NSInteger *index)
{
    NSError *error = NULL;
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
        
    NSRange result = [regex rangeOfFirstMatchInString:context options:0 range:NSMakeRange(0, [context length])];
    
    if ( result.location == NSNotFound )
    {
        return nil;
    }
    
    NSLog(@"%d %d", result.location, result.length);
    
    *index = result.location;
    

    return [context substringWithRange:result];
}


@implementation TKScanner

@synthesize match = _match;

- (id)initWithString:(NSString *)text
{
    if ( self = [super init] ) 
    {
        _value = text;
        
        _pointer = 0;
        _previousPointer = 0;
        _end = [_value length] > 0 ? NO : YES;
    }
    
    return self;
}

/* Returns whether scanner has reached end of string. */
- (BOOL)eos
{
    return _end;
}

/* Set pointer position */
- (NSInteger)pos:(NSInteger)pos
{
    if ( pos == -1 )
    {
        pos = [_value length];
    }
    
    _previousPointer = _pointer;
    
    _pointer = pos;
    
    if ( _pointer >= [_value length] )
    {
        _end = YES;
    }
    
    return _pointer;
}

/* Get pointer position */
- (NSInteger)pos
{
    return _pointer;
}

/* Reset scanner pointer position to 0. Allows to scan again */
- (NSInteger)reset
{
    _end = NO;
    _pointer = 0;
    
    return _pointer;
}

- (NSString *)rest
{
    return [self peek];
}

- (NSString *)string
{
    return _value;
}

- (NSString *)peek
{
    return [_value substringFromIndex:_pointer];
}

- (NSString *)peek:(NSInteger)length
{
    return [_value substringWithRange:NSMakeRange(_pointer, length)];
}

- (NSInteger)exists:(NSString *)expression
{
    NSString *string = [self rest];
    
    NSInteger index = 0;
    NSString *match = m(expression, string, &index);
    
    if ( index >= 0 ) {
        self.match = match;
        
        return _pointer + index;
    }
    
    return TKScannerNoResult;
}

- (NSString *)getch
{
    if ( ! [self eos] ) 
    {
        NSString *string = [self peek:1];
        
        self.match = string;
        [self pos:_pointer + 1];
        
        return self.match;
    }
    
    return nil;
}

- (NSString *)scan:(NSString *)expression
{
    NSString *string = [self rest];
    NSInteger index = 0;
    
    NSString *match = m(expression, string, &index);
    
    if ( index == 0 )
    {    
        self.match = match;
        
        [self pos:_pointer + index + [match length]];
        
        return match;
    }
    
    return nil;
}

- (NSString *)scan_until:(NSString *)expression
{
    NSString *string = [self rest];
    NSInteger index = 0;
    
    NSString *match = m(expression, string, &index);
    
    if ( index >= 0 )
    {    
        self.match = match;
        
        [self pos:_pointer + index + [match length]];
        
        return match;
    } 

    return nil;
}

- (NSInteger)skip:(NSString *)expression
{
    [self scan:expression];
    NSString* match = self.match;
    self.match = nil;
    
    if ( match )
    {
        return [match length];
    }
    
    return TKScannerNoResult;
}

- (NSInteger)skip_until:(NSString *)expression
{
    NSInteger pos = [self pos];
    
    [self scan_until:expression];
    NSString *match = self.match;
    self.match = nil;
    
    if ( match )
    {
        return [self pos] - pos;
    }
    
    return -1;
}


- (NSInteger)unscan
{
    [self pos:_previousPointer];
    self.match = nil;
    
    return _pointer;
}


@end