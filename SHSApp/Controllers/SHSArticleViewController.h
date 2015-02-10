//
//  SHSArticleViewController.h
//  SHSApp
//
//  Created by Spencer Yen on 8/8/14.
//  Copyright (c) 2014 Spencer Yen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@interface SHSArticleViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, strong) Article *article;
@property (weak, nonatomic) IBOutlet UIScrollView *detailScrollView;
@property (strong, nonatomic) IBOutlet UITextView *articleTextView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *author;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@property (strong, nonatomic) IBOutlet UILabel *caption;
@property (strong, nonatomic) IBOutlet UIImageView *banner;
@end
