//
//  PinglunForBGBangViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/18.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "CWStarRateView.h"

@interface PinglunForBGBangViewController : BaseNavigationController<UITextViewDelegate,CWStarRateViewDelegate>
@property(nonatomic,strong)NSString * articleid;
@property(nonatomic,strong)NSString * userid;

@end
