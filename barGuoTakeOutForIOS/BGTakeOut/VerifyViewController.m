//
//  VerifyViewController.m
//  SMS_SDKDemo
//
//  Created by admin on 14-6-4.
//  Copyright (c) 2014年 admin. All rights reserved.
//

#import "VerifyViewController.h"

#import "SMS_MBProgressHUD+Add.h"
#import <AddressBook/AddressBook.h>
#import "YJViewController.h"
#import "RegisterByVoiceCallViewController.h"

#import <SMS_SDK/SMS_SDK.h>
#import <SMS_SDK/SMS_UserInfo.h>
#import <SMS_SDK/SMS_AddressBook.h>

#import "DataProvider.h"
#import "AfterVirifyViewController.h"

@interface VerifyViewController ()
{
    NSString* _phone;
    NSString* _areaCode;
    int _state;
    NSMutableData* _data;
    NSString* _localVerifyCode;
    
    NSString* _appKey;
    NSString* _appSecret;
    NSString* _duid;
    NSString* _token;
    NSString* _localPhoneNumber;
    
    NSString* _localZoneNumber;
    NSMutableArray* _addressBookTemp;
    NSString* _contactkey;
    SMS_UserInfo* _localUser;
    
    NSTimer* _timer1;
    NSTimer* _timer2;
    NSTimer* _timer3;
    
    UIAlertView* _alert1;
    UIAlertView* _alert2;
    UIAlertView* _alert3;
    
    UIAlertView *_tryVoiceCallAlertView;
    UITextField * txt_pwd;

}

@end

static int count = 0;

//最近新好友信息
static NSMutableArray* _userData2;

@implementation VerifyViewController

-(void)clickLeftButton
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                  message:NSLocalizedString(@"是否返回", nil)
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"返回", nil)
                                        otherButtonTitles:NSLocalizedString(@"不返回", nil), nil];
    _alert2=alert;
    [alert show];
}

-(void)setPhone:(NSString*)phone AndAreaCode:(NSString*)areaCode
{
    _phone=phone;
    _areaCode=areaCode;
}

-(void)submit
{
    //验证号码
    //验证成功后 获取通讯录 上传通讯录
    [self.view endEditing:YES];
    
    if(self.verifyCodeField.text.length!=4)
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil)
                                                      message:NSLocalizedString(@"verifycodeformaterror", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        //[[SMS_SDK sharedInstance] commitVerifyCode:self.verifyCodeField.text];
        [SMS_SDK commitVerifyCode:self.verifyCodeField.text result:^(enum SMS_ResponseState state) {
            if (1==state)
            {
//                [self inputPwd];
//                NSLog(@"%@",self.telLabel.text);
                NSLog(@"验证成功");
                AfterVirifyViewController * afterverify=[[AfterVirifyViewController alloc] init];
                afterverify.telLabel=_telLabel.text;

                [self.navigationController pushViewController:afterverify animated:YES];
                
            }
            else if(0==state)
            {
                NSLog(@"验证失败");
                NSString* str=[NSString stringWithFormat:NSLocalizedString(@"验证失败", nil)];
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                              message:str
                                                             delegate:self
                                                    cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                    otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void)CannotGetSMS
{
    NSString* str=[NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"没有收到信息", nil) ,_phone];
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"确认手机号", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", nil) otherButtonTitles:NSLocalizedString(@"确定", nil), nil];
    _alert1=alert;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView==_alert1)
    {
        if (1==buttonIndex)
        {
            NSLog(@"重发验证码");
            [SMS_SDK getVerifyCodeByPhoneNumber:_phone AndZone:_areaCode result:^(enum SMS_GetVerifyCodeResponseState state)
            {
                if (1==state)
                {
                    NSLog(@"block 获取验证码成功");
                }
                else if(0==state)
                {
                    NSLog(@"block 获取验证码失败");
                    NSString* str=[NSString stringWithFormat:NSLocalizedString(@"codesenderrormsg", nil)];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if (SMS_ResponseStateMaxVerifyCode==state)
                {
                    NSString* str=[NSString stringWithFormat:NSLocalizedString(@"maxcodemsg", nil)];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"maxcode", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
                    [alert show];
                }
                else if(SMS_ResponseStateGetVerifyCodeTooOften==state)
                {
                    NSString* str=[NSString stringWithFormat:NSLocalizedString(@"codetoooftenmsg", nil)];
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"notice", nil) message:str delegate:self cancelButtonTitle:NSLocalizedString(@"sure", nil) otherButtonTitles:nil, nil];
                    [alert show];
                }

            }];

        }
        
    }
    
    if (alertView==_alert2) {
        if (0==buttonIndex)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [_timer2 invalidate];
                [_timer1 invalidate];
            }];
        }
    }
    
    if (alertView==_alert3)
    {
        YJViewController* yj=[[YJViewController alloc] init];
        [self presentViewController:yj animated:YES completion:^{
            //解决等待时间乱跳的问题
            [_timer2 invalidate];
            [_timer1 invalidate];
        }];
    }
    
    if (alertView == _tryVoiceCallAlertView)
    {
        if (0 ==buttonIndex)
        {
            [SMS_SDK getVerificationCodeByVoiceCallWithPhone:_phone
                                                        zone:_areaCode
                                                      result:^(SMS_SDKError *error)
             {
                 
                 if (error)
                 {
                     UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                   message:[NSString stringWithFormat:@"状态码：%zi",error.errorCode]
                                                                  delegate:self
                                                         cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                         otherButtonTitles:nil, nil];
                     [alert show];
                 }
             }];
        }
    }

}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    CGFloat statusBarHeight=0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight=20;
    }
    //创建一个导航栏
    _lblTitle.text=@"验证";
    [self addLeftButton:@"ic_actionbar_back.png"];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(close) name:NOTIFICATION_CLOSE_B object:nil];

    
    UILabel* label=[[UILabel alloc] init];
    label.frame=CGRectMake(15, 53+statusBarHeight, self.view.frame.size.width - 30, 21);
    label.text=[NSString stringWithFormat:NSLocalizedString(@"请输入验证码", nil)];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Helvetica" size:17];
    [self.view addSubview:label];
    
    _telLabel=[[UILabel alloc] init];
    _telLabel.frame=CGRectMake(15, 82+statusBarHeight, self.view.frame.size.width - 30, 21);
    _telLabel.textAlignment = UITextAlignmentCenter;
    _telLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
    [self.view addSubview:_telLabel];
    self.telLabel.text= [NSString stringWithFormat:@"+%@ %@",_areaCode,_phone];
    
    _verifyCodeField=[[UITextField alloc] init];
    _verifyCodeField.frame=CGRectMake(15, 111+statusBarHeight, self.view.frame.size.width - 30, 46);
    _verifyCodeField.borderStyle=UITextBorderStyleBezel;
    _verifyCodeField.textAlignment=UITextAlignmentCenter;
    _verifyCodeField.placeholder=NSLocalizedString(@"验证码", nil);
    _verifyCodeField.font=[UIFont fontWithName:@"Helvetica" size:18];
    _verifyCodeField.keyboardType=UIKeyboardTypePhonePad;
    _verifyCodeField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self.view addSubview:_verifyCodeField];
    
    _timeLabel=[[UILabel alloc] init];
    _timeLabel.frame=CGRectMake(15, 169+statusBarHeight, self.view.frame.size.width - 30, 40);
    _timeLabel.numberOfLines = 0;
    _timeLabel.textAlignment = UITextAlignmentCenter;
    _timeLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    _timeLabel.text=NSLocalizedString(@"timelabel", nil);
    [self.view addSubview:_timeLabel];
    
    _repeatSMSBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    _repeatSMSBtn.frame=CGRectMake(15, 169+statusBarHeight, self.view.frame.size.width - 30, 30);
    [_repeatSMSBtn setTitle:NSLocalizedString(@"重新发送验证码", nil) forState:UIControlStateNormal];
    [_repeatSMSBtn addTarget:self action:@selector(CannotGetSMS) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_repeatSMSBtn];
    
    _submitBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [_submitBtn setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
    _submitBtn.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
    _submitBtn.frame=CGRectMake(15, 220+statusBarHeight, self.view.frame.size.width - 30, 42);
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_submitBtn];
    
    _voiceCallMsgLabel=[[UILabel alloc] init];
    _voiceCallMsgLabel.frame=CGRectMake(15, 268+statusBarHeight, self.view.frame.size.width - 30, 25);
    _voiceCallMsgLabel.textAlignment = UITextAlignmentCenter;
    _voiceCallMsgLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    [_voiceCallMsgLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
    _voiceCallMsgLabel.text=NSLocalizedString(@"voiceCallMsgLabel", nil);
    [self.view addSubview:_voiceCallMsgLabel];
    _voiceCallMsgLabel.hidden = YES;
    
    _voiceCallButton=[UIButton buttonWithType:UIButtonTypeSystem];
    [_voiceCallButton setTitle:NSLocalizedString(@"尝试下电话验证码", nil) forState:UIControlStateNormal];
    _voiceCallButton.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
    _voiceCallButton.frame=CGRectMake(15, 300+statusBarHeight, self.view.frame.size.width - 30, 42);
    [_voiceCallButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_voiceCallButton addTarget:self action:@selector(tryVoiceCall) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_voiceCallButton];
    _voiceCallButton.hidden = YES;

    self.repeatSMSBtn.hidden=YES;
    
    [_timer2 invalidate];
    [_timer1 invalidate];
    
    count = 0;
    
    NSTimer* timer=[NSTimer scheduledTimerWithTimeInterval:60
                                           target:self
                                         selector:@selector(showRepeatButton)
                                         userInfo:nil
                                          repeats:YES];
    
    NSTimer* timer2=[NSTimer scheduledTimerWithTimeInterval:1
                                                    target:self
                                                  selector:@selector(updateTime)
                                                  userInfo:nil
                                                   repeats:YES];
    _timer1=timer;
    _timer2=timer2;
    
    [SMS_MBProgressHUD showMessag:NSLocalizedString(@"加载中..", nil) toView:self.view];
    
}

-(void)tryVoiceCall
{
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"verificationByVoiceCallConfirm", nil)
                                                  message:[NSString stringWithFormat:@"%@: +%@ %@",NSLocalizedString(@"willsendthecodeto", nil),_areaCode, _phone]
                                                 delegate:self
                                        cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                        otherButtonTitles:NSLocalizedString(@"cancel", nil), nil];
    _tryVoiceCallAlertView = alert;
    [alert show];
}


-(void)updateTime
{
    count++;
    if (count>=60)
    {
        [_timer2 invalidate];
        return;
    }
    //NSLog(@"更新时间");
    self.timeLabel.text=[NSString stringWithFormat:@"%@%i%@",NSLocalizedString(@"", nil),60-count,NSLocalizedString(@"秒后重新发送", nil)];
    
//    if (count == 30)
//    {
//        if (_voiceCallMsgLabel.hidden)
//        {
//            _voiceCallMsgLabel.hidden = NO;
//        }
//        
//        if (_voiceCallButton.hidden)
//        {
//            _voiceCallButton.hidden = NO;
//        }
//    }
}

-(void)showRepeatButton{
    self.timeLabel.hidden=YES;
    self.repeatSMSBtn.hidden=NO;
    
    [_timer1 invalidate];
    return;
}

-(void) close{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)clickLeftButton:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
