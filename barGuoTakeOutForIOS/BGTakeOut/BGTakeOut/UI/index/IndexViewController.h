//
//  IndexViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/17.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AutoLocationViewController.h"
#import "BaseNavigationController.h"
#import "WaiMAIViewController.h"
#import "JokeViewController.h"
#import "BGBangViewController.h"
#import "BGGiftViewController.h"
#import "MineViewController.h"
#import "FoundViewController.h"

@interface IndexViewController : BaseNavigationController<NSURLConnectionDataDelegate,UITabBarDelegate>
@property(nonatomic,strong)AutoLocationViewController * autolocation;
@property(nonatomic,strong)WaiMAIViewController * myWaiMai;
@property(nonatomic,strong)JokeViewController * myJoke;
@property(nonatomic,strong)BGBangViewController * myBGBang;
@property(nonatomic,strong)BGGiftViewController * myGiftView;
@property(nonatomic,strong)FoundViewController *myFound;
@property(nonatomic,strong)MineViewController * myMine;



//自定义tabbar点击响应
- (void)onTabButtonPressed:(id)sender;

@end
