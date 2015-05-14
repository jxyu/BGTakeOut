//
//  OrderListViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "OrderInfoViewController.h"

@interface OrderListViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString * userid;
@property(nonatomic,strong)OrderInfoViewController * orderInfoVC;

@end
