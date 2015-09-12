//
//  OrderInfoViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/13.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "RefreshHeaderAndFooterView.h"
#import "PingjiaForOrderViewController.h"
#import "MZTimerLabel.h"
#import "CantingInfoViewController.h"


@interface OrderInfoViewController : BaseNavigationController <UIScrollViewDelegate,RefreshHeaderAndFooterViewDelegate,UIAlertViewDelegate,MZTimerLabelDelegate>
@property(nonatomic,strong)NSDictionary * orderInfoDetial;
@property(nonatomic,strong)NSArray * orderData;
@property(nonatomic)float lastprice;
@property(nonatomic,strong)PingjiaForOrderViewController *mypingjia;
@property(nonatomic,strong)CantingInfoViewController * myCanting;
@end
