//
//  SHSNewsViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/7/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSNewsViewController.h"
#import <UIImageView+WebCache.h>
#import "SVProgressHUD.h"
#import "SHSArticleViewController.h"
#include "REMenu.h"

@interface SHSNewsViewController ()

@end

@implementation SHSNewsViewController{
    int numberToReload;
    Article *selectedArticle;
    REMenu *menu;
    BOOL menuShown;
}
@synthesize selectedSection;
@synthesize articles;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    articles = [[NSMutableArray alloc] init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    _spotlightButton.backgroundColor = [UIColor lightGrayColor];
    _newsButton.backgroundColor = [UIColor clearColor];
    _sportsButton.backgroundColor = [UIColor clearColor];
    _opinionButton.backgroundColor = [UIColor clearColor];
    _featuresButton.backgroundColor = [UIColor clearColor];
    _columnsButton.backgroundColor = [UIColor clearColor];
    numberToReload = 10;
    [self setSelectedSection:@"spotlight"];
    
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(toggleMenu)];
    
    REMenuItem *Spotlight = [[REMenuItem alloc] initWithTitle:@"Spotlight"
                                                    subtitle:nil
                                                       image:nil
                                            highlightedImage:nil
                                                      action:^(REMenuItem *item) {
                                                          [self spotlightAction];
                                                          NSLog(@"Item: %@", item);
                                                      }];
    
    REMenuItem *Sports = [[REMenuItem alloc] initWithTitle:@"Sports"
                                                       subtitle:nil
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self sportsAction];
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    REMenuItem *Opinions = [[REMenuItem alloc] initWithTitle:@"Opinion"
                                                        subtitle:nil
                                                           image:nil
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item) {
                                                              [self opinionAction];
                                                              NSLog(@"Item: %@", item);
                                                          }];
    
    REMenuItem *Features = [[REMenuItem alloc] initWithTitle:@"Feature"
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self featuresAction];
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    REMenuItem *Columns = [[REMenuItem alloc] initWithTitle:@"Column"
                                                          image:nil
                                               highlightedImage:nil
                                                         action:^(REMenuItem *item) {
                                                             [self columnsAction];
                                                             NSLog(@"Item: %@", item);
                                                         }];
    
    menu = [[REMenu alloc] initWithItems:@[Spotlight, Sports, Opinions, Features, Columns]];
    menuShown = FALSE;
}

- (void)toggleMenu {
    if (!menu.isOpen) {
        [menu showFromNavigationController:self.navigationController];
    } else {
        [menu close];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setSelectedSection:(NSString *)section {
    selectedSection = section;
    NSString *count;
    if([section isEqualToString:@"spotlight"]){
        count = @"5";
    } else {
        count = @"20";
    }
    [articles removeAllObjects];
    [[SHSNetworkClient sharedInstance] getNidsForSection:section withCount:count completionBlock:^(NSArray *nids, NSError *error) {
        if(!error){
            for(NSString *nid in nids){
                [[SHSNetworkClient sharedInstance] getArticleForNid:nid completionBlock:^(Article *article, NSError *error) {
                        [articles addObject:article];
                        NSLog(@"article: %@", article.title);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView reloadData];
                    });
                }];
            }
            
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView*)table numberOfRowsInSection:(NSInteger)section
{
    if([selectedSection isEqualToString:@"spotlight"]){
        return self.articles.count;
    } else {
        return self.articles.count + 1;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  if (indexPath.row == articles.count && ![selectedSection isEqualToString:@"spotlight"]) {
      return 42;
    } else{
    if([selectedSection isEqualToString:@"spotlight"]){
            Article* article = [self.articles objectAtIndex:indexPath.row];
        
        UIFont *myFont = [UIFont systemFontOfSize:20];
        
        CGSize textSize = [article.title sizeWithFont: myFont constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        
        return 226 + textSize.height;
    } else {
        return 69;
    }
    }
}

- (UITableViewCell*)tableView:(UITableView*)table cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    UITableViewCell *cell;

    if (indexPath.row == articles.count && ![selectedSection isEqualToString:@"spotlight"]) {
        CellIdentifier = @"LoadMoreCell";
        
        cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
    } else {
    Article* article = [self.articles objectAtIndex:indexPath.row];
    if([selectedSection isEqualToString:@"spotlight"]){
        CellIdentifier = @"SpotlightCell";
       
    } else if ([article.photoURL isEqualToString:@""]){
        CellIdentifier = @"ArticleCell";
    } else {
        CellIdentifier = @"ArticleImageCell";
    }
    
    cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *imageView = (UIImageView*) [cell viewWithTag:100];
    imageView.clipsToBounds = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:article.photoURL]];
        
//    UIImage *image = imageView.image;
//    CGFloat scale = image.scale;
//    UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextTranslateCTM(context, 0, image.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    
//    CGContextSetBlendMode(context, kCGBlendModeMultiply);
//    CGRect rect = CGRectMake(0, 0, image.size.width * scale, image.size.height * scale);
//    CGContextDrawImage(context, rect, image.CGImage);
//    
//    
//    UIColor *colorOne = [UIColor blackColor];
//    UIColor *colorTwo =  [UIColor clearColor];
//    
//    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, (id)colorTwo.CGColor, nil];
//    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient = CGGradientCreateWithColors(space, (CFArrayRef)colors, NULL);
//    
//    CGContextClipToMask(context, rect, image.CGImage);
//    CGContextDrawLinearGradient(context, gradient, CGPointMake(0,0), CGPointMake(0,image.size.height * scale), 0);
//    UIImage *gradientImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    [imageView setImage: gradientImage];

    
    UILabel *titleLabel = (UILabel*) [cell viewWithTag:101];
    titleLabel.numberOfLines = 2;
    //titleLabel.adjustsFontSizeToFitWidth = YES;
    titleLabel.text = article.title;
        UIFont *myFont = [UIFont systemFontOfSize:20];

        CGSize textSize = [article.title sizeWithFont: myFont constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        
        titleLabel.frame = CGRectMake(8, 4, 300, textSize.height);
        
    UILabel *authorLabel = (UILabel*) [cell viewWithTag:102];
    authorLabel.adjustsFontSizeToFitWidth = YES;
    authorLabel.text = article.author;
    titleLabel.frame = CGRectMake(8, textSize.height+4, 180, 21);
    
    UILabel *dateLabel = (UILabel*) [cell viewWithTag:103];
        dateLabel.frame = CGRectMake(216, textSize.height+4, 96, 21);
        
    if([selectedSection isEqualToString:@"spotlight"]){
        dateLabel.text = [NSString stringWithFormat:@"Posted: %@",article.date];
    } else{
        dateLabel.text = [NSString stringWithFormat:@"%@",article.date];
    }
    
    }
    return cell;

}
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
//    if(![selectedSection isEqualToString:@"spotlight"]){
//    CGPoint offset = aScrollView.contentOffset;
//    CGRect bounds = aScrollView.bounds;
//    CGSize size = aScrollView.contentSize;
//    UIEdgeInsets inset = aScrollView.contentInset;
//    float y = offset.y + bounds.size.height - inset.bottom;
//    float h = size.height;
//    float reload_distance = 10;
//    if(y > h + reload_distance)
//    {
//        numberToReload += 10;
//        NSString *reloadnum = [NSString stringWithFormat:@"%d", numberToReload];
//        [[SHSNetworkClient sharedInstance] getNidsForSection:selectedSection withCount:reloadnum completionBlock:^(NSArray *nids, NSError *error) {
//            if(!error){
//                for(int index = 0; index < nids.count; index++){
//                    NSString *nid = [nids objectAtIndex:index];
//                    [[SHSNetworkClient sharedInstance] getArticleForNid:nid completionBlock:^(Article *article, NSError *error) {
//                            [articles addObject:article];
//                            NSLog(@"article: %@", article.title);
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            [self.tableView reloadData];
//                        });
//                    }];
//                }
//                
//            }
//        }];
//    }
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == articles.count && ![selectedSection isEqualToString:@"spotlight"]) {
        numberToReload += 10;
        NSString *reloadnum = [NSString stringWithFormat:@"%d", numberToReload];
        [[SHSNetworkClient sharedInstance] getNidsForSection:selectedSection withCount:reloadnum completionBlock:^(NSArray *nids, NSError *error) {
            if(!error){
                for(int index = 0; index < nids.count; index++){
                    NSString *nid = [nids objectAtIndex:index];
                    [[SHSNetworkClient sharedInstance] getArticleForNid:nid completionBlock:^(Article *article, NSError *error) {
                        [articles addObject:article];
                        NSLog(@"article: %@", article.title);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.tableView reloadData];
                        });
                    }];
                }
                
            }
        }];
    } else {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    selectedArticle = [self.articles objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"PushArticleDetail" sender:self];
    }
}

- (IBAction)spotlightAction{
    if(![selectedSection isEqualToString:@"spotlight"]){
        _spotlightButton.backgroundColor = [UIColor lightGrayColor];
        _newsButton.backgroundColor = [UIColor clearColor];
        _sportsButton.backgroundColor = [UIColor clearColor];
        _opinionButton.backgroundColor = [UIColor clearColor];
        _featuresButton.backgroundColor = [UIColor clearColor];
        _columnsButton.backgroundColor = [UIColor clearColor];
        [self setSelectedSection:@"spotlight"];

    }
}

- (IBAction)newsAction{
    if(![selectedSection isEqualToString:@"news"]){
        _newsButton.backgroundColor = [UIColor lightGrayColor];
        _spotlightButton.backgroundColor = [UIColor clearColor];
        _sportsButton.backgroundColor = [UIColor clearColor];
        _opinionButton.backgroundColor = [UIColor clearColor];
        _featuresButton.backgroundColor = [UIColor clearColor];
        _columnsButton.backgroundColor = [UIColor clearColor];
        [self setSelectedSection:@"news"];

    }
}

- (IBAction)sportsAction{
    if(![selectedSection isEqualToString:@"sports"]){
        _newsButton.backgroundColor = [UIColor clearColor];
        _spotlightButton.backgroundColor = [UIColor clearColor];
        _sportsButton.backgroundColor = [UIColor lightGrayColor];
        _opinionButton.backgroundColor = [UIColor clearColor];
        _featuresButton.backgroundColor = [UIColor clearColor];
        _columnsButton.backgroundColor = [UIColor clearColor];
        [self setSelectedSection:@"sports"];

    }
    
}

- (IBAction)opinionAction{
    if(![selectedSection isEqualToString:@"opinion"]){
        _newsButton.backgroundColor = [UIColor clearColor];
        _spotlightButton.backgroundColor = [UIColor clearColor];
        _sportsButton.backgroundColor = [UIColor clearColor];
        _opinionButton.backgroundColor = [UIColor lightGrayColor];
        _featuresButton.backgroundColor = [UIColor clearColor];
        _columnsButton.backgroundColor = [UIColor clearColor];
        [self setSelectedSection:@"opinion"];

    }
}
- (IBAction)featuresAction{
    if(![selectedSection isEqualToString:@"features"]){
        _newsButton.backgroundColor = [UIColor clearColor];
        _spotlightButton.backgroundColor = [UIColor clearColor];
        _sportsButton.backgroundColor = [UIColor clearColor];
        _opinionButton.backgroundColor = [UIColor clearColor];
        _featuresButton.backgroundColor = [UIColor lightGrayColor];
        _columnsButton.backgroundColor = [UIColor clearColor];
        [self setSelectedSection:@"features"];

    }
}

- (IBAction)columnsAction{
    if(![selectedSection isEqualToString:@"columns"]){
        _newsButton.backgroundColor = [UIColor clearColor];
        _spotlightButton.backgroundColor = [UIColor clearColor];
        _sportsButton.backgroundColor = [UIColor clearColor];
        _opinionButton.backgroundColor = [UIColor clearColor];
        _featuresButton.backgroundColor = [UIColor clearColor];
        _columnsButton.backgroundColor = [UIColor lightGrayColor];
        [self setSelectedSection:@"columns"];

    }
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SHSArticleViewController *vc = [segue destinationViewController];
    vc.article = selectedArticle;
    
}

@end
