//
//  AppDelegate.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SMS_SDK/SMS_SDK.h>
#import "CustomTabBarViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    CustomTabBarViewController *_tabBarViewCol;
}

- (void)showTabBar;
- (void)hiddenTabBar;
-(CustomTabBarViewController *)getTabBar;
@property (strong, nonatomic) UIWindow *window;


@end

