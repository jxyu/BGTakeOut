//
//  OtherOfMineViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/7.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface OtherOfMineViewController : BaseNavigationController <UITextViewDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSString *Othertitle;
@property(nonatomic)NSInteger celltag;
@property(nonatomic,copy)id UserInfoData;
@end
