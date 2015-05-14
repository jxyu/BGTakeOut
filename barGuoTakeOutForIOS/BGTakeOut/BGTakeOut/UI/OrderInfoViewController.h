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

@interface OrderInfoViewController : BaseNavigationController <UIScrollViewDelegate,RefreshHeaderAndFooterViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSDictionary * orderInfoDetial;
@property(nonatomic,strong)NSArray * orderData;
@end
