//
//  SHSBellScheduleViewController.h
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface SHSBellScheduleViewController : PFQueryTableViewController <UITableViewDelegate, UITableViewDataSource>
{
    int segment;
}
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end
