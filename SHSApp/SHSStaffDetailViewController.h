//
//  SHSStaffDetailViewController.h
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVWebViewController.h"
#import <Parse/Parse.h>

@interface SHSStaffDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scroll;
@property (nonatomic, strong) PFObject *staffInfo;

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
- (IBAction)emailAction:(id)sender;
- (IBAction)callAction:(id)sender;
- (IBAction)websiteAction:(id)sender;

@end