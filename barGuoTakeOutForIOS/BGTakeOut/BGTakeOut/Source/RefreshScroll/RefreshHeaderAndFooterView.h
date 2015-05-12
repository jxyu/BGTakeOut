//
//  RefreshHeaderAndFooterView.h
//  hardy
//
//  Created by hardy on 13-1-8.
//  Copyright (c) 2013年 hardy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,
} PullRefreshState;

//RefreshHeaderView
@interface RefreshHeaderView : UIView {
	
    UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
}
@property(nonatomic)PullRefreshState state;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;
- (void)updateRefreshDate :(NSDate *)date;
@end

//RefreshFooterView
@interface RefreshFooterView : UIView{
    CALayer *_arrowImage;
	UILabel *_statusLabel;
	UIActivityIndicatorView *_activityView;
}
@property(nonatomic)PullRefreshState state;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor;
@end

//RefreshHeaderAndFooterView
@protocol RefreshHeaderAndFooterViewDelegate;
@interface RefreshHeaderAndFooterView : UIView{
    RefreshHeaderView   *refreshHeaderView;
    RefreshFooterView   *refreshFooterView;
    __unsafe_unretained id _delegate;
}
@property(nonatomic,assign) id <RefreshHeaderAndFooterViewDelegate> delegate;
@property(nonatomic,strong)RefreshHeaderView   *refreshHeaderView;

- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol RefreshHeaderAndFooterViewDelegate
- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view;
- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView*)view;
@optional
- (NSDate*)RefreshHeaderAndFooterDataSourceLastUpdated:(RefreshHeaderAndFooterView*)view;
@end