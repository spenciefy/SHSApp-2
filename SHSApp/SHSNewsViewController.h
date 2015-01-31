//
//  SHSNewsViewController.h
//  SHSApp
//
//  Created by Spencer Yen on 8/7/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHSNetworkClient.h"
#import "Article.h"

@interface SHSNewsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) NSString *selectedSection;
@property (nonatomic, strong) NSMutableArray *articles;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *spotlightButton;
@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *sportsButton;
@property (weak, nonatomic) IBOutlet UIButton *opinionButton;
@property (weak, nonatomic) IBOutlet UIButton *featuresButton;
@property (weak, nonatomic) IBOutlet UIButton *columnsButton;

- (IBAction)spotlightAction;
- (IBAction)newsAction;
- (IBAction)sportsAction;
- (IBAction)opinionAction;
- (IBAction)featuresAction;
- (IBAction)columnsAction;

@end
