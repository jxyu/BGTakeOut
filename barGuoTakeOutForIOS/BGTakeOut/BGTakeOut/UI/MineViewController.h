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
#import "BaseNavigationController.h"

@interface MineViewController : BaseNavigationController <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)OtherOfMineViewController * myOther;

@property(nonatomic,strong)LoginViewController * myLogin;
@property(nonatomic,strong)UserInfoViewController * myUserInfo;
@end
