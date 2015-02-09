//
//  SHSHomeViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSHomeViewController.h"
#import "EScrollerView.h"

@implementation SHSHomeViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    NSArray *images = @[@"1.jpg", @"2.jpg", @"3.jpg"];
    
    EScrollerView *imageScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3) imageArray: images];
    imageScroller.delegate = self;
    [self.view addSubview:imageScroller];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Calendar"];
    query.limit = 1000;
    NSArray *asd = [query findObjects];
    
    self.calanderContainer.frame = CGRectMake(self.calanderContainer.frame.origin.x, imageScroller.frame.origin.y + imageScroller.frame.size.height, self.calanderContainer.frame.size.width, self.calanderContainer.frame.size.width);
    
    NSLog(@"wefwefew %f", imageScroller.frame.size.height);
    NSLog(@"wefwefew %f", self.calanderContainer.frame.origin.y);
}

- (void)viewDidLayoutSubviews{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
}


- (void)viewWillDisappear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [super viewWillDisappear:animated];
}

@end
