//
//  CustomTabBarViewController.h
//  Blinq
//
//  Created by Sugar on 13-8-12.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "JSBadgeView.h"
@interface CustomTabBarViewController : UITabBarController<UITabBarDelegate, UINavigationBarDelegate,UIScrollViewDelegate>
{
    NSMutableArray *tabBarBtnList;
    int currentSelectIndex;
    int whichButtonPressed;
    
//    JSBadgeView * jsbChat;
//    JSBadgeView *jsbwhoviewme;
}
 
 
#pragma mark -
#pragma mark CustomTabbar

//自定义tabbar点击响应
- (void)onTabButtonPressed:(id)sender;

//切换tabbar的具体方法
- (void)selectWhenTabItem:(id)sender;
//隐藏tabbar
- (void)hideCustomTabBar;
//显示tabbar
-(void)showTabBar;

//显示登录界面
-(void)showLoginViewController:(int)itemTag isAnimation:(BOOL)isAnimate;

//进入Home页面
- (void)goToHomePage;
- (void)selectTableBarIndex:(NSInteger)index;

@end
