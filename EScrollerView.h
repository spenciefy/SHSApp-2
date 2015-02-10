//
//  EScrollerView.h
//  icoiniPad
//
//  Created by Ethan on 12-11-24.
//
//

#import <UIKit/UIKit.h>

@protocol EScrollerViewDelegate <NSObject>
@optional
-(void)EScrollerViewDidClicked:(NSUInteger)index;
@end

@interface EScrollerView : UIView<UIScrollViewDelegate> {
    CGRect viewSize;
    UIScrollView *scrollView;
    NSArray *imageArray;
    NSArray *titleArray;
    UIPageControl *pageControl;
    id<EScrollerViewDelegate> delegate;
    int currentPageIndex;
    UILabel *noteTitle;
    UILabel *timeLabel;
}
@property(nonatomic,retain)id<EScrollerViewDelegate> delegate;
-(id)initWithFrameRect:(CGRect)rect imageArray:(NSArray *)imgArr;
@end
