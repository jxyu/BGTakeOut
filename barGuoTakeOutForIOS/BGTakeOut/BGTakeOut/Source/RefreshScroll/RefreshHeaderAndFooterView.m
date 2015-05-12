//
//  RefreshHeaderAndFooterView.m
//  hardy
//
//  Created by hardy on 13-1-8.
//  Copyright (c) 2013年 hardy. All rights reserved.
//

#import "RefreshHeaderAndFooterView.h"
#import <QuartzCore/QuartzCore.h>

#define RefreshViewHeight 65.0f
#define TEXT_COLOR	 [UIColor colorWithRed:87.0/255.0 green:108.0/255.0 blue:137.0/255.0 alpha:1.0]
#define FLIP_ANIMATION_DURATION 0.18f
#define KSetHeaderViewY 64

/**************************************************************************************************
 *********************************RefreshHeaderView************************************************
 *************************************************************************************************/
@interface RefreshHeaderView()
@end

@implementation RefreshHeaderView
@synthesize state = _state;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor  {
    if((self = [super initWithFrame:frame])) {
		
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:1.0];
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = textColor;
        label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        label.shadowOffset = CGSizeMake(0.0f, 1.0f);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [self addSubview:label];
        _lastUpdatedLabel=label;
		
		label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
		CALayer *layer = [CALayer layer];
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
		
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:view];
		_activityView = view;
		
		
		[self setState:PullRefreshNormal];
		
    }
	
    return self;
	
}

- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}
-(void)layoutSubviews
{
    _lastUpdatedLabel.frame = CGRectMake(0.0f, self.frame.size.height - 30.0f+KSetHeaderViewY, self.frame.size.width, 20.0f);
    _statusLabel.frame = CGRectMake(0.0f, self.frame.size.height - 48.0f+KSetHeaderViewY, self.frame.size.width, 20.0f);
    _arrowImage.frame = CGRectMake(25.0f, self.frame.size.height - 65.0f+KSetHeaderViewY, 30.0f, 55.0f);
    _activityView.frame = CGRectMake(25.0f, self.frame.size.height - 38.0f+KSetHeaderViewY, 20.0f, 20.0f);
}
#pragma mark -
#pragma mark Setters

- (void)updateRefreshDate :(NSDate *)date{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [df stringFromDate:date];
    NSString *title = NSLocalizedString(@"今天", nil);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:date toDate:[NSDate date] options:0];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    if (year == 0 && month == 0 && day < 3) {
        if (day == 0) {
            title = NSLocalizedString(@"今天",nil);
        } else if (day == 1) {
            title = NSLocalizedString(@"昨天",nil);
        } else if (day == 2) {
            title = NSLocalizedString(@"前天",nil);
        }
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        dateString = [df stringFromDate:date];

    }
    _lastUpdatedLabel.text = [NSString stringWithFormat:@"%@: %@",
                       NSLocalizedString(@"最后更新", @""),
                       dateString];
}

- (void)setState:(PullRefreshState)state{
	if (_state != state) {
        _state = state;
        switch (state) {
            case PullRefreshPulling:
                
                _statusLabel.text = NSLocalizedString(@"松开手指刷新...", @"松开手指刷新...");
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
                
                break;
            case PullRefreshNormal:
                
                if (_state == PullRefreshPulling) {
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                    _arrowImage.transform = CATransform3DIdentity;
                    [CATransaction commit];
                }
                
                _statusLabel.text = NSLocalizedString(@"下拉刷新...", @"下拉刷新...");
                [_activityView stopAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = NO;
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
                
                break;
            case PullRefreshLoading:
                
                _statusLabel.text = NSLocalizedString(@"努力加载中...", @"努力加载中...");
                [_activityView startAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = YES;
                [CATransaction commit];
                
                break;
            default:
                break;
        }
    }
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
	
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
    _lastUpdatedLabel = nil;
}
@end

/**************************************************************************************************
 *********************************RefreshFooterView************************************************
 *************************************************************************************************/
@interface RefreshFooterView ()

@end

@implementation RefreshFooterView
@synthesize state =_state;
- (id)initWithFrame:(CGRect)frame arrowImageName:(NSString *)arrow textColor:(UIColor *)textColor
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor clearColor];
		
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:13.0f];
		label.textColor = textColor;
		label.shadowColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
		label.shadowOffset = CGSizeMake(0.0f, 1.0f);
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
		[self addSubview:label];
		_statusLabel=label;
		
        CALayer *layer = [CALayer layer];
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:arrow].CGImage;
		
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
#endif
		
		[[self layer] addSublayer:layer];
		_arrowImage=layer;
        
		UIActivityIndicatorView *view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:view];
		_activityView = view;
		[self setState:PullRefreshNormal];
        
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame  {
    return [self initWithFrame:frame arrowImageName:@"blueArrow.png" textColor:TEXT_COLOR];
}
-(void)layoutSubviews
{
    _statusLabel.frame = CGRectMake(0.0f, RefreshViewHeight - 38.0f, self.frame.size.width, 20.0f);
    _activityView.frame = CGRectMake(25.0f,RefreshViewHeight - 38.0f, 20.0f, 20.0f);
    _arrowImage.frame = CGRectMake(25.0f, RefreshViewHeight - RefreshViewHeight, 30.0f, 55.0f);
}
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
- (void)setState:(PullRefreshState)state{
	if (_state != state) {
        _state = state;
        switch (state) {
            case PullRefreshPulling:
                
                _statusLabel.text = NSLocalizedString(@"松开手指加载更多内容...", @"松开手指加载更多内容...");
                [CATransaction begin];
                [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                _arrowImage.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
                [CATransaction commit];
                
                break;
            case PullRefreshNormal:
                
                if (_state == PullRefreshPulling) {
                    [CATransaction begin];
                    [CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
                    _arrowImage.transform = CATransform3DIdentity;
                    [CATransaction commit];
                }
                _statusLabel.text = NSLocalizedString(@"上拉加载更多内容...", @"上拉加载更多内容...");
                [_activityView stopAnimating];
                
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = NO;
                _arrowImage.transform = CATransform3DIdentity;
                [CATransaction commit];
                
                break;
            case PullRefreshLoading:
                
                _statusLabel.text = NSLocalizedString(@"努力加载更多内容...", @"努力加载更多内容...");
                [_activityView startAnimating];
                [CATransaction begin];
                [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
                _arrowImage.hidden = YES;
                [CATransaction commit];
                
                break;
            default:
                break;
        }
	}
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    
    _arrowImage = nil;
	_activityView = nil;
	_statusLabel = nil;
}

@end

/**************************************************************************************************
 *********************************RefreshHeaderAndFooterView***************************************
 *************************************************************************************************/
@interface RefreshHeaderAndFooterView ()
@end

@implementation RefreshHeaderAndFooterView
@synthesize refreshHeaderView = _refreshHeaderView;
//@synthesize refreshFooterView = _refreshFooterView;
@synthesize delegate =_delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        RefreshHeaderView * headerView  = [[RefreshHeaderView alloc] initWithFrame:CGRectZero];
        [self addSubview:headerView];
        self.refreshHeaderView = headerView;
        
//        RefreshFooterView * footerView = [[RefreshFooterView alloc] initWithFrame:CGRectZero];
//        [self addSubview:footerView];
//        self.refreshFooterView = footerView;
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)layoutSubviews{
    self.refreshHeaderView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    self.refreshFooterView.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
}
#pragma mark -
#pragma mark ScrollView Methods
//手指屏幕上不断拖动调用此方法
- (void)RefreshScrollViewDidScroll:(UIScrollView *)scrollView {
	
	if (self.refreshHeaderView.state == PullRefreshLoading) {
		return;
	}
    if (scrollView.isDragging) {
		
		BOOL _loading = NO;
		if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDataSourceIsLoading:)]) {
			_loading = [self.delegate RefreshHeaderAndFooterDataSourceIsLoading:self];
		}
		if (self.refreshHeaderView.state == PullRefreshPulling&&scrollView.contentOffset.y > -65.0f && scrollView.contentOffset.y < 0.0f && !_loading) {
			self.refreshHeaderView.state = PullRefreshNormal;
		} else if (self.refreshHeaderView.state == PullRefreshNormal && scrollView.contentOffset.y < -65.0f && !_loading) {
			self.refreshHeaderView.state = PullRefreshPulling;
		}
        if (scrollView.contentInset.top != 0) {
			scrollView.contentInset = UIEdgeInsetsZero;
		}
//		if (self.refreshFooterView.state == PullRefreshPulling && scrollView.contentOffset.y + (scrollView.frame.size.height) < scrollView.contentSize.height + RefreshViewHeight && scrollView.contentOffset.y > 0.0f && !_loading) {
//			self.refreshFooterView.state = PullRefreshNormal;
//		} else if (self.refreshFooterView.state == PullRefreshNormal &&  scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHeight  && !_loading) {
//			self.refreshFooterView.state = PullRefreshPulling;
//		}
//		
//		if (scrollView.contentInset.bottom != 0) {
//			scrollView.contentInset = UIEdgeInsetsZero;
//		}
		
	}
	
}
//当用户停止拖动，并且手指从屏幕中拿开的的时候调用此方法
- (void)RefreshScrollViewDidEndDragging:(UIScrollView *)scrollView {
	if (self.refreshHeaderView.state == PullRefreshLoading) {
		return;
	}
	BOOL _loading = NO;
	if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDataSourceIsLoading:)]) {
		_loading = [_delegate RefreshHeaderAndFooterDataSourceIsLoading:self];
	}
	
    if (scrollView.contentOffset.y <= - 65.0f && !_loading) {
		self.refreshHeaderView.state = PullRefreshLoading;
		if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDidTriggerRefresh:)]) {
			[_delegate RefreshHeaderAndFooterDidTriggerRefresh:self];
		}
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.2];
		scrollView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f, 0.0f);
		[UIView commitAnimations];
		
	}
//	if (scrollView.contentOffset.y + (scrollView.frame.size.height) > scrollView.contentSize.height + RefreshViewHeight && !_loading) {
//		self.refreshFooterView.state = PullRefreshLoading;
//		if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDidTriggerRefresh:)]) {
//			[_delegate RefreshHeaderAndFooterDidTriggerRefresh:self];
//		}
//		[UIView beginAnimations:nil context:NULL];
//		[UIView setAnimationDuration:0.2];
//		scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, RefreshViewHeight, 0.0f);
//		[UIView commitAnimations];
//		
//	}
    
    
	
}
//当开发者页面页面刷新完毕调用此方法，[delegate RefreshScrollViewDataSourceDidFinishedLoading: scrollView];
- (void)RefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView {
    if (self.refreshHeaderView.state ==PullRefreshLoading) {
        self.refreshHeaderView.state = PullRefreshNormal;
        NSDate *date = [NSDate date];
        if ([_delegate respondsToSelector:@selector(RefreshHeaderAndFooterDataSourceLastUpdated:)]) {
          date = [_delegate RefreshHeaderAndFooterDataSourceLastUpdated:self];
        }
        [self.refreshHeaderView updateRefreshDate:date];
    }
//    else if (self.refreshFooterView.state ==PullRefreshLoading) {
//        self.refreshFooterView.state = PullRefreshNormal;
//    }
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[scrollView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];
    
    
}
#pragma mark -
#pragma mark Dealloc

- (void)dealloc {
    
    self.delegate = nil;
	self.refreshHeaderView = nil;
}
@end
