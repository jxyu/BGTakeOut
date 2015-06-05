//
//  BGBangDetialViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "PinglunForBGBangViewController.h"

@interface BGBangDetialViewController : BaseNavigationController
@property(nonatomic,strong)NSString *articleid;
@property(nonatomic,strong)NSString* userid;
@property(nonatomic,strong)PinglunForBGBangViewController * myPinglun;
@property(nonatomic,strong)NSString * isstarted;
@end
