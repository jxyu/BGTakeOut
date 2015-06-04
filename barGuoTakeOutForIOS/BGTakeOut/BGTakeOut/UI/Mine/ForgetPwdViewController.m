//
//  ForgetPwdViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/6/4.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "ForgetPwdViewController.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "RegViewController.h"

@interface ForgetPwdViewController ()

@end

@implementation ForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"忘记密码";
    [self addLeftButton:@"ic_actionbar_back.png"];
    _btn_next.layer.masksToBounds=YES;
    _btn_next.layer.cornerRadius=3;
    [_btn_next addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)nextStep
{
    if (_txt_PhoneNum.text.length==11) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"CheckBackCall:"];
        [dataprovider CheckIsPhoneExist:_txt_PhoneNum.text];
    }
    
}

-(void)CheckBackCall:(id)dict
{
    if ([dict[@"status"] intValue]==0) {
        RegViewController* reg=[[RegViewController alloc] init];
        [self presentViewController:reg animated:YES completion:^{
            NSLog(@"zhucewancheng回到前一页");
        }];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}
@end
