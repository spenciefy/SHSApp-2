//
//  SHSMeViewController.h
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IDMPhotoBrowser.h"

@interface SHSMeViewController : UIViewController <IDMPhotoBrowserDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet UIButton *idButton;
- (IBAction)aeriesButton:(id)sender;
- (IBAction)navianceAction:(id)sender;
- (IBAction)canvasAction:(id)sender;

@end
