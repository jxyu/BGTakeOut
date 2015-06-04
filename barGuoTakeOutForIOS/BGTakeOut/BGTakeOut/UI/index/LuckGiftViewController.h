//
//  LuckGiftViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/6/3.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface LuckGiftViewController : BaseNavigationController
@property (weak, nonatomic) IBOutlet UILabel *lbl_roll;
@property (weak, nonatomic) IBOutlet UIButton *btn_getnumber;
@property(nonatomic,strong)NSString *userid;

@end
