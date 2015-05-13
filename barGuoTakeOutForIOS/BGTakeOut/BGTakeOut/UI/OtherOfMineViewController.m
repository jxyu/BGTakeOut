//
//  OtherOfMineViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/7.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "OtherOfMineViewController.h"
#import "DataProvider.h"
#import "CommenDef.h"
#import "AppDelegate.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

@interface OtherOfMineViewController ()
@end

@implementation OtherOfMineViewController
{
    UILabel *companyshow;
    
    UITextView * tousu;
    UILabel * uilabel;
    UILabel * lbl_zishu;
    UIButton * btn_tousu;
    
    
    UILabel * lbl_SetgroupTitle;
    UIView *pushMsg;
    UILabel *lbl_pushMsg;
    UIView *zixunTel;
    UILabel *lal_zixunTel;
    UILabel *lbl_About;
    UIView * banbenNow;
    UILabel * lbl_banbenNow;
    UIView * yijian;
    UILabel * lbl_yijian;
    UIButton * logout;
    UILabel * lbl_zhongyang;
    UILabel * lbl_banquanfuhao;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self setBarTitle:_Othertitle];
    
    
    switch (_celltag) {
        case 0:
            
            break;
        case 1:
            companyshow=[[UILabel alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+30, KWidth-20, KHeight-NavigationBar_HEIGHT-40)];
            companyshow.text=@"公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介公司简介";
            companyshow.lineBreakMode=UILineBreakModeWordWrap;
            companyshow.numberOfLines=0;
            companyshow.font=[UIFont fontWithName:@"Helvetica" size:14];
            companyshow.backgroundColor=[UIColor whiteColor];
            [self.view addSubview:companyshow];
            break;
        case 2:
            tousu=[[UITextView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 80)];
            [tousu setKeyboardType:UIKeyboardTypeDefault];
            tousu.delegate=self;
            [self.view addSubview:tousu];
            
            uilabel=[[UILabel alloc] initWithFrame:CGRectMake(17, NavigationBar_HEIGHT+20+8, 100, 10)];
            uilabel.text = @"请填写投诉内容..";
            uilabel.enabled = NO;//lable必须设置为不可用
            uilabel.backgroundColor = [UIColor clearColor];
            [self.view addSubview:uilabel];
            lbl_zishu=[[UILabel alloc] initWithFrame:CGRectMake(KWidth-160, NavigationBar_HEIGHT+20+tousu.frame.size.height-30, 150, 10)];
            lbl_zishu.text=@"还能输入140个字";
            lbl_zishu.enabled=NO;
            lbl_zishu.backgroundColor=[UIColor clearColor];
            [self.view addSubview:lbl_zishu];
            btn_tousu=[[UIButton alloc] initWithFrame:CGRectMake(20, tousu.frame.origin.y+tousu.frame.size.height+10, KWidth-40, 35)];
            btn_tousu.backgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
            [btn_tousu addTarget:self action:@selector(TouSuSubmit) forControlEvents:UIControlEventTouchUpInside];
            [btn_tousu setTitle:@"提交" forState:UIControlStateNormal];
            [self.view addSubview:btn_tousu];
            break;
//        case 10:
//            <#statements#>
//            break;
//        case 11:
//            <#statements#>
//            break;
        case 20:
            lbl_SetgroupTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+20+10, 80, 15)];
            lbl_SetgroupTitle.text=@"帮助";
            [self.view addSubview:lbl_SetgroupTitle];
            pushMsg=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_SetgroupTitle.frame.origin.y+lbl_SetgroupTitle.frame.size.height+2, KWidth, 40)];
            pushMsg.backgroundColor=[UIColor whiteColor];
            lbl_pushMsg=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            lbl_pushMsg.text=@"推送消息";
            [pushMsg addSubview:lbl_pushMsg];
            [self.view addSubview:pushMsg];
            zixunTel=[[UIView alloc] initWithFrame:CGRectMake(0, pushMsg.frame.origin.y+pushMsg.frame.size.height+1, KWidth, 40)];
            zixunTel.backgroundColor=[UIColor whiteColor];
            lal_zixunTel=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            lal_zixunTel.text=@"咨询电话";
            [zixunTel addSubview:lal_zixunTel];
            [self.view addSubview:zixunTel];
            
            lbl_About=[[UILabel alloc] initWithFrame:CGRectMake(10, zixunTel.frame.size.height+zixunTel.frame.origin.y+10, 200, 15)];
            lbl_About.text=@"关于巴国外卖";
            [self.view addSubview:lbl_About];
            banbenNow=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_About.frame.origin.y+lbl_About.frame.size.height+2, KWidth, 40)];
            banbenNow.backgroundColor=[UIColor whiteColor];
            lbl_banbenNow=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
            lbl_banbenNow.text=@"当前版本：1.1.0";
            [banbenNow addSubview:lbl_banbenNow];
            [self.view addSubview:banbenNow];
            yijian=[[UIView alloc] initWithFrame:CGRectMake(0, banbenNow.frame.origin.y+banbenNow.frame.size.height+1, KWidth, 40)];
            yijian.backgroundColor=[UIColor whiteColor];
            lbl_yijian=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
            lbl_yijian.text=@"意见反馈";
            [yijian addSubview:lbl_yijian];
            [self.view addSubview:yijian];
            
            logout=[[UIButton alloc] initWithFrame:CGRectMake(40, yijian.frame.origin.y+yijian.frame.size.height+5, KWidth-80, 30)];
            logout.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
            [logout setTitle:@"退出账号" forState:UIControlStateNormal];
            [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.view addSubview:logout];
            
            lbl_banquanfuhao=[[UILabel alloc] initWithFrame:CGRectMake(30, KHeight-80, KWidth-60, 20)];
            lbl_banquanfuhao.text=@"Coryright©2015-2018";
            [lbl_banquanfuhao setTextAlignment:NSTextAlignmentCenter];
            lbl_banquanfuhao.font=[UIFont fontWithName:@"Helvetica" size:12];
            lbl_banquanfuhao.textColor=[UIColor grayColor];
            [self.view addSubview:lbl_banquanfuhao];
            
            lbl_zhongyang=[[UILabel alloc] initWithFrame:CGRectMake(30, KHeight-50, KWidth-60, 20)];
            lbl_zhongyang.text=@"阿克苏巴国城网络科技有限公司";
            [lbl_zhongyang setTextAlignment:NSTextAlignmentCenter];
            lbl_zhongyang.font=[UIFont fontWithName:@"Helvetica" size:12];
            lbl_zhongyang.textColor=[UIColor grayColor];
            [self.view addSubview:lbl_zhongyang];
            break;
        default:
            break;
    }
}

-(void)TouSuSubmit
{
    NSLog(@"提交投诉");
    DataProvider * dataprovider =[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitBackCall:"];
    [dataprovider SubmitTousu:tousu.text anduserid:_UserInfoData[@"userid"]];
}
-(void)textViewDidChange:(UITextView *)textView
{
    int textlength=textView.text.length ;
    if (textlength== 0) {
        uilabel.text = @"请填写投诉内容..";
    }else{
        uilabel.text = @"";
        lbl_zishu.text=[NSString stringWithFormat:@"还能输入%d个字",140-textlength];
    }
}
-(void)SubmitBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (1==[dict[@"status"] integerValue]) {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                      message:NSLocalizedString(dict[@"msg"], nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)BackBtnClick
{
    [self.view removeFromSuperview];
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
