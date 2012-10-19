//
//  TKViewController.m
//  TKTextView
//
//  Created by Tom Krush on 10/18/12.
//  Copyright (c) 2012 Tom Krush. All rights reserved.
//

#import "TKViewController.h"
#import "TKTextView.h"

@interface TKViewController ()

@end

@implementation TKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    TKTextView *textView = [[TKTextView alloc] initWithText:@"This is some text and a <a href=\"http://google.com\">Link</a>" showLinks:YES];
    textView.inset = UIEdgeInsetsMake(10, 20, 15, 20);
    textView.frame = self.view.bounds;
    textView.opaque = NO;
    [self.view addSubview:textView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
