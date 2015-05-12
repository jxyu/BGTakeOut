//
//  BGBangViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/24.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOPDropDownMenu.h"

@interface BGBangViewController : UIViewController <UITabBarDelegate,DOPDropDownMenuDelegate,DOPDropDownMenuDataSource,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITabBar *mytableBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *index;
@property (weak, nonatomic) IBOutlet UITabBarItem *BGBang;
@property (weak, nonatomic) IBOutlet UITabBarItem *Find;
@property (weak, nonatomic) IBOutlet UITabBarItem *Mine;

-(void)clickLeftButton;
@end
