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
#import "OrderListViewController.h"
#import "ClictionViewController.h"

@interface MineViewController : BaseNavigationController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property(nonatomic,strong)OtherOfMineViewController * myOther;

@property(nonatomic,strong)LoginViewController * myLogin;
@property(nonatomic,strong)UserInfoViewController * myUserInfo;
@property(nonatomic,strong)OrderListViewController * myOrderList;
@property(nonatomic,strong)ClictionViewController * myCollection;
@end
