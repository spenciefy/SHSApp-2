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
    
    NSArray *images = @[];
    for (int x = 1; x <= 14; x++) {
        NSString *imgName = [NSString stringWithFormat:@"%i.jpg", x];
        images = [images arrayByAddingObject:imgName];
    }
    
    EScrollerView *imageScroller = [[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/3) imageArray: images];
    imageScroller.delegate = self;
    [self.view addSubview:imageScroller];
    
    self.calanderContainer.frame = CGRectMake(self.calanderContainer.frame.origin.x, imageScroller.frame.origin.y + imageScroller.frame.size.height, self.calanderContainer.frame.size.width, self.calanderContainer.frame.size.width);
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    infoButton.tintColor = [UIColor whiteColor];
    [infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    infoButton.center = CGPointMake(self.view.frame.size.width - 25, 25);
    [self.view addSubview:infoButton];
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

- (void)infoButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"More info"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Call School",@"Email School", @"Open Address in Maps", @"Go to School Website", nil];
    [actionSheet showInView:self.view];

}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0) {
        //call school
    } else if(buttonIndex == 1){
        //email school
    } else if(buttonIndex == 2) {
    //open address in maps
    } else if(buttonIndex == 3) {
        //go to school website
    }
}



@end
