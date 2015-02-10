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
        self.objectsPerPage = 1000;
        self.sections = [NSMutableDictionary dictionary];
        self.sectionToMonthMap = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CALENDAR_CLASS_NAME];
    query.limit = 1000;
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
    return [self.sectionToMonthMap objectForKey:[NSNumber numberWithInt:(int)section]];
}

- (NSString *)monthStringForSection:(NSInteger)section {
    NSString *month = [self monthForSection:section];
    if([month isEqualToString:@"1"]) {
        return @"January";
    } else if ([month isEqualToString:@"2"]) {
        return @"February";
    } else if ([month isEqualToString:@"3"]) {
        return @"March";
    } else if ([month isEqualToString:@"4"]) {
        return @"April";
    } else if ([month isEqualToString:@"5"]) {
        return @"May";
    } else if ([month isEqualToString:@"6"]) {
        return @"June";
    } else if ([month isEqualToString:@"7"]) {
        return @"July";
    } else if ([month isEqualToString:@"8"]) {
        return @"August";
    } else if ([month isEqualToString:@"9"]) {
        return @"September";
    } else if ([month isEqualToString:@"10"]) {
        return @"October";
    } else if ([month isEqualToString:@"11"]) {
        return @"November";
    } else if ([month isEqualToString:@"12"]) {
        return @"December";
    }
    
    return @"";
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    [self.sections removeAllObjects];
    [self.sectionToMonthMap removeAllObjects];
    
    NSInteger section = 0;
    NSInteger rowIndex = 0;
    for (PFObject *object in self.objects) {
        NSString *month = [object objectForKey:@"Month"];

        NSMutableArray *objectsInSection = [self.sections objectForKey:month];
        if (!objectsInSection) {
            objectsInSection = [NSMutableArray array];
            [self.sectionToMonthMap setObject:month forKey:[NSNumber numberWithInt:(int)section++]];
        }
        
        [objectsInSection addObject:[NSNumber numberWithInt:(int)rowIndex++]];
        [self.sections setObject:objectsInSection forKey:month];
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        NSDate *date = [NSDate date];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
        NSInteger month = [components month];
        [self.tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection:month - 1]
                              atScrollPosition: UITableViewScrollPositionTop
                                      animated: TRUE];
    });
   
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
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 40)];
    [view setBackgroundColor:[UIColor colorWithRed:194/255.0 green:0 blue:0 alpha:1]];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 7, tableView.frame.size.width, 18)];
    [label setFont:[UIFont fontWithName:@"AvenirNext-Medium" size:20]];
    [label setTextColor:[UIColor whiteColor]];
    NSString *month = [self monthStringForSection:section];
    [label setText:month];
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleString = [[self.objects objectAtIndex:indexPath.row]objectForKey:@"Title"];
    if([[self.objects objectAtIndex:indexPath.row] objectForKey:@"Description"]){
        NSString *bodyString = [[self.objects objectAtIndex:indexPath.row]objectForKey:@"Description"];
        CGSize constraint = CGSizeMake(self.view.frame.size.width-85, MAXFLOAT);
        
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AvenirNext-Medium" size:19.0] forKey:NSFontAttributeName];
        CGRect titleSize = [titleString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil];

        NSDictionary *descriptionAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AvenirNext-Regular" size:17.0] forKey:NSFontAttributeName];
        CGRect descriptionSize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:descriptionAttributes context:nil];

        return titleSize.size.height + descriptionSize.size.height + 25;
    } else {
        CGSize constraint = CGSizeMake(self.view.frame.size.width-85, MAXFLOAT);
        
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AvenirNext-Medium" size:19.0] forKey:NSFontAttributeName];
        CGRect titleSize = [titleString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil];
        
        if(titleSize.size.height > 70) {
            return titleSize.size.height + 10;
        } else {
            return 73;
        }
    }
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
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:1];
    UILabel *descriptionLabel = (UILabel*) [cell viewWithTag:2];
    descriptionLabel.text = [object objectForKey:@"Description"];
    titleLabel.numberOfLines = 0;
    titleLabel.text = [object objectForKey:@"Title"];
    
    if([object objectForKey:@"Description"]){
        NSString *titleString = [object objectForKey:@"Title"];
        
        NSString *bodyString = [object objectForKey:@"Description"];
        CGSize constraint = CGSizeMake(self.view.frame.size.width-85, MAXFLOAT);
        
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AvenirNext-Medium" size:19.0] forKey:NSFontAttributeName];
        CGRect titleSize = [titleString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil];
        
        NSDictionary *descriptionAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AvenirNext-Regular" size:17.0] forKey:NSFontAttributeName];
        CGRect descriptionSize = [bodyString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:descriptionAttributes context:nil];

        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, 7, self.view.frame.size.width-85, titleSize.size.height);
        descriptionLabel.frame = CGRectMake(descriptionLabel.frame.origin.x, titleLabel.frame.origin.y + titleLabel.frame.size.height + 4, self.view.frame.size.width-85, descriptionSize.size.height);
    } else {
        descriptionLabel.text = @"";
        NSString *titleString = [object objectForKey:@"Title"];
        CGSize constraint = CGSizeMake(self.view.frame.size.width-85, MAXFLOAT);
    
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObject:[UIFont fontWithName:@"AvenirNext-Medium" size:19.0] forKey:NSFontAttributeName];
        CGRect titleSize = [titleString boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:titleAttributes context:nil];
        
        titleLabel.frame = CGRectMake(titleLabel.frame.origin.x, 7, self.view.frame.size.width-85, titleSize.size.height);
    }

    UILabel *dateLabel = (UILabel*)[cell viewWithTag:3];
    NSString *timeString = [object objectForKey:@"Start"];
    NSDateFormatter *stringDateFormatter = [[NSDateFormatter alloc] init];
    [stringDateFormatter setDateFormat:@"MM/dd/yyyy HH:mm"];
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [stringDateFormatter dateFromString:timeString];
    
    NSDateFormatter *dayFormatter = [[NSDateFormatter alloc] init];
    [dayFormatter setDateFormat:@"d"];
    dateLabel.text = [dayFormatter stringFromDate:dateFromString];

    UILabel *timeLabel = (UILabel*)[cell viewWithTag:4];
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"h a"];
    timeLabel.text = [timeFormatter stringFromDate:dateFromString];

    int day = dateLabel.text.intValue;
    if(day >= 10) {
    //3    timeLabel.center = CGPointMake(dateLabel.center.x, timeLabel.center.y);
    }
    
    UILabel *timeSuffixLabel = (UILabel*)[cell viewWithTag:5];
    NSString *dateLastNumber = [dateLabel.text substringFromIndex: [dateLabel.text length] - 1];

    if([dateLastNumber isEqualToString:@"1"]) {
        timeSuffixLabel.text = @"st";
    } else if ([dateLastNumber isEqualToString:@"2"]) {
        timeSuffixLabel.text = @"nd";
    } else if ([dateLastNumber isEqualToString:@"3"]) {
        timeSuffixLabel.text = @"rd";
    } else {
        timeSuffixLabel.text = @"th";
    }
    
    return cell;
}

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