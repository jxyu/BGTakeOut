//
//  AfterVirifyViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/21.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "AfterVirifyViewController.h"
#import "DataProvider.h"
#import "SecriteViewController.h"

@interface AfterVirifyViewController ()
@property(nonatomic,strong) UIWindow* window;
@property(nonatomic,strong)SecriteViewController *mysecriteVC;
@end

@implementation AfterVirifyViewController
{
    UITextField * txt_pwd;
}

-(void)clickLeftButton:(UIButton *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self addLeftButton:@"ic_actionbar_back.png"];
    UIView * backForPwd =[[UIView alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20, self.view.frame.size.width, self.view.frame.size.height)];
    backForPwd.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    UIView * Backview=[[UIView alloc] initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 40)];
    Backview.backgroundColor=[UIColor whiteColor];
    UILabel * Pwd =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    Pwd.text=@"密码：";
    [Backview addSubview:Pwd];
    UIView * lastView=Pwd;
    CGFloat x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_pwd=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_pwd setPlaceholder:@"输入密码"];
    [txt_pwd setKeyboardType:UIKeyboardTypeAlphabet];
    [Backview addSubview:txt_pwd];
    [backForPwd addSubview:Backview];
    
    UILabel * lbl_secrit=[[UILabel alloc] initWithFrame:CGRectMake(10, Backview.frame.origin.y+Backview.frame.size.height+10, 170, 15)];
    lbl_secrit.text=@"点击下一步表示您已完成阅读";
    lbl_secrit.textColor=[UIColor grayColor];
    lbl_secrit.font=[UIFont systemFontOfSize:13];
    [backForPwd addSubview:lbl_secrit];
    UIButton * btn_secrit=[[UIButton alloc] initWithFrame:CGRectMake(lbl_secrit.frame.origin.x+lbl_secrit.frame.size.width, lbl_secrit.frame.origin.y, 60, 15)];
    [btn_secrit setTitle:@"隐私政策" forState:UIControlStateNormal];
    [btn_secrit setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btn_secrit.titleLabel.font=[UIFont systemFontOfSize:13];
    [btn_secrit addTarget:self action:@selector(btn_secritClick) forControlEvents:UIControlEventTouchUpInside];
    [backForPwd addSubview:btn_secrit];
    
    UIButton * tijiao=[[UIButton alloc] initWithFrame:CGRectMake(30, 140, 260, 40)];
    [tijiao setTitle:@"确定" forState:UIControlStateNormal];
    [tijiao setTintColor:[UIColor whiteColor]];
    [tijiao setBackgroundColor:[UIColor redColor]];
    tijiao.layer.masksToBounds=YES;
    tijiao.layer.cornerRadius=6;
    [tijiao addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [backForPwd addSubview:tijiao];
    [self.view addSubview:backForPwd];
}

-(void)btn_secritClick
{
    _mysecriteVC=[[SecriteViewController alloc] initWithNibName:@"SecriteViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_mysecriteVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)submitClick
{
    NSLog(@"phone:%@,pwd:%@",_telLabel,txt_pwd.text);
    NSString * phonenum=[_telLabel substringFromIndex:4];
    DataProvider * dataprovider =[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"isSubmitFinish:"];
    [dataprovider registerPerson:phonenum andPwd:txt_pwd.text];
    //    [self.view removeFromSuperview];
}

-(void)isSubmitFinish:(id)dict
{
    NSLog(@"%@",dict);
    if (1==[dict[@"status"] integerValue]) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"注册成功", nil)
                                                      message:NSLocalizedString(@"通知", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
        
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                      message:NSLocalizedString(dict[@"msg"], nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
}


//-(void)clickLeftButton:(UIButton *)sender
//{
//    [self presentViewController:self.presentingViewController.presentingViewController.presentingViewController animated:YES completion:^{
////        code
//    } ];
//    
//}

@end
