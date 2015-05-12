//
//  MineViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/4.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "UserInfoViewController.h"
#import "OtherOfMineViewController.h"

@interface MineViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITabBar *tabbar;
@property (weak, nonatomic) IBOutlet UITabBarItem *minetabbaritem;

@property(nonatomic,strong)OtherOfMineViewController * myOther;

@property(nonatomic,strong)LoginViewController * myLogin;
@property(nonatomic,strong)UserInfoViewController * myUserInfo;
@end
