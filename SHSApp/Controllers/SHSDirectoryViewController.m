//
//  SHSDirectoryViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/6/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSDirectoryViewController.h"
#import "SHSStaffDetailViewController.h"
#import "SHSStaffTableViewCell.h"

@interface SHSDirectoryViewController ()

@end

@implementation SHSDirectoryViewController {
    PFObject *selectedStaff;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

// Setup view UI and initialize
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    
    self.tableView.tableHeaderView = self.searchBar;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    self.searchResults = [NSMutableArray array];
}

// Load directory objects when view loads
- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadObjects];
}

// Setup search filtering results
- (void)filterResults:(NSString *)searchTerm {
    PFQuery *query = [PFQuery queryWithClassName:@"Staff"];
    [query whereKey:@"Name" containsString:searchTerm];
    query.limit = 20;
    
    [query findObjectsInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
}

// Update search table view when searching
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterResults:searchString];
    return YES;
}

// When search results are retrieved, reload table view
- (void)callbackWithResult:(NSArray *)teachers error:(NSError *)error
{
    if(!error) {
        [self.searchResults removeAllObjects];
        [self.searchResults addObjectsFromArray:teachers];
        [self.searchDisplayController.searchResultsTableView reloadData];
    }
}

// The className to query on Parse
- (id)initWithCoder:(NSCoder *)aCoder
{
    self = [super initWithCoder:aCoder];
    if (self) {
        self.parseClassName = @"Staff";
        self.pullToRefreshEnabled = NO;
        self.paginationEnabled = NO;
    }
    return self;
}

// Setup query to load the tableview
- (PFQuery *)queryForTable
{
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    query.limit = 1000;
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    [query orderByAscending:@"Name"];
    
    return query;
}

// Method called to reload tableview after objects loaded
- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    [self.tableView reloadData];
}

#pragma mark TableView Datasource

// Calculate total number of rows based on objects in Parse database
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.objects.count;
    } else {
        return self.searchResults.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 48;
}

// Populate tableview cells with Parse database objects
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    NSString *uniqueIdentifier = @"StaffCell";
    SHSStaffTableViewCell *cell = nil;
    
    cell = (SHSStaffTableViewCell *) [self.tableView dequeueReusableCellWithIdentifier:uniqueIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SHSStaffTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        cell.nameLabel.text = [object objectForKey:@"Name"];
        cell.typeLabel.text = [object objectForKey:@"Type"];
    }
    
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        PFObject *obj2 = [self.searchResults objectAtIndex:indexPath.row];
        cell.nameLabel.text = [obj2 objectForKey:@"Name"];
        cell.typeLabel.text = [obj2 objectForKey:@"Type"];
    }
    
    return cell;
}

// Push new view controller when table cell tapped
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != self.searchDisplayController.searchResultsTableView) {
        selectedStaff = [self.objects objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"PushStaffDetail" sender:self];
    }
    if ([tableView isEqual:self.searchDisplayController.searchResultsTableView]) {
        selectedStaff = [self.searchResults objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"PushStaffDetail" sender:self];
    }
}

#pragma mark - Navigation

// Load staff detail view variables when about to load view
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SHSStaffDetailViewController *detail = [segue destinationViewController];
    detail.staffInfo = selectedStaff;
}

@end