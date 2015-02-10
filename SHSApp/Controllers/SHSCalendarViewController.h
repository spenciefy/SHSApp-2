//
//  SHSCalendarViewController.h
//  TheSHSApp
//
//  Created by Spencer Yen on 1/30/15.
//  Copyright (c) 2015 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SHSCalendarViewController : PFQueryTableViewController

@property (nonatomic, retain) NSMutableDictionary *sections;
@property (nonatomic, retain) NSMutableDictionary *sectionToMonthMap;
@property (nonatomic, retain) NSMutableDictionary *months;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end