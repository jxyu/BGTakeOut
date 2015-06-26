//
//  LuckGiftViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/6/3.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "LuckGiftViewController.h"
#import "DataProvider.h"
#import "AppDelegate.h"

@interface LuckGiftViewController ()

@end

@implementation LuckGiftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"每月幸运星";
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    
    _btn_getnumber.layer.masksToBounds=YES;
    _btn_getnumber.layer.cornerRadius=3;
    [_btn_getnumber addTarget:self action:@selector(btn_getnumberClick) forControlEvents:UIControlEventTouchUpInside];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetRulueBackCall:"];
    [dataprovider getRuller];
}
-(void)GetRulueBackCall:(id)dict
{
    NSLog(@"抽奖规则%@",dict);
    if ([dict[@"status"] intValue]==1) {
        _lbl_roll.text=dict[@"data"][@"dailystar"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getLuckGiftBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"抽奖成功，请等待公布结果" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }
}
-(void)btn_getnumberClick
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"getLuckGiftBackCall:"];
    [dataprovider GetLuckGift:_userid];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}



@end
