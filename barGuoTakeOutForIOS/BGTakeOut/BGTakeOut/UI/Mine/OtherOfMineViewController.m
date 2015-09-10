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
#import "SetInfoViewController.h"
#import "PushMessageViewController.h"



@interface OtherOfMineViewController ()
@property(nonatomic,strong)SetInfoViewController *setinfo;
@property(nonatomic,strong)PushMessageViewController * mypushMessage;
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
    
    UITextView * zhiwei;
    UILabel *uilabelzhiwei;
    UILabel * lbl_zishuzhiwei;
    UITextView * zhaoshang;
    UILabel *uilabelzhaoshang;
    UILabel * lbl_zishuzhaoshang;
    
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
            
            [self Getjianjie];
            
            break;
        case 2:
            tousu=[[UITextView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 80)];
            [tousu setKeyboardType:UIKeyboardTypeDefault];
            tousu.delegate=self;
            [self.view addSubview:tousu];
            
            uilabel=[[UILabel alloc] initWithFrame:CGRectMake(17, NavigationBar_HEIGHT+20+8, 100, 15)];
            uilabel.text = @"请填写投诉内容..";
            uilabel.enabled = NO;//lable必须设置为不可用
            uilabel.backgroundColor = [UIColor clearColor];
            uilabel.font=[UIFont systemFontOfSize:13];
            [self.view addSubview:uilabel];
            lbl_zishu=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, NavigationBar_HEIGHT+20+tousu.frame.size.height-30, 150, 15)];
            lbl_zishu.text=@"还能输入140个字";
            lbl_zishu.enabled=NO;
            lbl_zishu.font=[UIFont systemFontOfSize:13];
            lbl_zishu.backgroundColor=[UIColor clearColor];
            [self.view addSubview:lbl_zishu];
            btn_tousu=[[UIButton alloc] initWithFrame:CGRectMake(20, tousu.frame.origin.y+tousu.frame.size.height+10, SCREEN_WIDTH-40, 35)];
            btn_tousu.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
            [btn_tousu addTarget:self action:@selector(TouSuSubmit) forControlEvents:UIControlEventTouchUpInside];
            [btn_tousu setTitle:@"提交" forState:UIControlStateNormal];
            [self.view addSubview:btn_tousu];
            break;
        case 10:
            
            [self chengpin];
            
            break;
        case 11:
            [self GetZhaoShangInfo];
            break;
        case 20:
        {
            lbl_SetgroupTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+20+10, 80, 15)];
            lbl_SetgroupTitle.text=@"帮助";
            [self.view addSubview:lbl_SetgroupTitle];
            pushMsg=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_SetgroupTitle.frame.origin.y+lbl_SetgroupTitle.frame.size.height+10, SCREEN_WIDTH, 50)];
            pushMsg.backgroundColor=[UIColor whiteColor];
            lbl_pushMsg=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
            lbl_pushMsg.text=@"推送消息";
            [pushMsg addSubview:lbl_pushMsg];
            UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-21, 15, 11, 16)];
            img_go.image=[UIImage imageNamed:@"go.png"];
            [pushMsg addSubview:img_go];
            UIButton * btn_pushmessage=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, pushMsg.frame.size.width, pushMsg.frame.size.height)];
            [btn_pushmessage addTarget:self action:@selector(btn_pushmessageClick:) forControlEvents:UIControlEventTouchUpInside];
            [pushMsg addSubview:btn_pushmessage];
            [self.view addSubview:pushMsg];
            zixunTel=[[UIView alloc] initWithFrame:CGRectMake(0, pushMsg.frame.origin.y+pushMsg.frame.size.height+1, SCREEN_WIDTH, 50)];
            zixunTel.backgroundColor=[UIColor whiteColor];
            lal_zixunTel=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
            lal_zixunTel.text=@"咨询电话";
            [zixunTel addSubview:lal_zixunTel];
            UIImageView * img_go1=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-21, 15, 11, 16)];
            img_go1.image=[UIImage imageNamed:@"go.png"];
            [zixunTel addSubview:img_go1];
            UIButton * btn_zixunTel=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, zixunTel.frame.size.width, zixunTel.frame.size.height)];
            [btn_zixunTel addTarget:self action:@selector(btn_zixunTel:) forControlEvents:UIControlEventTouchUpInside];
            [zixunTel addSubview:btn_zixunTel];
            [self.view addSubview:zixunTel];
            
            lbl_About=[[UILabel alloc] initWithFrame:CGRectMake(10, zixunTel.frame.size.height+zixunTel.frame.origin.y+10, 200, 15)];
            lbl_About.text=@"关于巴国外卖";
            [self.view addSubview:lbl_About];
            banbenNow=[[UIView alloc] initWithFrame:CGRectMake(0, lbl_About.frame.origin.y+lbl_About.frame.size.height+10, SCREEN_WIDTH, 50)];
            banbenNow.backgroundColor=[UIColor whiteColor];
            lbl_banbenNow=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 200, 20)];
            lbl_banbenNow.text=@"当前版本：1.1.0";
            [banbenNow addSubview:lbl_banbenNow];
//            UIImageView * img_go2=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-21, 20, 11, 16)];
//            img_go2.image=[UIImage imageNamed:@"go.png"];
//            [banbenNow addSubview:img_go2];
            [self.view addSubview:banbenNow];
            yijian=[[UIView alloc] initWithFrame:CGRectMake(0, banbenNow.frame.origin.y+banbenNow.frame.size.height+1, SCREEN_WIDTH, 50)];
            yijian.backgroundColor=[UIColor whiteColor];
            lbl_yijian=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 20)];
            lbl_yijian.text=@"意见反馈";
            [yijian addSubview:lbl_yijian];
            UIButton * btn_yijian=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, yijian.frame.size.width, yijian.frame.size.height)];
            [btn_yijian addTarget:self action:@selector(Btn_yijianClick) forControlEvents:UIControlEventTouchUpInside];
            [yijian addSubview:btn_yijian];
            UIImageView * img_go3=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-21, 15, 11, 16)];
            img_go3.image=[UIImage imageNamed:@"go.png"];
            [yijian addSubview:img_go3];
            [self.view addSubview:yijian];
            
            logout=[[UIButton alloc] initWithFrame:CGRectMake(40, yijian.frame.origin.y+yijian.frame.size.height+10, SCREEN_WIDTH-80, 50)];
            logout.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
            [logout setTitle:@"退出账号" forState:UIControlStateNormal];
            logout.layer.masksToBounds=YES;
            logout.layer.cornerRadius=4;
            [logout addTarget:self action:@selector(LogoutFuc) forControlEvents:UIControlEventTouchUpInside];
            [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.view addSubview:logout];
            
            lbl_banquanfuhao=[[UILabel alloc] initWithFrame:CGRectMake(30, logout.frame.size.height+logout.frame.origin.y+5, SCREEN_WIDTH-60, 20)];
            lbl_banquanfuhao.text=@"Coryright©2015-2018";
            [lbl_banquanfuhao setTextAlignment:NSTextAlignmentCenter];
            lbl_banquanfuhao.font=[UIFont fontWithName:@"Helvetica" size:12];
            lbl_banquanfuhao.textColor=[UIColor grayColor];
            [self.view addSubview:lbl_banquanfuhao];
            
            lbl_zhongyang=[[UILabel alloc] initWithFrame:CGRectMake(30, lbl_banquanfuhao.frame.size.height+lbl_banquanfuhao.frame.origin.y+5, SCREEN_WIDTH-60, 20)];
            lbl_zhongyang.text=@"阿克苏巴国城网络科技有限公司";
            [lbl_zhongyang setTextAlignment:NSTextAlignmentCenter];
            lbl_zhongyang.font=[UIFont fontWithName:@"Helvetica" size:12];
            lbl_zhongyang.textColor=[UIColor grayColor];
            [self.view addSubview:lbl_zhongyang];
        }
            break;
        default:
            break;
    }
}

-(void)btn_pushmessageClick:(UIButton *)sender
{
    _mypushMessage=[[PushMessageViewController alloc] init];
    [self.navigationController pushViewController:_mypushMessage animated:YES];
}

-(void)btn_zixunTel:(UIButton *)sender
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"是否拨打电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (1==buttonIndex) {
        DataProvider * datarovider=[[DataProvider alloc] init];
        [datarovider setDelegateObject:self setBackFunctionName:@"zixunTelBackcall:"];
        [datarovider GetSomeInfonWithType:@"contactphone"];
    }
}

-(void)zixunTelBackcall:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",dict[@"data"][@"contactphone"]]]]; //拨号
    }
}
-(void)Btn_yijianClick
{
    _setinfo=[[SetInfoViewController alloc] init];
    _setinfo.setid=2;
    [self.navigationController pushViewController:_setinfo animated:YES];
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
        uilabelzhiwei.text = @"";
        lbl_zishuzhiwei.text=[NSString stringWithFormat:@"还能输入%d个字",140-textlength];
        uilabelzhaoshang.text = @"";
        lbl_zishuzhaoshang.text=[NSString stringWithFormat:@"还能输入%d个字",140-textlength];
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

-(void)Getjianjie
{
    DataProvider * datarovider=[[DataProvider alloc] init];
    [datarovider setDelegateObject:self setBackFunctionName:@"GetjianjieBackCall:"];
    [datarovider GetSomeInfonWithType:@"business"];
}
-(void)GetjianjieBackCall:(id)dict
{
    if (1==[dict[@"status"] integerValue]) {
        companyshow=[[UILabel alloc] initWithFrame:CGRectMake(10, NavigationBar_HEIGHT+30, SCREEN_WIDTH-20, SCREEN_HEIGHT-NavigationBar_HEIGHT-40)];
        companyshow.text=dict[@"data"][@"business"];
        companyshow.lineBreakMode=UILineBreakModeWordWrap;
        companyshow.numberOfLines=0;
        companyshow.font=[UIFont fontWithName:@"Helvetica" size:14];
        companyshow.backgroundColor=[UIColor whiteColor];
        [self.view addSubview:companyshow];
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

-(void)LogoutFuc
{
    NSDictionary * dict=[[NSDictionary alloc] init];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    //        NSString * data=[[NSString alloc] initWithFormat:dict];
    //        NSDictionary * userdata=@{@"userdata":data};
    //        NSArray * dataarray =[[NSArray alloc] initWithObjects:data, nil];
    BOOL result= [dict writeToFile:plistPath atomically:YES];
    if (result) {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"退出成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"exit_userinfo" object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

-(void)chengpin
{
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"chengpinBackCall:"];
    [dataprovider chengpinInfo];
}
-(void)chengpinBackCall:(id)dict
{
    NSLog(@"%@",dict);
    NSArray * array=[[NSArray alloc] initWithArray:dict[@"data"]];
    for (int i=0; i<array.count; i++) {
        UIView *lastView;
        UIView * BackView_zhaopinxinxi;
        if (i==0) {
            BackView_zhaopinxinxi=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 140)];
        }
        else
        {
            lastView=[self.view.subviews lastObject];
            BackView_zhaopinxinxi=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y, SCREEN_WIDTH, 100)];
        }
        UILabel * lbl_zhiweiname=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
        lbl_zhiweiname.text=[NSString stringWithFormat:@"%@",array[i][@"zhiwei"]==[NSNull null]?@"":array[i][@"zhiwei"]];
        [BackView_zhaopinxinxi addSubview:lbl_zhiweiname];
        UITextView * lbl_zhiweicontent=[[UITextView alloc] initWithFrame:CGRectMake(10, lbl_zhiweiname.frame.size.height+10, SCREEN_WIDTH-20, 100)];
//        [lbl_zhiweicontent setLineBreakMode:NSLineBreakByWordWrapping];
//        lbl_zhiweicontent.numberOfLines=0;
        lbl_zhiweicontent.scrollEnabled=YES;
//        lbl_zhiweicontent.userInteractionEnabled=NO;
        lbl_zhiweicontent.text=array[i][@"content"]==[NSNull null]?@"":array[i][@"content"];
        [BackView_zhaopinxinxi addSubview:lbl_zhiweicontent];
        [self.view addSubview:BackView_zhaopinxinxi];
    }
    UIView * lastView=[self.view.subviews lastObject];
    
    zhiwei=[[UITextView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH, 80)];
    [zhiwei setKeyboardType:UIKeyboardTypeDefault];
    zhiwei.delegate=self;
    [self.view addSubview:zhiwei];
    
    uilabelzhiwei=[[UILabel alloc] initWithFrame:CGRectMake(17, lastView.frame.origin.y+lastView.frame.size.height+5+8, 100, 15)];
    uilabelzhiwei.text = @"请填写您的信息..";
    uilabelzhiwei.enabled = NO;//lable必须设置为不可用
    uilabelzhiwei.font=[UIFont systemFontOfSize:13];
    uilabelzhiwei.backgroundColor = [UIColor clearColor];
    [self.view addSubview:uilabelzhiwei];
    lbl_zishuzhiwei=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, lastView.frame.origin.y+lastView.frame.size.height+5+zhiwei.frame.size.height-30, 150, 15)];
    lbl_zishuzhiwei.text=@"还能输入140个字";
    lbl_zishuzhiwei.enabled=NO;
    lbl_zishuzhiwei.font=[UIFont systemFontOfSize:13];
    lbl_zishuzhiwei.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lbl_zishuzhiwei];
    UIButton * btn_zhiwei=[[UIButton alloc] initWithFrame:CGRectMake(20, zhiwei.frame.origin.y+zhiwei.frame.size.height+10, SCREEN_WIDTH-40, 35)];
    btn_zhiwei.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
    [btn_zhiwei addTarget:self action:@selector(zhiweiSubmit) forControlEvents:UIControlEventTouchUpInside];
    [btn_zhiwei setTitle:@"提交" forState:UIControlStateNormal];
    [self.view addSubview:btn_zhiwei];
    
}
-(void)zhiweiSubmit
{
    if (zhiwei.text.length>0) {
        NSString * content= zhiwei.text;
        NSDictionary * prm=@{@"userid":_UserInfoData[@"userid"],@"content":content};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"zhiweiSubmitBackCall:"];
        [dataprovider chengpinSubmit:prm];
    }
    
}
-(void)zhiweiSubmitBackCall:(id)dict
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}

-(void)GetZhaoShangInfo
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetZhaoShangInfoBackCall:"];
    [dataprovider GetZhaoShangInfo];
}
-(void)GetZhaoShangInfoBackCall:(id)dict
{
    NSLog(@"%@",dict);
    UIScrollView * scrollview_jiameng=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    
    NSArray * array=[[NSArray alloc] initWithArray:dict[@"data"]];
    for (int i=0; i<array.count; i++) {
        UIView *lastView;
        UIView * BackView_zhaopinxinxi;
        if (i==0) {
            BackView_zhaopinxinxi=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-130-NavigationBar_HEIGHT-20)];
        }
        else
        {
            lastView=[self.view.subviews lastObject];
            BackView_zhaopinxinxi=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y, SCREEN_WIDTH, 100)];
        }
        UILabel * lbl_zhiweiname=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-20, 20)];
        lbl_zhiweiname.text=[NSString stringWithFormat:@"%@",array[i][@"title"]==[NSNull null]?@"":array[i][@"title"]];
        [BackView_zhaopinxinxi addSubview:lbl_zhiweiname];
        UITextView * lbl_zhiweicontent=[[UITextView alloc] initWithFrame:CGRectMake(10, lbl_zhiweiname.frame.size.height+10, SCREEN_WIDTH-20, SCREEN_HEIGHT-150-lbl_zhiweiname.frame.size.height)];
        lbl_zhiweicontent.font=[UIFont systemFontOfSize:16];
//        [lbl_zhiweicontent setLineBreakMode:NSLineBreakByWordWrapping];
//        lbl_zhiweicontent.numberOfLines=0;
        lbl_zhiweicontent.scrollEnabled=YES;
//        lbl_zhiweicontent.userInteractionEnabled=NO;
        lbl_zhiweicontent.text=array[i][@"content"]==[NSNull null]?@"":array[i][@"content"];
        [BackView_zhaopinxinxi addSubview:lbl_zhiweicontent];
        [scrollview_jiameng addSubview:BackView_zhaopinxinxi];
        
    }
//    UIView * lastView=[self.view.subviews lastObject];
    
    zhaoshang=[[UITextView alloc] initWithFrame:CGRectMake(0,  SCREEN_HEIGHT-130, SCREEN_WIDTH, 80)];
    [zhaoshang setKeyboardType:UIKeyboardTypeDefault];
    zhaoshang.delegate=self;
    [scrollview_jiameng addSubview:zhaoshang];
    
    uilabelzhaoshang=[[UILabel alloc] initWithFrame:CGRectMake(17, SCREEN_HEIGHT-117, 100, 15)];
    uilabelzhaoshang.text = @"请填写招商信息..";
    uilabelzhaoshang.enabled = NO;//lable必须设置为不可用
    uilabelzhaoshang.font=[UIFont systemFontOfSize:13];
    uilabelzhaoshang.backgroundColor = [UIColor clearColor];
    [scrollview_jiameng addSubview:uilabelzhaoshang];
//    UILabel * lbl_zishuzhiwei=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, lastView.frame.origin.y+lastView.frame.size.height+5+zhiwei.frame.size.height-30, 150, 15)];
    lbl_zishuzhaoshang.text=@"还能输入140个字";
    lbl_zishuzhaoshang.enabled=NO;
    lbl_zishuzhaoshang.font=[UIFont systemFontOfSize:13];
    lbl_zishuzhaoshang.backgroundColor=[UIColor clearColor];
    [scrollview_jiameng addSubview:lbl_zishuzhaoshang];
    UIButton * btn_zhiwei=[[UIButton alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT-50, SCREEN_WIDTH-40, 35)];
    btn_zhiwei.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
    [btn_zhiwei addTarget:self action:@selector(zhaoshangSubmit) forControlEvents:UIControlEventTouchUpInside];
    [btn_zhiwei setTitle:@"提交" forState:UIControlStateNormal];
    [scrollview_jiameng addSubview:btn_zhiwei];

    scrollview_jiameng.contentSize=CGSizeMake(0, SCREEN_HEIGHT+250);
    [self.view addSubview:scrollview_jiameng];
}
-(void)zhaoshangSubmit
{
    if (zhaoshang.text.length>0) {
        NSString * content= zhaoshang.text;
        NSDictionary * prm=@{@"userid":_UserInfoData[@"userid"],@"content":content};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"zhaoshangSubmitBackCall:"];
        [dataprovider zhaoshangSubmit:prm];
    }
    
}
-(void)zhaoshangSubmitBackCall:(id)dict
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}

@end
