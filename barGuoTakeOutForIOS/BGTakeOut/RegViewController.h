//
//  RegViewController.h
//  SMS_SDKDemo
//
//  Created by 中扬科技 on 14-6-4.
//  Copyright (c) 2014年 中扬科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionsViewController.h"
#import "BaseNavigationController.h"

@protocol SecondViewControllerDelegate;

@interface RegViewController : BaseNavigationController
<
UIAlertViewDelegate,
UITableViewDataSource,
UITableViewDelegate,
SecondViewControllerDelegate,
UITextFieldDelegate
>

@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) UITextField* areaCodeField;
@property(nonatomic,strong) UITextField* telField;
@property(nonatomic,strong) UIWindow* window;
@property(nonatomic,strong) UIButton* next;

-(void)nextStep;

@end
