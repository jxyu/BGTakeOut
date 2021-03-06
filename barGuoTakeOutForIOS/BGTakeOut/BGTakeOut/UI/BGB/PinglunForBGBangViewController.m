//
//  PinglunForBGBangViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/18.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "PinglunForBGBangViewController.h"
#import "AppDelegate.h"
#import "CommenDef.h"
#import "DataProvider.h"
#import "AMRatingControl.h"


@interface PinglunForBGBangViewController ()
@end

@implementation PinglunForBGBangViewController
{
    AMRatingControl *starRatingView_weidao;
    AMRatingControl *starRatingView_weisheng;
    AMRatingControl *starRatingView_huanjing;
    AMRatingControl *starRatingView_fuwu;
    AMRatingControl *starRatingView_xingjiabi;
    CWStarRateView * weidao;
    CWStarRateView * weisheng;
    CWStarRateView * huanjing;
    CWStarRateView * fuwu;
    CWStarRateView * xingjiabi;
    
    NSString * numOfWeiDao;
    NSString * numOfweisheng;
    NSString * numOfHuanJing;
    NSString * numOfFuWu;
    NSString * numOfXingjiabi;
    
    UITextView * txtV_PingjiaContent;
    UILabel *uilabelcontent;
    UILabel *lbl_zishucontent;
    UIButton * btn_Submit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    numOfWeiDao=@"1";
    numOfweisheng=@"1";
    numOfHuanJing=@"1";
    numOfFuWu=@"1";
    numOfXingjiabi=@"1";
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self setBarTitle:@"评论"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self addRightbuttontitle:@"取消"];
    UIScrollView * scrollview_pingjia=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    // Do any additional setup after loading the view.
    UIView * BackVeiw_star=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 170)];
    BackVeiw_star.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_weidao=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    lbl_weidao.text=@"味道";
    starRatingView_weidao =[[AMRatingControl alloc] initWithLocation:CGPointMake(80, 8)
                                                          emptyColor:[UIColor lightGrayColor]
                                                          solidColor:[UIColor redColor]
                                                        andMaxRating:10];
    starRatingView_weidao.rating=1;
    [starRatingView_weidao setUserInteractionEnabled:YES];
    starRatingView_weidao.backgroundColor=[UIColor clearColor];
    [starRatingView_weidao addTarget:self action:@selector(GetScoreForPingjia:) forControlEvents:UIControlEventEditingDidEnd];
    starRatingView_weidao.tag=1;
    [BackVeiw_star addSubview:lbl_weidao];
    [BackVeiw_star addSubview:starRatingView_weidao];
    
    UILabel * lbl_weisheng=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_weidao.frame.origin.y+lbl_weidao.frame.size.height+10, 60, 20)];
    lbl_weisheng.text=@"卫生";
    starRatingView_weisheng =[[AMRatingControl alloc] initWithLocation:CGPointMake(80, lbl_weidao.frame.origin.y+lbl_weidao.frame.size.height+8)
                                                            emptyColor:[UIColor lightGrayColor]
                                                            solidColor:[UIColor redColor]
                                                          andMaxRating:10];
    starRatingView_weisheng.rating=1;
    [starRatingView_weisheng setUserInteractionEnabled:YES];
    starRatingView_weisheng.backgroundColor=[UIColor clearColor];
    [starRatingView_weisheng addTarget:self action:@selector(GetScoreForPingjia:) forControlEvents:UIControlEventEditingDidEnd];

    starRatingView_weisheng.tag=2;
    [BackVeiw_star addSubview:lbl_weisheng];
    [BackVeiw_star addSubview:starRatingView_weisheng];
    
    UILabel * lbl_huanjing=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_weisheng.frame.origin.y+lbl_weisheng.frame.size.height+10, 60, 20)];
    lbl_huanjing.text=@"环境";
    starRatingView_huanjing=[[AMRatingControl alloc] initWithLocation:CGPointMake(80, lbl_weisheng.frame.origin.y+lbl_weisheng.frame.size.height+8)
                                                           emptyColor:[UIColor lightGrayColor]
                                                           solidColor:[UIColor redColor]
                                                         andMaxRating:10];
    starRatingView_huanjing.rating=1;
    [starRatingView_huanjing setUserInteractionEnabled:YES];
    starRatingView_huanjing.backgroundColor=[UIColor clearColor];
    [starRatingView_huanjing addTarget:self action:@selector(GetScoreForPingjia:) forControlEvents:UIControlEventEditingDidEnd];
    starRatingView_huanjing.tag=3;
    [BackVeiw_star addSubview:lbl_huanjing];
    [BackVeiw_star addSubview:starRatingView_huanjing];
    
    UILabel * lbl_fuwu=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_huanjing.frame.origin.y+lbl_huanjing.frame.size.height+10, 60, 20)];
    lbl_fuwu.text=@"服务";
    starRatingView_fuwu =[[AMRatingControl alloc] initWithLocation:CGPointMake(80, lbl_huanjing.frame.origin.y+lbl_huanjing.frame.size.height+8)
                                                        emptyColor:[UIColor lightGrayColor]
                                                        solidColor:[UIColor redColor]
                                                      andMaxRating:10];
    starRatingView_fuwu.rating=1;
    [starRatingView_fuwu setUserInteractionEnabled:YES];
    starRatingView_fuwu.backgroundColor=[UIColor clearColor];
    [starRatingView_fuwu addTarget:self action:@selector(GetScoreForPingjia:) forControlEvents:UIControlEventEditingDidEnd];
    starRatingView_fuwu.tag=4;
    [BackVeiw_star addSubview:lbl_fuwu];
    [BackVeiw_star addSubview:starRatingView_fuwu];
    
    UILabel * lbl_xingjiabi=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_fuwu.frame.origin.y+lbl_fuwu.frame.size.height+10, 60, 20)];
    lbl_xingjiabi.text=@"性价比";
    starRatingView_xingjiabi =[[AMRatingControl alloc] initWithLocation:CGPointMake(80, lbl_fuwu.frame.origin.y+lbl_fuwu.frame.size.height+8)
                                                             emptyColor:[UIColor lightGrayColor]
                                                             solidColor:[UIColor redColor]
                                                           andMaxRating:10];
    starRatingView_xingjiabi.rating=1;
    [starRatingView_xingjiabi setUserInteractionEnabled:YES];
    starRatingView_xingjiabi.backgroundColor=[UIColor clearColor];
    [starRatingView_xingjiabi addTarget:self action:@selector(GetScoreForPingjia:) forControlEvents:UIControlEventEditingDidEnd];
    starRatingView_xingjiabi.tag=5;
    [BackVeiw_star addSubview:lbl_xingjiabi];
    [BackVeiw_star addSubview:starRatingView_xingjiabi];
    [scrollview_pingjia addSubview:BackVeiw_star];
    UIView * BackView_content=[[UIView alloc] initWithFrame:CGRectMake(0, BackVeiw_star.frame.origin.y+BackVeiw_star.frame.size.height+20, SCREEN_WIDTH, 80)];
    BackView_content.backgroundColor=[UIColor whiteColor];
    txtV_PingjiaContent=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [txtV_PingjiaContent setKeyboardType:UIKeyboardTypeDefault];
    txtV_PingjiaContent.delegate=self;
    [BackView_content addSubview:txtV_PingjiaContent];
    
    uilabelcontent=[[UILabel alloc] initWithFrame:CGRectMake(17, 10, 300, 15)];
    uilabelcontent.font=[UIFont systemFontOfSize:14];
    uilabelcontent.text = @"写点评价吧，对其他小伙伴帮助很大哦";
    uilabelcontent.enabled = NO;//lable必须设置为不可用
    uilabelcontent.backgroundColor = [UIColor clearColor];
    [BackView_content addSubview:uilabelcontent];
    lbl_zishucontent=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160,BackView_content.frame.size.height-30, 150, 15)];
    lbl_zishucontent.text=@"还能输入140个字";
    lbl_zishucontent.font=[UIFont systemFontOfSize:14];
    lbl_zishucontent.enabled=NO;
    lbl_zishucontent.backgroundColor=[UIColor clearColor];
    [BackView_content addSubview:lbl_zishucontent];
    [scrollview_pingjia addSubview:BackView_content];
    
    btn_Submit=[[UIButton alloc] initWithFrame:CGRectMake(40, BackView_content.frame.origin.y+BackView_content.frame.size.height+20, SCREEN_WIDTH-80, 30)];
    [btn_Submit setTitle:@"提交" forState:UIControlStateNormal];
    [btn_Submit setBackgroundColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0]];
    btn_Submit.layer.masksToBounds=YES;
    btn_Submit.layer.cornerRadius=3;
    [btn_Submit addTarget:self action:@selector(SubmitFunction) forControlEvents:UIControlEventTouchUpInside];
    [scrollview_pingjia addSubview:btn_Submit];
    scrollview_pingjia.contentSize=CGSizeMake(0, SCREEN_HEIGHT+200);
    [self.view addSubview:scrollview_pingjia];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)textViewDidChange:(UITextView *)textView
{
    [btn_Submit setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];
    int textlength=textView.text.length ;
    if (textlength== 0) {
        uilabelcontent.text = @"写点评价吧，对其他小伙伴帮助很大哦";
    }else{
        uilabelcontent.text = @"";
        lbl_zishucontent.text=[NSString stringWithFormat:@"还能输入%d个字",140-textlength];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)SubmitFunction
{
    [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeBlack];
    NSDictionary * prm =@{@"articleid":_articleid,@"userid":_userid,@"content":txtV_PingjiaContent.text,@"tastescore":numOfWeiDao,@"hygienismscore":numOfweisheng,@"environmentscore":numOfHuanJing,@"servicescore":numOfFuWu,@"costperformancescore":numOfXingjiabi};
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"submitBackCall:"];
    [dataprovider SubmitBGBangPingjia:prm];
}

-(void)submitBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if ([dict[@"status"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)clickRightButton:(UIButton *)sender
{
    [txtV_PingjiaContent resignFirstResponder];
}

-(void)GetScoreForPingjia:(AMRatingControl *)sender
{
    [btn_Submit setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];
    switch (sender.tag) {
        case 1:
            numOfWeiDao=[NSString stringWithFormat:@"%ld",(long)sender.rating];
            break;
        case 2:
            numOfweisheng=[NSString stringWithFormat:@"%ld",(long)sender.rating];
            break;
        case 3:
            numOfHuanJing=[NSString stringWithFormat:@"%ld",(long)sender.rating];
            break;
        case 4:
            numOfFuWu=[NSString stringWithFormat:@"%ld",(long)sender.rating];
            break;
        case 5:
            numOfXingjiabi=[NSString stringWithFormat:@"%ld",(long)sender.rating];
            break;
        default:
            break;
    }
}

- (void)starRateView:(CWStarRateView *)starRateView scroePercentDidChange:(CGFloat)newScorePercent
{
    [btn_Submit setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];
    int scroe=(int)(newScorePercent*10);
    switch (starRateView.tag) {
        case 0:
            numOfWeiDao=[NSString stringWithFormat:@"%d",scroe];
            break;
        case 1:
            numOfweisheng=[NSString stringWithFormat:@"%d",scroe];
            break;
        case 2:
            numOfHuanJing=[NSString stringWithFormat:@"%d",scroe];
            break;
        case 3:
            numOfFuWu=[NSString stringWithFormat:@"%d",scroe];
            break;
        case 4:
            numOfXingjiabi=[NSString stringWithFormat:@"%d",scroe];
            break;
        default:
            break;
    }
}

@end
