//
//  EScrollerView.m
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import "EScrollerView.h"
@implementation EScrollerView
@synthesize delegate;

-(id)initWithFrameRect:(CGRect)rect imageArray:(NSArray *)imgArr {
    if ((self=[super initWithFrame:rect])) {
        self.userInteractionEnabled=YES;
        
        NSMutableArray *tempArray=[NSMutableArray arrayWithArray:imgArr];
        [tempArray insertObject:[imgArr objectAtIndex:([imgArr count]-1)] atIndex:0];
        [tempArray addObject:[imgArr objectAtIndex:0]];
        imageArray=[NSArray arrayWithArray:tempArray];
        
        viewSize=rect;
        
        NSUInteger pageCount=[imageArray count];
        scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, viewSize.size.width, viewSize.size.height)];
        scrollView.pagingEnabled = YES;
        scrollView.contentSize = CGSizeMake(viewSize.size.width * pageCount, viewSize.size.height);
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        
        scrollView.delegate = self;
        
        for (int i=0; i<pageCount; i++) {
            UIImageView *imgView=[[UIImageView alloc] init];
            imgView.contentMode = UIViewContentModeScaleAspectFill;
            imgView.clipsToBounds = YES;
            UIImage *img=[UIImage imageNamed:[imageArray objectAtIndex:i]];
            [imgView setImage:img];
            
            [imgView setFrame:CGRectMake(viewSize.size.width*i, 0,viewSize.size.width,viewSize.size.height)];
            imgView.tag=i;
            UITapGestureRecognizer *Tap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
            [Tap setNumberOfTapsRequired:1];
            [Tap setNumberOfTouchesRequired:1];
            imgView.userInteractionEnabled=YES;
            [imgView addGestureRecognizer:Tap];
            [scrollView addSubview:imgView];
        }
        
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
        [self addSubview:scrollView];
        
        float pageControlWidth=(pageCount-2)*10.0f+40.f;
        float pagecontrolHeight=20.0f;
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width-pageControlWidth),6, pageControlWidth, pagecontrolHeight)];
        pageControl.currentPage=0;
        pageControl.numberOfPages=(pageCount-2);
        
        UILabel *schoolLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 0, rect.size.width, 50)];
        schoolLabel.text = @"Saratoga High School";
        schoolLabel.textColor = [UIColor whiteColor];
        schoolLabel.font = [UIFont fontWithName:@"AvenirNext-Medium" size: 25.0];
        
        timeLabel = [[UILabel alloc] initWithFrame: CGRectMake(5, 27, rect.size.width, 50)];
        timeLabel.text = @"";
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size: 17.0];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = schoolLabel.layer.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[UIColor colorWithRed: 0.2 green: 0.2 blue: 0.2 alpha:0.8f].CGColor,
                                (id)[UIColor clearColor].CGColor,
                                nil];
        gradientLayer.locations = [NSArray arrayWithObjects:
                                   [NSNumber numberWithFloat:0.0f],
                                   [NSNumber numberWithFloat:1.0f],
                                   nil];
        [self.layer addSublayer:gradientLayer];
        [self addSubview: schoolLabel];
        [self addSubview: timeLabel];

        NSTimer *autoScrollTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        NSTimer *timeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTime) userInfo:nil repeats:YES];

    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;
    
    pageControl.currentPage=(page-1);
    int titleIndex=page-1;
    if (titleIndex==[titleArray count]) {
        titleIndex=0;
    }
    if (titleIndex<0) {
        titleIndex=(int)[titleArray count]-1;
    }
    [noteTitle setText:[titleArray objectAtIndex:titleIndex]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView {
    if (currentPageIndex==0) {
        
        [_scrollView setContentOffset:CGPointMake(([imageArray count]-2)*viewSize.size.width, 0)];
    }
    if (currentPageIndex==([imageArray count]-1)) {
        
        [_scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    }
}

- (void)imagePressed:(UITapGestureRecognizer *)sender{
    if ([delegate respondsToSelector:@selector(EScrollerViewDidClicked:)]) {
        [delegate EScrollerViewDidClicked:sender.view.tag];
    }
}

- (void)autoScroll {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    currentPageIndex=page;

    if (currentPageIndex != ([imageArray count]-1)) {
        [scrollView setContentOffset:CGPointMake(self.frame.size.width * (currentPageIndex+1), 0) animated:YES];
    } else {
        [scrollView setContentOffset:CGPointMake(viewSize.size.width, 0)];
    }
    
}

- (void)updateTime {
    NSDate *nowTime = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, M/dd h:mm a"];
    timeLabel.text = [dateFormatter stringFromDate:nowTime];
}
@end
