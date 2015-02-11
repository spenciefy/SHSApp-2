//
//  SHSBellScheduleViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSBellScheduleViewController.h"

@interface SHSBellScheduleViewController ()

@end

@implementation SHSBellScheduleViewController{
    NSString *dayName;
    NSDate *endTime;
}

@synthesize tableView, timerLabel;

// Setup UI and variables
- (void)viewDidLoad
{
    [super viewDidLoad];
    segment = 0;
    timerLabel.adjustsFontSizeToFitWidth = YES;
}

// Setup UI
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateCounter];
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateCounter) userInfo:nil repeats:YES];

    NSArray *itemArray = [NSArray arrayWithObjects: @"M", @"T", @"W", @"TH", @"F", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    segmentedControl.frame = CGRectMake(85,25,150,30);
    [segmentedControl addTarget:self action:@selector(changeView:)
               forControlEvents:UIControlEventValueChanged];
    
    [[UISegmentedControl appearance] setTintColor:[UIColor whiteColor]];
    
    NSDate *today = [NSDate date];
    NSDateFormatter *numFormatter = [[NSDateFormatter alloc] init];
    [numFormatter setDateFormat:@"c"]; // day number, like 7 for saturday
    NSString *dayOfWeekNum = [numFormatter stringFromDate:today];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEEE"];
    dayName = [dayFormatter stringFromDate:today];
    if([dayName isEqualToString:@"Saturday"] || [dayName isEqualToString:@"Sunday"]){
        segmentedControl.selectedSegmentIndex = 0;
        dayName = @"Monday";
    } else {
        segmentedControl.selectedSegmentIndex = [dayOfWeekNum intValue]-2;
    }
    self.parseClassName = dayName;
    [self.tableView reloadData];
    
    self.navigationItem.titleView = segmentedControl;
    [self.tableView reloadData];
    
    [self loadObjects];
}

// Update timer
- (void)updateCounter {
    endTime = [self getEndTime];
    if(!endTime){
        timerLabel.text = @" School's Out!";
    } else {
        NSUInteger flags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
        NSDateComponents *components = [[NSCalendar currentCalendar] components:flags fromDate:[NSDate date] toDate:endTime options:0];
 
        timerLabel.text = [NSString stringWithFormat:@"%ld hour, %ld minutes and %ld seconds left", (long)[components hour], (long)[components minute], (long)[components second]];
    }
}

// Query parse to get current day and end time for current period at school, return Date with closest period end time
-(NSDate *) getEndTime {
    if (segment == 0) {
        self.parseClassName = @"Monday";
    } else if (segment == 1) {
        self.parseClassName = @"Thursday";
    } else if (segment == 2) {
        self.parseClassName = @"Wednesday";
    } else if(segment == 3) {
        self.parseClassName = @"Thursday";
    } else if (segment == 4) {
        self.parseClassName = @"Friday";
    }
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"EEEE"];
    dayName = [dayFormatter stringFromDate:[NSDate date]];
    if([dayName isEqualToString:@"Saturday"] || [dayName isEqualToString:@"Sunday"]){
        dayName = @"Monday";
    }
    PFQuery *query = [PFQuery queryWithClassName:dayName];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HHmm"];
    [timeFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [timeFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
    NSString *nowTime = [timeFormatter stringFromDate:[NSDate date]];
    NSNumber *nowInteger= [NSNumber numberWithInt:[nowTime intValue]];
    [query whereKey:@"endTime" greaterThan:nowInteger];
    [query orderByAscending:@"endTime"];
    PFObject *dayObject = [[query findObjects] firstObject];
    [dayObject saveInBackground];

    NSNumber *endTimeN = [dayObject objectForKey:@"endTime"];

    if([query findObjects].count == 0) {
        return nil;
    }

    NSString *dateString;
    if([endTimeN intValue] < 999) {
        dateString = [NSString stringWithFormat:@"0%@", endTimeN];
    } else {
        dateString = [NSString stringWithFormat:@"%@", endTimeN];
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"M/d/yyyy HHmm"];
    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"PST"]];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSString *datestr = [NSString stringWithFormat:@"%ld/%ld/%ld %@",(long)month,(long)day,(long)year,dateString];
    NSDate *dateFromString = [dateFormatter dateFromString:datestr];

    return dateFromString;
}

// Change the view based on the day of the week
-(void)changeView: (id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    
    if (selectedSegment == 0) {
        self.parseClassName = @"Monday";
        [self loadObjects];
        [self.tableView reloadData];
    } else if (selectedSegment == 1) {
        self.parseClassName = @"Tuesday";
        [self loadObjects];
        [self.tableView reloadData];
    } else if (selectedSegment == 2) {
        self.parseClassName = @"Wednesday";
        [self loadObjects];
        [self.tableView reloadData];
    } else if(selectedSegment == 3) {
        self.parseClassName = @"Thursday";
        [self loadObjects];
        [self.tableView reloadData];
    } else if (selectedSegment == 4) {
        self.parseClassName = @"Friday";
        [self loadObjects];
        [self.tableView reloadData];
    }
    
    segment = (int)selectedSegment;
}

// Setup Parse information
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        // The Parse className to query on
        self.parseClassName = dayName;
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        
    }
    return self;
}

// Setups query to load tableview
- (PFQuery *)queryForTable
{
    if(self.parseClassName){
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByAscending:@"endTime"];
    
    return query;
    }
    return nil;
}

// Checks if objects load correctly and update tableview
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.tableView reloadData];
}

#pragma mark TableView datasource 
// Set number of rows tp display in tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.objects.count > 0) {
        return self.objects.count;
    }
    return 0;
}

// Set height for cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (self.tableView.frame.size.height - 44 - 64 - 44)/self.objects.count;
}

// Populate cell based on Parse database
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *simpleTableIdentifier = @"PeriodCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    int cellHeight = (self.tableView.frame.size.height - 44 - 64 - 44)/self.objects.count;
    
    UILabel *periodLabel = (UILabel*) [cell viewWithTag:100];
    periodLabel.center = CGPointMake(periodLabel.center.x, cellHeight/2);
    periodLabel.adjustsFontSizeToFitWidth = YES;
    periodLabel.text = [object objectForKey:@"period"];
    
    UILabel *timeLabel = (UILabel*) [cell viewWithTag:101];
    timeLabel.center = CGPointMake(timeLabel.center.x, cellHeight/2);
    timerLabel.adjustsFontSizeToFitWidth = YES;
    timeLabel.text = [object objectForKey:@"time"];
    
    return cell;
}

// iOS 8 specific code to remove tableview separator inset
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

@end
