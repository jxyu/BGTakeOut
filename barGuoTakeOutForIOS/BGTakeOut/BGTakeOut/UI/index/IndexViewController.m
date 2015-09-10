//
//  IndexViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/17.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "IndexViewController.h"
#import "SDCycleScrollView.h"
#import "DataProvider.h"
#import "CCLocationManager.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "CreditWebViewController.h"
#import "CreditNavigationController.h"
#import "UIImageView+WebCache.h"
#import "Toolkit.h"
#define kJianXi 5
#define tabBarButtonNum 4
#define KURL @"http://112.74.76.91/baguo/"

@interface IndexViewController ()
{
}
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)UIButton * AutoLocation;
//@property(nonatomic,strong)UIView * package;
//@property(nonatomic,strong)UIView * Page;


@end

@implementation IndexViewController
{
    UIView * page;
    NSDictionary* userinfoWithFile;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    @try {
//        _imgLeft.image=[UIImage imageNamed:@"index_location"];
//        _imgRight.image=[UIImage imageNamed:@"index_down"];
        [self setBarTitle:@"自动定位"] ;
        _lblTitle.bounds=CGRectMake(0, 0, 125, 30);
        UIImageView * image_left=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, _lblTitle.frame.origin.y+6, 13, 15)];
        image_left.tag=1111;
        image_left.image=[UIImage imageNamed:@"index_location"];
//        [self.view addSubview:image_left];
        UIImageView * image_right=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+35, _lblTitle.frame.origin.y+11, 12, 7)];
        image_right.tag=1112;
        image_right.image=[UIImage imageNamed:@"index_down"];
        [self.view addSubview:image_right];
        [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
            NSLog(@"%@",addressString);
            [self setBarTitle:[addressString stringByReplacingOccurrencesOfString:@"(null)" withString:@""]] ;
            image_left.frame=CGRectMake(_lblTitle.frame.origin.x-25, image_left.frame.origin.y, 13, 15);
            image_right.frame=CGRectMake(image_left.frame.origin.x+143, image_right.frame.origin.y, 12, 7);
        }];
        
        NSDictionary * dict=[[NSDictionary alloc] init];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AreaInfo.plist"];
        BOOL result= [dict writeToFile:plistPath atomically:YES];
        if (result) {
            
        }
        
        
        UIScrollView *scrollView_BackView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-20-49)];
        scrollView_BackView.scrollEnabled=YES;
        page=[[UIView alloc ] init];
        UIButton * btn_location=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        [btn_location addTarget:self action:@selector(GetLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_location];
        
        UIView * fillview=[[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 140)];
        fillview.tag=101;
        [page addSubview:fillview];
        
        //添加我要点餐按钮
        UIView *lastinarray=[page.subviews lastObject];
        
        CGFloat y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
        UIView * BackView_Waimai=[[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 100)];
        BackView_Waimai.backgroundColor=[UIColor whiteColor];
        UIImageView * imgV_waimai1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 25, 50, 50)];
        imgV_waimai1.image=[UIImage imageNamed:@"index_waimai1"];
        [BackView_Waimai addSubview:imgV_waimai1];
        UILabel * lbl_waimaititle=[[UILabel alloc] initWithFrame:CGRectMake(imgV_waimai1.frame.origin.x+imgV_waimai1.frame.size.width+5, 20, 150, 30)];
        lbl_waimaititle.text=@"外卖订餐";
        lbl_waimaititle.textColor=[UIColor redColor];
        [BackView_Waimai addSubview:lbl_waimaititle];
        UILabel * lbl_waimaidetail=[[UILabel alloc] initWithFrame:CGRectMake(imgV_waimai1.frame.origin.x+imgV_waimai1.frame.size.width+5, lbl_waimaititle.frame.origin.y+lbl_waimaititle.frame.size.height+5, 150, 15)];
        lbl_waimaidetail.text=@"附近美食，优惠多多";
        lbl_waimaidetail.textColor=[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1.0];
        lbl_waimaidetail.font=[UIFont systemFontOfSize:13];
        [BackView_Waimai addSubview:lbl_waimaidetail];
        UIImageView * imgV_waimai2=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_waimaititle.frame.origin.x+lbl_waimaititle.frame.size.width, 20, 60, 60)];
        imgV_waimai2.image=[UIImage imageNamed:@"index_waimai2"];
        [BackView_Waimai addSubview:imgV_waimai2];
        UIImageView * img_go=[[UIImageView alloc] initWithFrame:CGRectMake(BackView_Waimai.frame.size.width-21, 40, 11, 16)];
        img_go.image=[UIImage imageNamed:@"go.png"];
        [BackView_Waimai addSubview:img_go];
        [page addSubview:BackView_Waimai];
        UIButton * WaiMai= [[UIButton alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 100)];
        [WaiMai addTarget:self action:@selector(DoMyWaiMai) forControlEvents:UIControlEventTouchUpInside];
        [page addSubview:WaiMai];
        
        //添加每日笑话按钮
        lastinarray=[page.subviews lastObject] ;
        y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
        UIButton * Joke= [[UIButton alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH/2-1, 70)];
        [Joke setBackgroundColor:[UIColor whiteColor]];
        [Joke setImage:[UIImage imageNamed:@"joke@2x.jpg"] forState:UIControlStateNormal];
        [Joke addTarget:self action:@selector(JumpToJoke) forControlEvents:UIControlEventTouchUpInside];
        [Joke setShowsTouchWhenHighlighted:YES];
        [page addSubview:Joke];
        
        //添加幸运星按钮
        lastinarray=[page.subviews lastObject] ;
        CGFloat x=lastinarray.frame.size.width+2;
        UIButton * luck= [[UIButton alloc] initWithFrame:CGRectMake(x, y, SCREEN_WIDTH/2-1, 70)];
        [luck setImage:[UIImage imageNamed:@"luck@2x.jpg"] forState:UIControlStateNormal];
        [luck setBackgroundColor:[UIColor whiteColor]];
        [luck addTarget:self action:@selector(jumpToLuck) forControlEvents:UIControlEventTouchUpInside];
        [luck setShowsTouchWhenHighlighted:YES];
        [page addSubview:luck];
        
        //更多礼品按钮
        lastinarray=[page.subviews lastObject] ;
        y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
        UIView * backView_moreGift=[[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, 40)];
        backView_moreGift.backgroundColor=[UIColor whiteColor];
        UIImageView * image_moregift=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 17, 17)];
        image_moregift.image=[UIImage imageNamed:@"lipinicon"];
        [backView_moreGift addSubview:image_moregift];
        UILabel * lbl_moreTitle=[[UILabel alloc] initWithFrame:CGRectMake(image_moregift.frame.origin.x+image_moregift.frame.size.width+5, 10, 100, 20)];
        lbl_moreTitle.text=@"巴国礼品站";
        [backView_moreGift addSubview:lbl_moreTitle];
        UILabel * lbl_more=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 10, 50, 20)];
        lbl_more.text=@"更多";
        lbl_more.font=[UIFont systemFontOfSize:15];
        lbl_more.textColor=[UIColor grayColor];
        [backView_moreGift addSubview:lbl_more];
        UIImageView * img_go_more=[[UIImageView alloc] initWithFrame:CGRectMake(lbl_more.frame.origin.x+40, 12, 10, 15)];
        img_go_more.image=[UIImage imageNamed:@"go.png"];
        [backView_moreGift addSubview:img_go_more];
        UIButton * Gift= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
//        [Gift setImage:[UIImage imageNamed:@"lipin_more.jpg"] forState:UIControlStateNormal];
        [Gift addTarget:self action:@selector(MoreGift) forControlEvents:UIControlEventTouchUpInside];
        [Gift setShowsTouchWhenHighlighted:YES];
        [backView_moreGift addSubview:Gift];
        [page addSubview:backView_moreGift];
        
        //添加下面展示的三样礼品
        lastinarray=[page.subviews lastObject] ;
        y=[lastinarray frame].origin.y+lastinarray.frame.size.height;
        UIButton * Gift_1= [[UIButton alloc] initWithFrame:CGRectMake(2, y+2, SCREEN_WIDTH/2-4, 120+2)];
        [Gift_1 setBackgroundImage:[UIImage imageNamed:@"home_gift_left@2x.jpg"] forState:UIControlStateNormal];
        [Gift_1 addTarget:self action:@selector(gotoGiftLeft) forControlEvents:UIControlEventTouchUpInside];
        Gift_1.backgroundColor=[UIColor clearColor];

        [page addSubview:Gift_1];
        lastinarray=[page.subviews lastObject] ;
        x=lastinarray.frame.size.width;
        UIButton * Gift_2 =[[UIButton alloc] initWithFrame:CGRectMake(x+2+2, y+2, SCREEN_WIDTH/2-4, 60)];
        [Gift_2 setBackgroundImage:[UIImage imageNamed:@"home_gift_rightup@2x.jpg"] forState:UIControlStateNormal];
        Gift_2.backgroundColor=[UIColor clearColor];
        [Gift_2 addTarget:self action:@selector(gotoGiftRightUp) forControlEvents:UIControlEventTouchUpInside];
        [page addSubview:Gift_2];
        lastinarray=[page.subviews lastObject] ;
        y=[lastinarray frame].origin.y+lastinarray.frame.size.height;
        UIButton * Gift_3= [[UIButton alloc] initWithFrame:CGRectMake(x+2+2, y+2, SCREEN_WIDTH/2-4, 60)];
        [Gift_3 setBackgroundImage:[UIImage imageNamed:@"home_gift_rightdown@2x.jpg"] forState:UIControlStateNormal] ;
        [Gift_3 addTarget:self action:@selector(gotoGiftRightDown) forControlEvents:UIControlEventTouchUpInside];
        Gift_3.backgroundColor=[UIColor clearColor];
        [page addSubview:Gift_3];
        page.frame=CGRectMake(0, 0, SCREEN_WIDTH, Gift_3.frame.origin.y+Gift_3.frame.size.height);
        [scrollView_BackView setContentSize:CGSizeMake(page.frame.size.width, page.frame.size.height)];
        [scrollView_BackView addSubview:page];
        [self.view addSubview:scrollView_BackView];
        //获取轮播图片
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"ContinueAddUIView:"];
        [dataprovider PostGetMsg];
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}

-(void)ContinueAddUIView:(id)dict
{
    [SVProgressHUD dismiss];
    //添加scollView
    id result =dict;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<[result[@"data"] count]; i++) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,result[@"data"][i][@"adurl"]]] placeholderImage:[UIImage imageNamed:@"placeholder@2x.png"] ];
        
        [images addObject:img];
    }    for (UIView *item in page.subviews) {
        if(101==item.tag)
        {
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:item.frame imagesGroup:images ];
        }
    }
    _cycleScrollView.pageControlAliment =     SDCycleScrollViewPageContolAlimentCenter;
    //    _cycleScrollView.delegate = self;
    
    [page addSubview:_cycleScrollView];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)GetLocation
{
    self.autolocation=[[AutoLocationViewController alloc] initWithNibName:@"AutoLocationViewController" bundle:[NSBundle mainBundle]];
    [_autolocation setDelegateObject:self setBackFunctionName:@"GetautolocationBackCall:"];
    [self.navigationController pushViewController:_autolocation animated:YES];
}

-(void)GetautolocationBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    [self setBarTitle:dict[@"area"]];
}

-(void)DoMyWaiMai
{
    self.myWaiMai=[[WaiMAIViewController alloc] initWithNibName:@"WaiMAIViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_myWaiMai animated:YES];
    
}
-(void)gotoGiftRightUp{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userinfoWithFile[@"userid"]){
        //!!!:  已经登录完成，调用接口获取免登陆链接在页面中显示
        DataProvider* dataProvider1=[[DataProvider alloc] init];
        [dataProvider1 setDelegateObject:self setBackFunctionName:@"getDuibaAutoLoginUrlDetail:"];
        
        [dataProvider1 getduibaurlForDetailWithAppkey:duiba_app_key appsecret:duiba_app_secret userid:userinfoWithFile[@"userid"] url:duiba_right_up_url];
        
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
        LoginViewController* loginVC=        [[LoginViewController alloc] init];
        [loginVC setDelegateObject:self setBackFunctionName:@"CantingLoginBackCall:"];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}

-(void)gotoGiftLeft{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userinfoWithFile[@"userid"]){
        //!!!:  已经登录完成，调用接口获取免登陆链接在页面中显示
        DataProvider* dataProvider1=[[DataProvider alloc] init];
        [dataProvider1 setDelegateObject:self setBackFunctionName:@"getDuibaAutoLoginUrlDetail:"];
        
        [dataProvider1 getduibaurlForDetailWithAppkey:duiba_app_key appsecret:duiba_app_secret userid:userinfoWithFile[@"userid"] url:duiba_left_url];
        
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
        LoginViewController* loginVC=        [[LoginViewController alloc] init];
        [loginVC setDelegateObject:self setBackFunctionName:@"CantingLoginBackCall:"];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}
-(void)gotoGiftRightDown{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userinfoWithFile[@"userid"]){
        //!!!:  已经登录完成，调用接口获取免登陆链接在页面中显示
        DataProvider* dataProvider1=[[DataProvider alloc] init];
        [dataProvider1 setDelegateObject:self setBackFunctionName:@"getDuibaAutoLoginUrlDetail:"];
        
        [dataProvider1 getduibaurlForDetailWithAppkey:duiba_app_key appsecret:duiba_app_secret userid:userinfoWithFile[@"userid"] url:duiba_right_down_url];
        
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
        LoginViewController* loginVC=        [[LoginViewController alloc] init];
        [loginVC setDelegateObject:self setBackFunctionName:@"CantingLoginBackCall:"];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}
-(void)getDuibaAutoLoginUrlDetail:(id)dict{
    [SVProgressHUD dismiss];
    NSLog(@"detail:%@",dict);
    NSDictionary* d=    (    NSDictionary*)dict;
    NSString* url=    d[@"data"][@"url"];
    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrlByPresent:url];
    CreditNavigationController *nav=[[CreditNavigationController alloc]initWithRootViewController:web];
    [nav setNavColorStyle:navi_bg_color];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)JumpToJoke
{
    self.myJoke=[[JokeViewController alloc] initWithNibName:@"JokeViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_myJoke animated:YES];
}
#pragma mark - 兑吧链接
-(void)MoreGift
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userinfoWithFile[@"userid"]){
        //!!!:  已经登录完成，调用接口获取免登陆链接在页面中显示
        DataProvider* dataProvider=[[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getDuibaAutoLoginUrl:"];
        [        dataProvider getduibaurlWithAppkey:duiba_app_key appsecret:duiba_app_secret userid:userinfoWithFile[@"userid"]];
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
        LoginViewController* loginVC= [[LoginViewController alloc] init];
        [loginVC setDelegateObject:self setBackFunctionName:@"CantingLoginBackCall:"];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}
-(void)getDuibaAutoLoginUrl:(id)dict{
    NSLog(@"%@",dict);
    NSDictionary* d=    (    NSDictionary*)dict;
    NSString* url=    d[@"data"][@"url"];
    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrlByPresent:url];
    CreditNavigationController *nav=[[CreditNavigationController alloc]initWithRootViewController:web];
    [nav setNavColorStyle:navi_bg_color];
    [self presentViewController:nav animated:YES completion:nil];
}
-(void)testclick
{
    //    ResInfoViewController * myrest=[[ResInfoViewController alloc] initWithNibName:@"ResInfoViewController" bundle:[NSBundle mainBundle]];
    //    UIView * item =myrest.view;
    //    [self.view addSubview:item];
}
-(void)jumpToLuck{
//    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
//                                                              NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
//    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
//    
//    
//    if(userinfoWithFile[@"userid"]){
        //!!!:  已经登录完成，调用接口获取免登陆链接在页面中显示
        self.myLuckGift=[[LuckGiftViewController alloc] initWithNibName:@"LuckGiftViewController" bundle:[NSBundle mainBundle]];
        _myLuckGift.userid=userinfoWithFile[@"userid"];
        [self.navigationController pushViewController:_myLuckGift animated:YES];
//        DataProvider* dataProvider1=[[DataProvider alloc] init];
//        [dataProvider1 setDelegateObject:self setBackFunctionName:@"IsLuckDayBackCall:"];
//        [dataProvider1 IsLuckDay:userinfoWithFile[@"userid"]];
//    }
//    else
//    {
//        
//        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
//        LoginViewController* loginVC= [[LoginViewController alloc] init];
//        [self.navigationController pushViewController:loginVC animated:YES];
//        
//    }
}

-(void)IsLuckDayBackCall:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        
        DataProvider* dataProvider1=[[DataProvider alloc] init];
        [dataProvider1 setDelegateObject:self setBackFunctionName:@"getDuibaAutoLoginUrlDetail:"];
        [dataProvider1 getduibaurlForDetailWithAppkey:duiba_app_key appsecret:duiba_app_secret userid:userinfoWithFile[@"userid"] url:duiba_luck_game];
        
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"每月只能抽奖一次" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alert show];
    }

}

-(void)CantingLoginBackCall:(id)dict
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

@end
