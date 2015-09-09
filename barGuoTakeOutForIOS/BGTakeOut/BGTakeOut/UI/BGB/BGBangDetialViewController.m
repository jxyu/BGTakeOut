//
//  BGBangDetialViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BGBangDetialViewController.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "TQStarRatingView.h"
#import "SDCycleScrollView.h"
#import "AMRatingControl.h"
#import "UIImageView+WebCache.h"
#import "UMSocial.h"
#import "CWStarRateView.h"
#define KURL @"http://112.74.76.91/baguo/"
@interface BGBangDetialViewController ()
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@end

@implementation BGBangDetialViewController
{
    UIScrollView * ScrollView_page;
    UIView * page;
    AMRatingControl *starRatingView_weidao;
    AMRatingControl *starRatingView_weisheng;
    AMRatingControl *starRatingView_huanjing;
    AMRatingControl *starRatingView_fuwu;
    AMRatingControl *starRatingView_xingjiabi;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"巴国榜文章详情"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    page=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-20)];
    page.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:page];
    UIView * fillview=[[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 120)];
    fillview.tag=101;
    [page addSubview:fillview];
    ScrollView_page=[[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-20-40)];
    ScrollView_page.scrollEnabled=YES;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetBGBangDetialBackCall:"];
    [dataprovider GetBGBangDetialWith:_articleid];
}

-(void)GetBGBangDetialBackCall:(id)dict
{
    NSLog(@"%@",dict);
    //添加scollView
    id result =dict[@"data"];
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<4; i++) {
        UIImageView * img=[[UIImageView alloc] init];
        [img sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,result[@"data"][i][@"adurl"]]] placeholderImage:[UIImage imageNamed:@"placeholder@2x.png"] ];
        [images addObject:img];
    }
    
    NSArray *titles = @[@"第一张轮播图",
                        @"第二张轮播图",
                        @"第三张轮播图",
                        @"第四张轮播图"
                        ];
    // 创建带标题的图片轮播器
    for (UIView *item in page.subviews) {
        if(101==item.tag)
        {
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:item.frame imagesGroup:images ];
        }
    }
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.titlesGroup = titles;
    
    [ScrollView_page addSubview:_cycleScrollView];

    UIView * BackVeiw_star=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.origin.y+_cycleScrollView.frame.size.height+5, SCREEN_WIDTH, 170)];
    BackVeiw_star.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_weidao=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    lbl_weidao.text=@"味道";
//    CWStarRateView * weidao=[[CWStarRateView alloc] initWithFrame:CGRectMake(lbl_weidao.frame.origin.x+lbl_weidao.frame.size.width+8,lbl_weidao.frame.origin.y,230,lbl_weidao.frame.size.height) numberOfStars:10];
//    weidao.scorePercent = [dict[@"data"][@"tastescore"] floatValue]/10;
//    weidao.allowIncompleteStar = NO;
//    weidao.hasAnimation = YES;
//    [BackVeiw_star addSubview:weidao];
    starRatingView_weidao =[[AMRatingControl alloc] initWithLocation:CGPointMake(80, 8)
                                                          emptyColor:[UIColor lightGrayColor]
                                                          solidColor:[UIColor redColor]
                                                        andMaxRating:10];
    [starRatingView_weidao setUserInteractionEnabled:NO];
    starRatingView_weidao.backgroundColor=[UIColor clearColor];
    starRatingView_weidao.rating=[dict[@"data"][@"tastescore"] intValue];
    starRatingView_weidao.tag=1;
    [BackVeiw_star addSubview:lbl_weidao];
    [BackVeiw_star addSubview:starRatingView_weidao];
    UILabel * lbl_weisheng=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_weidao.frame.origin.y+lbl_weidao.frame.size.height+10, 60, 20)];
    lbl_weisheng.text=@"卫生";
//    CWStarRateView * weisheng=[[CWStarRateView alloc] initWithFrame:CGRectMake(lbl_weisheng.frame.origin.x+lbl_weisheng.frame.size.width+10,lbl_weisheng.frame.origin.y,230,+lbl_weidao.frame.size.height) numberOfStars:10];
//    weisheng.scorePercent = [dict[@"data"][@"hygienismscore"] floatValue]/10;
//    weisheng.allowIncompleteStar = NO;
//    weisheng.hasAnimation = YES;
//    [BackVeiw_star addSubview:weisheng];
    starRatingView_weisheng =[[AMRatingControl alloc] initWithLocation:CGPointMake(80, lbl_weidao.frame.origin.y+lbl_weidao.frame.size.height+8)
                                                            emptyColor:[UIColor lightGrayColor]
                                                            solidColor:[UIColor redColor]
                                                          andMaxRating:10];
    [starRatingView_weisheng setUserInteractionEnabled:NO];
    starRatingView_weisheng.backgroundColor=[UIColor clearColor];
    starRatingView_weisheng.rating=[dict[@"data"][@"hygienismscore"] intValue];
    starRatingView_weisheng.tag=2;
    [BackVeiw_star addSubview:lbl_weisheng];
    [BackVeiw_star addSubview:starRatingView_weisheng];
    
    UILabel * lbl_huanjing=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_weisheng.frame.origin.y+lbl_weisheng.frame.size.height+10, 60, 20)];
    lbl_huanjing.text=@"环境";
//    CWStarRateView * huanjing=[[CWStarRateView alloc] initWithFrame:CGRectMake(lbl_huanjing.frame.origin.x+lbl_huanjing.frame.size.width+10,lbl_huanjing.frame.origin.y,230,+lbl_huanjing.frame.size.height) numberOfStars:10];
//    huanjing.scorePercent = [dict[@"data"][@"environmentscore"] floatValue]/10;
//    huanjing.allowIncompleteStar = NO;
//    huanjing.hasAnimation = YES;
//    [BackVeiw_star addSubview:huanjing];
    starRatingView_huanjing=[[AMRatingControl alloc] initWithLocation:CGPointMake(80, lbl_weisheng.frame.origin.y+lbl_weisheng.frame.size.height+8)
                                                           emptyColor:[UIColor lightGrayColor]
                                                           solidColor:[UIColor redColor]
                                                         andMaxRating:10];
    [starRatingView_huanjing setUserInteractionEnabled:NO];
    starRatingView_huanjing.backgroundColor=[UIColor clearColor];
    starRatingView_huanjing.rating=[dict[@"data"][@"environmentscore"] intValue];
    starRatingView_huanjing.tag=3;
    [BackVeiw_star addSubview:lbl_huanjing];
    [BackVeiw_star addSubview:starRatingView_huanjing];
    
    UILabel * lbl_fuwu=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_huanjing.frame.origin.y+lbl_huanjing.frame.size.height+10, 60, 20)];
    lbl_fuwu.text=@"服务";
//    CWStarRateView * fuwu=[[CWStarRateView alloc] initWithFrame:CGRectMake(lbl_fuwu.frame.origin.x+lbl_fuwu.frame.size.width+10,lbl_fuwu.frame.origin.y,230,+lbl_fuwu.frame.size.height) numberOfStars:10];
//    fuwu.scorePercent = [dict[@"data"][@"servicescore"] floatValue]/10;
//    fuwu.allowIncompleteStar = NO;
//    fuwu.hasAnimation = YES;
//    [BackVeiw_star addSubview:fuwu];
    starRatingView_fuwu =[[AMRatingControl alloc] initWithLocation:CGPointMake(80, lbl_huanjing.frame.origin.y+lbl_huanjing.frame.size.height+8)
                                                        emptyColor:[UIColor lightGrayColor]
                                                        solidColor:[UIColor redColor]
                                                      andMaxRating:10];
    [starRatingView_fuwu setUserInteractionEnabled:NO];
    starRatingView_fuwu.backgroundColor=[UIColor clearColor];
    starRatingView_fuwu.rating=[dict[@"data"][@"servicescore"] intValue];
    starRatingView_fuwu.tag=4;
    [BackVeiw_star addSubview:lbl_fuwu];
    [BackVeiw_star addSubview:starRatingView_fuwu];
    
    UILabel * lbl_xingjiabi=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_fuwu.frame.origin.y+lbl_fuwu.frame.size.height+10, 60, 20)];
    lbl_xingjiabi.text=@"性价比";
//    CWStarRateView * xingjiabi=[[CWStarRateView alloc] initWithFrame:CGRectMake(lbl_xingjiabi.frame.origin.x+lbl_xingjiabi.frame.size.width+10,lbl_xingjiabi.frame.origin.y,230,+lbl_xingjiabi.frame.size.height) numberOfStars:10];
//    xingjiabi.scorePercent = [dict[@"data"][@"costperformancescore"] floatValue]/10;
//    xingjiabi.allowIncompleteStar = NO;
//    xingjiabi.hasAnimation = YES;
//    [BackVeiw_star addSubview:xingjiabi];
    starRatingView_xingjiabi =[[AMRatingControl alloc] initWithLocation:CGPointMake(80, lbl_fuwu.frame.origin.y+lbl_fuwu.frame.size.height+8)
                                                             emptyColor:[UIColor lightGrayColor]
                                                             solidColor:[UIColor redColor]
                                                           andMaxRating:10];
    [starRatingView_xingjiabi setUserInteractionEnabled:NO];
    starRatingView_xingjiabi.backgroundColor=[UIColor clearColor];
    starRatingView_xingjiabi.tag=5;
    starRatingView_xingjiabi.rating=[dict[@"data"][@"costperformancescore"] intValue];
    [BackVeiw_star addSubview:lbl_xingjiabi];
    [BackVeiw_star addSubview:starRatingView_xingjiabi];
 
    [ScrollView_page addSubview:BackVeiw_star];
    UITextView * lbl_baguobangContent=[[UITextView alloc] initWithFrame:CGRectMake(0, BackVeiw_star.frame.origin.y+BackVeiw_star.frame.size.height+5, SCREEN_WIDTH, 200)];
    lbl_baguobangContent.text=dict[@"data"][@"content"];
    lbl_baguobangContent.scrollEnabled=YES;
    [ScrollView_page addSubview:lbl_baguobangContent];
    page.frame=CGRectMake(page.frame.origin.x, page.frame.origin.y, page.frame.size.width, lbl_baguobangContent.frame.size.height+lbl_baguobangContent.frame.origin.y+10);
    [ScrollView_page setContentSize:CGSizeMake(0, lbl_baguobangContent.frame.size.height+lbl_baguobangContent.frame.origin.y+10)];
    [self.view addSubview:ScrollView_page];
    
    UIButton * btn_mydianzan=[[UIButton alloc] initWithFrame:CGRectMake(10, SCREEN_HEIGHT-40, (SCREEN_WIDTH-20)/3, 30)];
    btn_mydianzan.backgroundColor=[UIColor whiteColor];
    if ([_isstarted intValue]==1) {
        [btn_mydianzan setImage:[UIImage imageNamed:@"bgb_dianzan_hong"] forState:UIControlStateNormal];
        [btn_mydianzan setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else
    {
        [btn_mydianzan setImage:[UIImage imageNamed:@"bgb_dianzan_hui"] forState:UIControlStateNormal];
        [btn_mydianzan setTitleColor:[UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    [btn_mydianzan setTitle:[NSString stringWithFormat:@"(%@)喜欢", dict[@"data"][@"starnum"]!=[NSNull null]?dict[@"data"][@"starnum"]:@"0"]forState:UIControlStateNormal];
    btn_mydianzan.titleLabel.font=[UIFont systemFontOfSize:13];
    [btn_mydianzan addTarget:self action:@selector(dianzanFunction:) forControlEvents:UIControlEventTouchUpInside];
    btn_mydianzan.layer.borderWidth=1;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 220/255.0,220/255.0, 220/255.0, 1 });
    btn_mydianzan.layer.borderColor=colorref;
    [self.view addSubview:btn_mydianzan];
    UIButton * btn_pinglun=[[UIButton alloc] initWithFrame:CGRectMake(btn_mydianzan.frame.origin.x+btn_mydianzan.frame.size.width, SCREEN_HEIGHT-40, (SCREEN_WIDTH-20)/3, 30 )];
    btn_pinglun.backgroundColor=[UIColor whiteColor];
    btn_pinglun.imageView.bounds=CGRectMake(0, 0, 10, 10);
    if (dict[@"data"][@"isrecommend"]!=[NSNull null]&&[dict[@"data"][@"isrecommend"] intValue]==1)
    {
        [btn_pinglun setImage:[UIImage imageNamed:@"bgb_pinglunicon_hong"] forState:UIControlStateNormal];
        [btn_pinglun setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    else
    {
        [btn_pinglun setImage:[UIImage imageNamed:@"bgb_pinglunicon_hui"] forState:UIControlStateNormal];
        [btn_pinglun setTitleColor:[UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    
    [btn_pinglun setTitle:[NSString stringWithFormat:@"（%@）评论",dict[@"data"][@"count"]!=[NSNull null]?dict[@"data"][@"count"]:@"0"] forState:UIControlStateNormal];
    btn_pinglun.titleLabel.font=[UIFont systemFontOfSize:13];
    btn_pinglun.layer.borderWidth=1;
    [btn_pinglun addTarget:self action:@selector(showPinglunView) forControlEvents:UIControlEventTouchUpInside];
    btn_pinglun.layer.borderColor=colorref;
    [self.view addSubview:btn_pinglun];
    UIButton * btn_share=[[UIButton alloc] initWithFrame:CGRectMake(btn_pinglun.frame.origin.x+btn_pinglun.frame.size.width, SCREEN_HEIGHT-40, (SCREEN_WIDTH-20)/3, 30 )];
    [btn_share setImage:[UIImage imageNamed:@"fenxianghui@2x"] forState:UIControlStateNormal];
    btn_share.backgroundColor=[UIColor whiteColor];
    [btn_share setTitle:[NSString stringWithFormat:@"分享"] forState:UIControlStateNormal];
    [btn_share setTitleColor:[UIColor colorWithRed:121/255.0 green:121/255.0 blue:121/255.0 alpha:1.0] forState:UIControlStateNormal];
    [btn_share addTarget:self action:@selector(shareClicked:) forControlEvents:UIControlEventTouchUpInside];
    btn_share.titleLabel.font=[UIFont systemFontOfSize:13];
    btn_share.layer.borderWidth=1;
    btn_share.layer.borderColor=colorref;
    [self.view addSubview:btn_share];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
-(void)showPinglunView
{
    _myPinglun=[[PinglunForBGBangViewController alloc] init];
    _myPinglun.userid=_userid;
    _myPinglun.articleid=_articleid;
    [self.navigationController pushViewController:_myPinglun animated:YES];
}
-(void)shareClicked:(id)sender{
    //分享巴国榜
    NSString *shareText = @"快来加入掌尚街，享受生活的乐趣吧！";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"1136-1"];          //分享内嵌图片
    NSArray* snsList=    [NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,nil];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:umeng_app_key
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:snsList
                                       delegate:nil];
}
-(void)dianzanFunction:(UIButton *)sender
{
    if (_userid) {
        [SVProgressHUD showWithStatus:@"点赞" maskType:SVProgressHUDMaskTypeBlack];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"dianzanBackCall:"];
        [dataprovider BGBangDianzanFuncWithuserid:_userid  andartid:_articleid];
    }else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"请先登录" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }
}
-(void)dianzanBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if ([dict[@"status"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:@"点赞成功" maskType:SVProgressHUDMaskTypeBlack];
        
    }
}

@end
