//
//  SHSCalendarViewController.m
//  TheSHSApp
//
//  Created by Spencer Yen on 1/30/15.
//  Copyright (c) 2015 Spencer Yen. All rights reserved.
//

#import "SHSCalendarViewController.h"

#define PARSE_CALENDAR_CLASS_NAME @"Calendar"

@implementation SHSCalendarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Calendar"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for(int i = 0; i < objects.count; i++){
                    NSString *title = [objects[i] objectForKey:@"Title"];
                    NSLog(@"%@", title);
                    [self.tableView reloadData];
                }
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadObjects];
}

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        self.textKey = @"Title";
        
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
        self.objectsPerPage = 150;
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToMonthMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CALENDAR_CLASS_NAME];
    
    // If Pull To Refresh is enabled, query against the network by default.
    if (self.pullToRefreshEnabled) {
        query.cachePolicy = kPFCachePolicyNetworkOnly;
    }
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // Order by company
    [query orderByAscending:@"Start"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    return query;
}

- (NSString *)monthForSection:(NSInteger)section {
    NSLog(@"%ld section ", (long)section);
    return [self.sectionToMonthMap objectForKey:[NSNumber numberWithInt:section]];
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    [self.sections removeAllObjects];
    [self.sectionToMonthMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSLog(@"object: %@", object);
        NSString *month = [object objectForKey:@"Month"];
        NSMutableArray *objectsInSection = [self.sections objectForKey:month];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            
            // this is the first time we see this company - increment the section index
            [self.sectionToMonthMap setObject:month forKey:[NSNumber numberWithInt:section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:rowIndex++]];
        [self.sections setObject:objectsInSection forKey:month];
    }
    [self.tableView reloadData];
}


- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    NSString *company = [self monthForSection:indexPath.section];
    
    NSArray *rowIndecesInSection = [self.sections objectForKey:company];
    NSNumber *rowIndex = [rowIndecesInSection objectAtIndex:indexPath.row];
    return [self.objects objectAtIndex:[rowIndex intValue]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sections.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *month = [self monthForSection:section];
    NSArray *rowIndecesInSection = [self.sections objectForKey:month];
    return rowIndecesInSection.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *month = [self monthForSection:section];
    return month;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    [view setBackgroundColor:[UIColor lightGrayColor]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Regular" size:16]];
    [label setTextColor:[UIColor whiteColor]];
    NSString *month = [self monthForSection:section];
    [label setText:month];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 82;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    static NSString *eventCellIdentifier = @"CalendarCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:eventCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:eventCellIdentifier];
    }
        
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:100];
    titleLabel.text = [object objectForKey:@"name"];
    
    UILabel *detailLabel = (UILabel*) [cell viewWithTag:101];
    if([object objectForKey:@"Where"]){
        detailLabel.text = [object objectForKey:@"Where"];
    } else {
        detailLabel.text = @"";
    }

    UILabel *dateLabel = (UILabel*)[cell viewWithTag:103];
    NSString *timeString = [object objectForKey:@"Start"];
    NSDateFormatter *stringDateFormatter = [[NSDateFormatter alloc] init];
    [stringDateFormatter setDateFormat:@"MM-DD-YYYY hh:mm"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [stringDateFormatter dateFromString:timeString];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"dd"];
    dateLabel.text = [dayFormatter stringFromDate:dateFromString];

    UILabel *timeLabel = (UILabel*)[cell viewWithTag:104];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"m a"];
    timeLabel.text = [dayFormatter stringFromDate:dateFromString];

    
    return cell;
}

@end