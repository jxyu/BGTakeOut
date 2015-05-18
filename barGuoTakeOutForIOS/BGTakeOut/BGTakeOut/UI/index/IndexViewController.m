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
#define kSWidth self.view.bounds.size.width
#define kSHeight self.view.bounds.size.height
#define kJianXi 5
#define tabBarButtonNum 4
#define KURL @"http://121.42.139.60/baguo/"

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
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    @try {
        if ([Toolkit isSystemIOS8]) {
            [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
                NSLog(@"%@",addressString);
                NSString *strUrl = [addressString stringByReplacingOccurrencesOfString:@"中国" withString:@""];
                [self setBarTitle:[strUrl stringByReplacingOccurrencesOfString:@"(null)" withString:@""]] ;
            }];
        }
        
        UIScrollView *scrollView_BackView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT)];
        scrollView_BackView.scrollEnabled=YES;
        page=[[UIView alloc ] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kSHeight-49)];
        UIButton * btn_location=[[UIButton alloc] initWithFrame:CGRectMake(50, 0, kSWidth-100, 64)];
        [btn_location addTarget:self action:@selector(GetLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn_location];
        
        UIView * fillview=[[UIView alloc] initWithFrame:CGRectMake(0,0, kSWidth, 120)];
        fillview.tag=101;
        [page addSubview:fillview];
        
        //添加我要点餐按钮
        UIView *lastinarray=[page.subviews lastObject];
        CGFloat y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
        UIButton * WaiMai= [[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth, 100)];
        [WaiMai setImage:[UIImage imageNamed:@"WaiMai.jpg"] forState:UIControlStateNormal];
        [WaiMai addTarget:self action:@selector(DoMyWaiMai) forControlEvents:UIControlEventTouchUpInside];
        [page addSubview:WaiMai];
        
        //添加每日笑话按钮
        lastinarray=[page.subviews lastObject] ;
        y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
        UIButton * Joke= [[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth/2-1, 70)];
        [Joke setImage:[UIImage imageNamed:@"joke.jpg"] forState:UIControlStateNormal];
        [Joke addTarget:self action:@selector(JumpToJoke) forControlEvents:UIControlEventTouchUpInside];
        [page addSubview:Joke];
        
        //添加幸运星按钮
        lastinarray=[page.subviews lastObject] ;
        CGFloat x=lastinarray.frame.size.width+2;
        UIButton * luck= [[UIButton alloc] initWithFrame:CGRectMake(x, y, kSWidth/2-1, 70)];
        [luck setImage:[UIImage imageNamed:@"luck.jpg"] forState:UIControlStateNormal];
        [luck addTarget:self action:@selector(jumpToLuck) forControlEvents:UIControlEventTouchUpInside];
        [page addSubview:luck];
        
        //更多礼品按钮
        lastinarray=[page.subviews lastObject] ;
        y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
        UIButton * Gift= [[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth, 28)];
        [Gift setImage:[UIImage imageNamed:@"lipin_more.jpg"] forState:UIControlStateNormal];
        [Gift addTarget:self action:@selector(MoreGift) forControlEvents:UIControlEventTouchUpInside];
        [page addSubview:Gift];
        
        //添加下面展示的三样礼品
        lastinarray=[page.subviews lastObject] ;
        y=[lastinarray frame].origin.y+lastinarray.frame.size.height;
        UIButton * Gift_1= [[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth/2, 120)];
        [Gift_1 setImage:[UIImage imageNamed:@"lipin_weidan.png"] forState:UIControlStateNormal];
        Gift_1.backgroundColor=[UIColor brownColor];
        [Gift_1 addTarget:self action:@selector(testclick) forControlEvents:UIControlEventTouchUpInside];
        [page addSubview:Gift_1];
        lastinarray=[page.subviews lastObject] ;
        x=lastinarray.frame.size.width;
        UIButton * Gift_2 =[[UIButton alloc] initWithFrame:CGRectMake(x, y, kSWidth/2, 60)];
        [Gift_2 setImage:[UIImage imageNamed:@"lipin_xiaomi.png"] forState:UIControlStateNormal];
        Gift_2.backgroundColor=[UIColor brownColor];
        [Gift_2 addTarget:self action:@selector(gotoRightUp) forControlEvents:UIControlEventTouchUpInside];
        [page addSubview:Gift_2];
        lastinarray=[page.subviews lastObject] ;
        y=[lastinarray frame].origin.y+lastinarray.frame.size.height;
        UIButton * Gift_3= [[UIButton alloc] initWithFrame:CGRectMake(x, y, kSWidth/2, 60)];
        [Gift_3 setImage:[UIImage imageNamed:@"lipin_kindle.png"] forState:UIControlStateNormal] ;
        Gift_3.backgroundColor=[UIColor brownColor];
        [page addSubview:Gift_3];
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
    //添加scollView
    id result =dict;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<[result[@"data"] count]; i++) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,result[@"data"][i][@"adurl"]]] placeholderImage:[UIImage imageNamed:@"placeholder@2x.png"] ];

        [images addObject:img];
    }
    
    NSArray *titles = @[@"",
                        @"",
                        @"",
                        @""
                        ];
    // 创建带标题的图片轮播器
    for (UIView *item in page.subviews) {
        if(101==item.tag)
        {
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:item.frame imagesGroup:images ];
        }
    }
    _cycleScrollView.pageControlAliment =     SDCycleScrollViewPageContolAlimentCenter;
    _cycleScrollView.delegate = self;
    _cycleScrollView.titlesGroup = titles;
    
    [page addSubview:_cycleScrollView];
    
    [SVProgressHUD dismiss];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)GetLocation
{
    self.autolocation=[[AutoLocationViewController alloc] initWithNibName:@"AutoLocationViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_autolocation animated:YES];
}

-(void)DoMyWaiMai
{
    self.myWaiMai=[[WaiMAIViewController alloc] initWithNibName:@"WaiMAIViewController" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:_myWaiMai animated:YES];
    
}
-(void)gotoRightUp{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary* userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userinfoWithFile){
        //!!!:  已经登录完成，调用接口获取免登陆链接在页面中显示
        DataProvider* dataProvider1=[[DataProvider alloc] init];
        [dataProvider1 setDelegateObject:self setBackFunctionName:@"getDuibaAutoLoginUrlDetail:"];

        [dataProvider1 getduibaurlForDetailWithAppkey:duiba_app_key appsecret:duiba_app_secret userid:userinfoWithFile[@"userid"] url:@"http://www.duiba.com.cn/turntable/index/2511"];
        
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
        LoginViewController* loginVC=        [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
}
-(void)getDuibaAutoLoginUrlDetail:(id)dict{
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
    NSDictionary* userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userinfoWithFile){
        //!!!:  已经登录完成，调用接口获取免登陆链接在页面中显示
        DataProvider* dataProvider=[[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getDuibaAutoLoginUrl:"];
[        dataProvider getduibaurlWithAppkey:duiba_app_key appsecret:duiba_app_secret userid:userinfoWithFile[@"userid"]];
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
LoginViewController* loginVC=        [[LoginViewController alloc] init];
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
    LuckyGameViewController* luck=[[LuckyGameViewController alloc]init];
    [self.navigationController pushViewController:luck animated:YES];
}
@end
