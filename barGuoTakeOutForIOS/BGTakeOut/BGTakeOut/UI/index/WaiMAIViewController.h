//
//  WaiMAIViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/18.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CantingInfoViewController.h"
#import "BaseNavigationController.h"

@interface WaiMAIViewController : BaseNavigationController
@property(nonatomic,strong)CantingInfoViewController * myCantingView;

-(void)clickLeftButton;

@end
