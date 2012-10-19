//
//  TKScanner.h
//  TKScanner
//
//  Created by Tom Krush on 10/18/12.
//  Copyright (c) 2012 Tom Krush. All rights reserved.
//

#import <Foundation/Foundation.h>

const NSInteger TKScannerNoResult;

NSString* m(NSString *expression, NSString *context, NSInteger *index);

@interface TKScanner : NSObject {
    NSInteger _pointer;
    NSInteger _previousPointer;
    BOOL _end;
    NSString *_value;
    NSString *_match;
}

- (id)initWithString:(NSString *)text;
- (BOOL)eos;
- (NSInteger)pos:(NSInteger)pos;
- (NSInteger)pos;
- (NSInteger)reset;
- (NSString *)rest;
- (NSString *)string;
- (NSString *)peek;
- (NSString *)peek:(NSInteger)length;
- (NSInteger)exists:(NSString *)expression;
- (NSString *)getch;
- (NSString *)scan:(NSString *)expression;
- (NSString *)scan_until:(NSString *)expression;
- (NSInteger)skip:(NSString *)expression;
- (NSInteger)skip_until:(NSString *)expression;
- (NSInteger)unscan;

@property (nonatomic, retain) NSString *match;

@end
