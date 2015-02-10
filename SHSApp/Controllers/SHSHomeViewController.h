//
//  SHSHomeViewController.h
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "EScrollerView.h"

@interface SHSHomeViewController : UIViewController <EScrollerViewDelegate, UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIView *calanderContainer;

@end
