//
//  LoginViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/4.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "DataProvider.h"
#import <SMS_SDK/SMS_SDK.h>

#define KWidth self.view.frame.size.width

@interface LoginViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;

@end

@implementation LoginViewController
{
    UITextField * txt_phoneNum;
    UITextField * txt_pwd;
}

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, KWidth, 64)];
    navigationBar.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    navigationBar.translucent=YES;
    _mynavigationItem = [[UINavigationItem alloc] initWithTitle:@"登录"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Image-2"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(clickLoginLeftButton)];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(clickLoginRightButton)];
    [navigationBar pushNavigationItem:_mynavigationItem animated:NO];
    [_mynavigationItem setLeftBarButtonItem:leftButton];
    [_mynavigationItem setRightBarButtonItem:rightButton];
    [self.view addSubview:navigationBar];
    
    UIView * lastView=navigationBar;
    UIView * BackgroundView1=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+5, KWidth, 40)];
    BackgroundView1.backgroundColor=[UIColor whiteColor];
    UILabel * PhoneNum =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    PhoneNum.text=@"手机号：";
    [BackgroundView1 addSubview:PhoneNum];
    lastView=[[BackgroundView1 subviews] lastObject];
    CGFloat x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_phoneNum setKeyboardType:UIKeyboardTypeNumberPad];
    [txt_phoneNum setPlaceholder:@"请输入手机号"];
    [BackgroundView1 addSubview:txt_phoneNum];
    [self.view addSubview:BackgroundView1];
    
    lastView=BackgroundView1;
    UIView * BackgroundView2=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y+1, KWidth, 40)];
    BackgroundView2.backgroundColor=[UIColor whiteColor];
    UILabel * Pwd =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    Pwd.text=@"密码：";
    [BackgroundView2 addSubview:Pwd];
    lastView=[[BackgroundView2 subviews] lastObject];
    x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_pwd=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_pwd setPlaceholder:@"输入密码"];
    [txt_pwd setKeyboardType:UIKeyboardTypeAlphabet];
    [BackgroundView2 addSubview:txt_pwd];
    [self.view addSubview:BackgroundView2];
    
    
    UIButton * btn_login=[[UIButton alloc] initWithFrame:CGRectMake(30, BackgroundView2.frame.origin.y+BackgroundView2.frame.size.height+10, 260, 40)];
    [btn_login setBackgroundColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0]];
    [btn_login setTitle:@"登录" forState:UIControlStateNormal];
    [btn_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_login addTarget:self action:@selector(LoginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_login];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)clickLoginLeftButton
{
    [self.view removeFromSuperview];
}
-(void)clickLoginRightButton
{
    RegViewController* reg=[[RegViewController alloc] init];
    [self presentViewController:reg animated:YES completion:^{
        
    }];
}

-(void)LoginClick
{
    if (txt_phoneNum.text!=nil&&txt_pwd.text!=nil) {
        DataProvider * dataprovider =[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"LoginBack:"];
        [dataprovider Login:txt_phoneNum.text andPwd:txt_pwd.text];
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                      message:NSLocalizedString(@"账号或密码不正确", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

-(void)LoginBack:(id)dict
{
    if (1==[dict[@"status"] integerValue]) {
//        NSString * path=[[NSBundle mainBundle] pathForResource:@"UserInfo" ofType:@"plist"];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
//        NSString * data=[[NSString alloc] initWithFormat:dict];
//        NSDictionary * userdata=@{@"userdata":data};
//        NSArray * dataarray =[[NSArray alloc] initWithObjects:data, nil];
        BOOL result= [dict[@"data"] writeToFile:plistPath atomically:YES];
        if (result) {
//            NSLog(@"congsdfksadjfjsadklfjsadkjfkasdjfsdakjfkal%@",[[NSDictionary alloc] initWithContentsOfFile:plistPath]);
            SEL func_selector = NSSelectorFromString(callBackFunctionName);
            if ([CallBackObject respondsToSelector:func_selector]) {
                NSLog(@"回调成功...");
                [CallBackObject performSelector:func_selector withObject:dict];
            }else{
                NSLog(@"回调失败...");
            }
        }
        
    }else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                      message:NSLocalizedString(@"登录失败，请重新登录", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
