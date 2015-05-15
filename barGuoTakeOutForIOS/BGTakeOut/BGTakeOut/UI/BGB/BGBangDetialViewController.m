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
#import "SDCycleScrollView.h"
#import "TQStarRatingView.h"
#import "UIImageView+WebCache.h"

#define KURL @"http://121.42.139.60/baguo/"
@interface BGBangDetialViewController ()
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@end

@implementation BGBangDetialViewController
{
    UIScrollView * ScrollView_page;
    UIView * page;
    TQStarRatingView *starRatingView_weidao;
    TQStarRatingView *starRatingView_weisheng;
    TQStarRatingView *starRatingView_huanjing;
    TQStarRatingView *starRatingView_fuwu;
    TQStarRatingView *starRatingView_xingjiabi;
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
    ScrollView_page=[[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-20-35)];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetBGBangDetialBackCall:"];
    [dataprovider GetBGBangDetialWith:_articleid];
}

-(void)GetBGBangDetialBackCall:(id)dict
{
    NSLog(@"%@",dict);
    //添加scollView
    id result =dict[@"data"];
    NSArray * imgArray=[[NSArray alloc] initWithObjects:result[@"img1"],result[@"img2"],result[@"img3"],result[@"img4"], nil];
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
    _cycleScrollView.delegate = self;
    _cycleScrollView.titlesGroup = titles;
    
    [page addSubview:_cycleScrollView];
    UIView * BackVeiw_star=[[UIView alloc] initWithFrame:CGRectMake(0, _cycleScrollView.frame.origin.y+_cycleScrollView.frame.size.height+5, SCREEN_WIDTH, 200)];
    UILabel * lbl_weidao=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    lbl_weidao.text=@"味道";
    starRatingView_weidao =[[TQStarRatingView alloc] initWithFrame:CGRectMake(lbl_weidao.frame.origin.x+lbl_weidao.frame.size.width,10 , 25*[dict[@"data"][@"tastescore"] intValue], 20) numberOfStar:[dict[@"data"][@"tastescore"] intValue]];
    [BackVeiw_star addSubview:lbl_weidao];
    [BackVeiw_star addSubview:starRatingView_weidao];
    
    UILabel * lbl_weisheng=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_weidao.frame.origin.y+lbl_weidao.frame.size.height+10, 60, 20)];
    lbl_weisheng.text=@"卫生";
    starRatingView_weisheng =[[TQStarRatingView alloc] initWithFrame:CGRectMake(lbl_weisheng.frame.origin.x+lbl_weisheng.frame.size.width,starRatingView_weidao.frame.origin.y+starRatingView_weidao.frame.size.height+10 , 25*[dict[@"data"][@"hygienismscore"] intValue], 20) numberOfStar:[dict[@"data"][@"hygienismscore"] intValue]];
    [BackVeiw_star addSubview:lbl_weisheng];
    [BackVeiw_star addSubview:starRatingView_weisheng];
    
    UILabel * lbl_huanjing=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_weisheng.frame.origin.y+lbl_weisheng.frame.size.height+10, 60, 20)];
    lbl_huanjing.text=@"环境";
    starRatingView_huanjing=[[TQStarRatingView alloc] initWithFrame:CGRectMake(lbl_huanjing.frame.origin.x+lbl_huanjing.frame.size.width,starRatingView_weisheng.frame.origin.y+starRatingView_weisheng.frame.size.height+10  , 25*[dict[@"data"][@"environmentscore"] intValue], 20) numberOfStar:[dict[@"data"][@"environmentscore"] intValue]];
    [BackVeiw_star addSubview:lbl_huanjing];
    [BackVeiw_star addSubview:starRatingView_huanjing];
    
    UILabel * lbl_fuwu=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_huanjing.frame.origin.y+lbl_huanjing.frame.size.height+10, 60, 20)];
    lbl_fuwu.text=@"服务";
    starRatingView_fuwu =[[TQStarRatingView alloc] initWithFrame:CGRectMake(lbl_fuwu.frame.origin.x+lbl_fuwu.frame.size.width,starRatingView_huanjing.frame.origin.y+starRatingView_huanjing.frame.size.height+10  , 25*[dict[@"data"][@"servicescore"] intValue], 20) numberOfStar:[dict[@"data"][@"servicescore"] intValue]];
    [BackVeiw_star addSubview:lbl_fuwu];
    [BackVeiw_star addSubview:starRatingView_fuwu];
    
    UILabel * lbl_xingjiabi=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_fuwu.frame.origin.y+lbl_fuwu.frame.size.height+10, 60, 20)];
    lbl_xingjiabi.text=@"性价比";
    starRatingView_xingjiabi =[[TQStarRatingView alloc] initWithFrame:CGRectMake(lbl_xingjiabi.frame.origin.x+lbl_xingjiabi.frame.size.width,starRatingView_fuwu.frame.origin.y+starRatingView_fuwu.frame.size.height+10, 25*[dict[@"data"][@"costperformancescore"] intValue], 20) numberOfStar:[dict[@"data"][@"costperformancescore"] intValue]];
    [BackVeiw_star addSubview:lbl_xingjiabi];
    [BackVeiw_star addSubview:starRatingView_xingjiabi];
    [page addSubview:BackVeiw_star];
    UILabel * lbl_baguobangContent=[[UILabel alloc] initWithFrame:CGRectMake(10, BackVeiw_star.frame.origin.y+BackVeiw_star.frame.size.height+5, SCREEN_WIDTH, 200)];
    [lbl_baguobangContent setLineBreakMode:NSLineBreakByWordWrapping];
    lbl_baguobangContent.numberOfLines=0;
    lbl_baguobangContent.text=dict[@"data"][@"content"];
    [page addSubview:lbl_baguobangContent];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
