//
//  CantingInfoViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/27.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataProvider.h"
#import "NYSegmentedControl.h"
#import "OrderForSureViewController.h"
#import "BaseNavigationController.h"

@interface CantingInfoViewController : BaseNavigationController <UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSString *resid;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *peisongData;
@property(nonatomic,strong)NSString *beginprice;
@property(nonatomic,strong)OrderForSureViewController *myOrderView;

-(void)CantingclickLeftButton;
-(void)CantingItemClick:(UIButton *)sender;
- (UIColor *) stringTOColor:(NSString *)str;


@end
