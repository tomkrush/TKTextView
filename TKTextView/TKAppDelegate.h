//
//  TKAppDelegate.h
//  TKTextView
//
//  Created by Tom Krush on 10/18/12.
//  Copyright (c) 2012 Tom Krush. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TKViewController;

@interface TKAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) TKViewController *viewController;

@end
