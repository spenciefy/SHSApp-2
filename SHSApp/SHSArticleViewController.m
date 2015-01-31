//
//  SHSArticleViewController.m
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import "SHSArticleViewController.h"
#import "Article.h"
#import "NSAttributedString+Attributes.h"
#import "OHAttributedLabel.h"
#import <UIImageView+WebCache.h>

@interface SHSArticleViewController ()

@end

@implementation SHSArticleViewController
@synthesize titleLabel, banner, author, caption, dateLabel, articleTextView, article;
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
    // Do any additional setup after loading the view.
    self.detailScrollView.delegate = self;
    [self.articleTextView setScrollEnabled:NO];
    titleLabel.text = article.title;
    titleLabel.numberOfLines = 1;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    caption.adjustsFontSizeToFitWidth = YES;
    author.adjustsFontSizeToFitWidth = YES;
    self.detailScrollView.clipsToBounds = NO;
    if (article.photoURL == nil || [article.photoURL isEqualToString: @""]) {
        banner.frame = CGRectMake(0, 0, 0, 0);
        caption.frame = CGRectMake(caption.frame.origin.x, caption.frame.origin.y - 140, caption.frame.size.width, caption.frame.size.height);
        author.frame = CGRectMake(author.frame.origin.x, author.frame.origin.y - 140, author.frame.size.width, author.frame.size.height);
        dateLabel.frame = CGRectMake(dateLabel.frame.origin.x, dateLabel.frame.origin.y - 140, dateLabel.frame.size.width, dateLabel.frame.size.height);
        articleTextView.frame = CGRectMake(articleTextView.frame.origin.x, articleTextView.frame.origin.y - 140, articleTextView.frame.size.width, articleTextView.frame.size.height);
    } else {
        [banner sd_setImageWithURL:[NSURL URLWithString: article.photoURL]];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[article.imageSubtitle dataUsingEncoding:NSUTF8StringEncoding]  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
        UIFont *font = [UIFont fontWithName:@"Palatino" size:12];
        [attributedString setFont:font];
        caption.adjustsFontSizeToFitWidth = YES;
        caption.attributedText = attributedString;
    }
    author.text = article.author;
    dateLabel.text = article.date;

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[article.body dataUsingEncoding:NSUTF8StringEncoding]  options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType, NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)}documentAttributes:nil error:nil];
    UIFont *font = [UIFont fontWithName:@"Palatino" size:14];
   [attributedString setFont:font];
        articleTextView.frame = CGRectMake(articleTextView.frame.origin.x, articleTextView.frame.origin.y, articleTextView.frame.size.width, [self textViewHeightForAttributedText:attributedString andWidth: articleTextView.frame.size.width]);
    articleTextView.attributedText = attributedString;
}

-(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    return str;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.detailScrollView setContentSize:CGSizeMake(self.detailScrollView.frame.size.width, (articleTextView.frame.origin.y + (articleTextView.frame.size.height)))];
}

- (CGFloat)textViewHeightForAttributedText: (NSMutableAttributedString*)text andWidth: (CGFloat)width {
    UITextView *calculationView = [[UITextView alloc] init];
    [calculationView setAttributedText:text];
    CGSize size = [calculationView sizeThatFits:CGSizeMake(width, FLT_MAX)];
    return size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
