//
//  ClictionViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "CantingInfoViewController.h"

@interface ClictionViewController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString * userid;
@property(nonatomic,strong)CantingInfoViewController *myCantingView;
@end
