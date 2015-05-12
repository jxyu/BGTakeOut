//
//  OrderForSureViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/7.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "RefreshHeaderAndFooterView.h"

@interface OrderForSureViewController : UIViewController<UITextViewDelegate,UIScrollViewDelegate,RefreshHeaderAndFooterViewDelegate>
@property(nonatomic,strong)NSArray * orderData;
@property(nonatomic,strong)NSString * peiSongFeiData;
@property(nonatomic,strong)NSString * resid;
@property(nonatomic,strong)NSString * orderSumPrice;
@property(nonatomic,strong)LoginViewController * myLogin;


@end
