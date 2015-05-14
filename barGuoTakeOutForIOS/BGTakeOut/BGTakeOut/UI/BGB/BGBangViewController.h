//
//  BGBangViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/24.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "DOPDropDownMenu.h"
#import "BGBangDetialViewController.h"

@interface BGBangViewController : BaseNavigationController <UITabBarDelegate,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)BGBangDetialViewController *BGBangDetialVC;
@end
