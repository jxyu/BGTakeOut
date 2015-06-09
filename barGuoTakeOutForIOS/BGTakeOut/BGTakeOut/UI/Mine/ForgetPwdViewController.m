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
#import "VerifyViewController.h"

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
        VerifyViewController* verify=[[VerifyViewController alloc] init];
        [verify setPhone:_txt_PhoneNum.text AndAreaCode:@"86"];
        
        [SMS_SDK getVerificationCodeBySMSWithPhone:_txt_PhoneNum.text
                                              zone:@"86"
                                            result:^(SMS_SDKError *error)
         {
             if (!error)
             {
                 [self.navigationController pushViewController:verify animated:YES];
             }
             else
             {
                 UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                               message:[NSString stringWithFormat:@"状态码：%zi ,错误描述：%@",error.errorCode,error.errorDescription]
                                                              delegate:self
                                                     cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                     otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}
@end
