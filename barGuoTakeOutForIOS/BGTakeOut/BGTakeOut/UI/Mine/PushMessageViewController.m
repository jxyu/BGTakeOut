//
//  PushMessageViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/6/25.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "PushMessageViewController.h"
#import "AppDelegate.h"
#import "CommenDef.h"

@interface PushMessageViewController ()

@end

@implementation PushMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"推送消息";
    [self addLeftButton:@"ic_actionbar_back.png"];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UIView * BackView_tuisong=[[UIView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH, 60)];
    BackView_tuisong.backgroundColor=[UIColor whiteColor];
    if ([self isAllowedNotification]) {
        UILabel * lbl_status=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, BackView_tuisong.frame.size.width-20, 20)];
        lbl_status.text=@"推送已开启";
        lbl_status.textColor=[UIColor grayColor];
        [BackView_tuisong addSubview:lbl_status];
        [self.view addSubview:BackView_tuisong];
    }
    else
    {
        UILabel * lbl_status=[[UILabel alloc] initWithFrame:CGRectMake(10, 20, BackView_tuisong.frame.size.width-20, 20)];
        lbl_status.text=@"推送未开启";
        lbl_status.textColor=[UIColor grayColor];
        [BackView_tuisong addSubview:lbl_status];
        [self.view addSubview:BackView_tuisong];
        UILabel * lbl_set=[[UILabel alloc] initWithFrame:CGRectMake(0, BackView_tuisong.frame.origin.y+BackView_tuisong.frame.size.height+5, SCREEN_WIDTH, 20)];
        lbl_set.textAlignment=NSTextAlignmentCenter;
        lbl_set.textColor=[UIColor grayColor];
        lbl_set.text=@"开启推送：‘设置－通知中心－掌尚街’";
        [self.view addSubview:lbl_set];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}


- (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {// system is iOS8
        UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (UIUserNotificationTypeNone != setting.types) {
            return YES;
        }
    } else {//iOS7
        UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
        if(UIRemoteNotificationTypeNone != type)
            return YES;
    }
    return NO;
}

@end
