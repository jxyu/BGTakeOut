//
//  OrderInfoViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/13.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "ShoppingCarModel.h"
#import "DataProvider.h"
#import "CantingInfoViewController.h"
#import "Pingpp.h"
#import "OtherOfMineViewController.h"


@interface OrderInfoViewController ()
@property(nonatomic,strong)RefreshHeaderAndFooterView * refreshHeaderAndFooterView;
@property(nonatomic,assign)BOOL reloading;
@end

@implementation OrderInfoViewController
{
    UIScrollView *scrollView_AfterPay;
    UIView * OrderAfterPay;
    NSDictionary *OrderInfo;
}
@synthesize refreshHeaderAndFooterView = _refreshHeaderAndFooterView;
@synthesize reloading = _reloading;


- (void)viewDidLoad {
    
    // Do any additional setup after loading the view.
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    scrollView_AfterPay=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView_AfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    scrollView_AfterPay.scrollEnabled=YES;
    scrollView_AfterPay.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(RefReshView) name:@"Res_Resive_order" object:nil];
    OrderAfterPay =[[UIView alloc] init];
    OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    RefreshHeaderAndFooterView *view= [[RefreshHeaderAndFooterView alloc] initWithFrame:CGRectMake(scrollView_AfterPay.frame.origin.x, scrollView_AfterPay.frame.origin.y-20, scrollView_AfterPay.frame.size.width, scrollView_AfterPay.contentSize.height)];
    view.delegate = self;
    [scrollView_AfterPay addSubview:view];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderInfoBackCall:"];
    [dataprovider GetOrderInfoWithOrderNum:_orderInfoDetial[@"ordernum"]];
    self.refreshHeaderAndFooterView=view;
    
    [self.view addSubview:scrollView_AfterPay];
    [super viewDidLoad];
    [self setBarTitle:@"订单详情"];
    [self addLeftButton:@"ic_actionbar_back.png"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
-(void)GetOrderInfoBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"获取订单信息%@",dict);
    if (1==[dict[@"status"] intValue]) {
        NSData * data=[dict[@"data"][@"goodsdetail"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
        _orderData=(NSArray *)jsonObject;
        OrderInfo=dict[@"data"];
        [self PayForOrder:dict[@"data"]];
    }
}

-(void)PayForOrder:(NSDictionary *)dict
{
    UIView * BackView_OrderTitle=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
    BackView_OrderTitle.backgroundColor=[UIColor whiteColor];
    UIImageView * img_Status_icon=[[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 20, 20)];
    UILabel * lbl_Status=[[UILabel alloc] initWithFrame:CGRectMake(img_Status_icon.frame.origin.x+img_Status_icon.frame.size.width, 20, 200, 20)];
    NSString *imagename;
    UILabel * lbl_tishi=[[UILabel alloc] initWithFrame:CGRectMake(lbl_Status.frame.origin.x, img_Status_icon.frame.size.height+img_Status_icon.frame.origin.y+5, 125, 20)];
    lbl_tishi.textColor=[UIColor blueColor];
    lbl_tishi.text=@"请刷新查看最新动态";
    lbl_tishi.font=[UIFont systemFontOfSize:13];
    UILabel * lbl_timetitle=[[UILabel alloc] initWithFrame:CGRectMake(lbl_tishi.frame.origin.x+lbl_tishi.frame.size.width, img_Status_icon.frame.size.height+img_Status_icon.frame.origin.y+5, 60, 20)];
    lbl_timetitle.text=@"预计接单:";
    lbl_timetitle.font=[UIFont systemFontOfSize:13];
    lbl_timetitle.textColor=[UIColor grayColor];
    
    UILabel * lbl_proTime=[[UILabel alloc] initWithFrame:CGRectMake(lbl_timetitle.frame.origin.x+lbl_timetitle.frame.size.width, img_Status_icon.frame.size.height+img_Status_icon.frame.origin.y+5, 100, 20)];
    NSString *str_time=[self GetResiveOrderTime:dict[@"updatetime"]];
    lbl_proTime.text=[NSString stringWithFormat:@"%@",str_time];
    lbl_proTime.font=[UIFont systemFontOfSize:13];
    lbl_proTime.textColor=[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0];
    
//    [dict[@"status"] intValue]
    switch ([dict[@"status"] intValue]) {
        case 1:
            imagename=@"paysure.png";
            lbl_Status.text=@"付款成功，等待店家接单";
            [BackView_OrderTitle addSubview:lbl_tishi];
            [BackView_OrderTitle addSubview:lbl_timetitle];
            [BackView_OrderTitle addSubview:lbl_proTime];
            break;
        case 2:
            imagename=@"timer.png";
            lbl_Status.text=@"餐厅已接单，美食制作中";
            break;
        case 3:
            imagename=@"paysure.png";
            lbl_Status.text=@"订单完成";
            break;
        case 4:
            imagename=@"timer.png";
            lbl_Status.text=@"美食正在配送中...";
            break;
        case 5:
            imagename=@"timer.png";
            lbl_Status.text=@"未付款，待付款";
            break;
        case 7:
            imagename=@"no_icon.png";
            lbl_Status.text=@"订单取消";
            break;
        case 8:
            imagename=@"no_icon.png";
            lbl_Status.text=@"订单取消，等待退款";
            break;
        case 9:
            imagename=@"no_icon.png";
            lbl_Status.text=@"退款成功，交易关闭";
            break;
        case 10:
            imagename=@"no_icon.png";
            lbl_Status.text=@"订单取消";
            break;
        case 11:
            imagename=@"no_icon.png";
            lbl_Status.text=@"退款中";
            break;
        case 12:
            imagename=@"paysure.png";
            lbl_Status.text=@"评价完成";
            break;
        default:
            break;
    }
    img_Status_icon.image=[UIImage imageNamed:imagename];
    [BackView_OrderTitle addSubview:img_Status_icon];
    [BackView_OrderTitle addSubview:lbl_Status];
    
    
    
    
    
    //[dict[@"status"] intValue]
    switch ([dict[@"status"] intValue]) {
        case 1://已支付，等待接单
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, BackView_OrderTitle.frame.size.width, BackView_OrderTitle.frame.size.height-50);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, lbl_proTime.frame.origin.y+lbl_proTime.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, backview_StatusInfo.frame.size.width-20, 40)];
            //            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"刷新查看商家是否接单";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor colorWithRed:255/255.0 green:80/255.0 blue:43/255.0 alpha:1.0];
            [backview_StatusInfo addSubview:lbl_title];
//            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:244/255.0 green:243/255.0 blue:241/255.0 alpha:1.0];
//            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, (SCREEN_WIDTH-80)/2, 20)];
//            [lbl_title setTextAlignment:NSTextAlignmentCenter];
//            lbl_title.text=@"已等待";
//            [backview_StatusInfo addSubview:lbl_title];
//            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(lbl_title.frame.origin.x+lbl_title.frame.size.width, 10, 1, 20)];
//            fenge.backgroundColor=[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
//            [backview_StatusInfo addSubview:fenge];
//            UILabel * lbl_TimeCount=[[UILabel alloc] initWithFrame:CGRectMake(fenge.frame.origin.x+fenge.frame.size.width, 10,(SCREEN_WIDTH-80)/2 , 20)];
//            [lbl_TimeCount setTextAlignment:NSTextAlignmentCenter];
//            lbl_TimeCount.textColor=[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0];
//            lbl_TimeCount.text=[NSString stringWithFormat:@"预计10分钟内接单"];
//            MZTimerLabel *timer = [[MZTimerLabel alloc] initWithLabel:lbl_TimeCount andTimerType:MZTimerLabelTypeTimer];
//            [timer setCountDownTime:600];
//            [timer start];
//            timer.delegate=self;
//            [backview_StatusInfo addSubview:lbl_TimeCount];
//            fenge.backgroundColor=[UIColor colorWithRed:221/255.0 green:220/255.0 blue:218/255.0 alpha:1.0];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            UIButton * btn_canselOrder=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60-40, BackView_OrderTitle.frame.size.height-38, 60, 30)];
            btn_canselOrder.layer.masksToBounds=YES;
            btn_canselOrder.layer.cornerRadius=6;
            btn_canselOrder.layer.borderWidth=1;
            [btn_canselOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            btn_canselOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            btn_canselOrder.tag=[dict[@"status"] intValue];
            [btn_canselOrder setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn_canselOrder addTarget:self action:@selector(CancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_canselOrder];
            UIButton * btn_cuidan=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_cuidan setTitle:@"电话催单" forState:UIControlStateNormal];
            [btn_cuidan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_cuidan.layer.borderWidth=1.0;
            btn_cuidan.layer.cornerRadius=5;
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_cuidan addTarget:self action:@selector(CuidanForTel) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_cuidan];
            
            
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            lbl_Image_First.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 2:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, BackView_OrderTitle.frame.size.width, BackView_OrderTitle.frame.size.height-70);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, backview_StatusInfo.frame.size.width-20, 40)];
//            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"建议提前下单，错过订餐高峰。\n用餐时间可给卖家留言呦";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor colorWithRed:255/255.0 green:80/255.0 blue:43/255.0 alpha:1.0];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [cansalOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            [cansalOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.cornerRadius=5;
            cansalOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            [cansalOrder addTarget:self action:@selector(CancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            UIButton * btn_cuidan=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_cuidan setTitle:@"电话催单" forState:UIControlStateNormal];
            [btn_cuidan setTitleColor:[UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
            btn_cuidan.layer.borderWidth=1.0;
            btn_cuidan.layer.cornerRadius=5;
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
            [btn_cuidan.layer setBorderColor:colorref];
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_cuidan addTarget:self action:@selector(CuidanForTel) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_cuidan];
//            UIButton * btn_ReciveGood=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
//            [btn_ReciveGood setTitle:@"确认收货" forState:UIControlStateNormal];
//            [btn_ReciveGood setTitleColor:[UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
//            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
//            btn_ReciveGood.layer.borderWidth=1.0;
//            btn_ReciveGood.layer.cornerRadius=5;
//            btn_ReciveGood.titleLabel.font=[UIFont systemFontOfSize:13];
//            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
//            [btn_ReciveGood.layer setBorderColor:colorref];
//            [btn_ReciveGood addTarget:self action:@selector(OrderReciver) forControlEvents:UIControlEventTouchUpInside];
//            [BackView_OrderTitle addSubview:btn_ReciveGood];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 3:
        {
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+10, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"感谢您使用掌上街，欢迎再次订餐";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            UIButton * btn_tousu=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_tousu setTitle:@"订单投诉" forState:UIControlStateNormal];
            [btn_tousu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_tousu.layer.masksToBounds=YES;
            btn_tousu.layer.borderWidth=1.0;
            btn_tousu.layer.cornerRadius=5;
            btn_tousu.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_tousu setTitleColor:[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0] forState:UIControlStateNormal];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
            [btn_tousu.layer setBorderColor:colorref];
            [btn_tousu addTarget:self action:@selector(btn_tousuclick:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_tousu];
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(btn_tousu.frame.origin.x-10-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [cansalOrder setTitle:@"评价" forState:UIControlStateNormal];
            [cansalOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cansalOrder.layer.masksToBounds=YES;
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.cornerRadius=5;
            cansalOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            [cansalOrder setTitleColor:[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cansalOrder.layer setBorderColor:colorref];
            [cansalOrder addTarget:self action:@selector(dingdanTousu) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y-30, SCREEN_WIDTH, BackView_OrderTitle.frame.size.height-60);
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 4:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, BackView_OrderTitle.frame.size.width, BackView_OrderTitle.frame.size.height-10);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"皇帝般的享受，坐享美食";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor colorWithRed:255/255.0 green:80/255.0 blue:43/255.0 alpha:1.0];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            UILabel * lbl_title1=[[UILabel alloc] initWithFrame:CGRectMake(backview_StatusInfo.frame.origin.x, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+ 10, backview_StatusInfo.frame.size.width, 60)];
//            [lbl_title1 setTextAlignment:NSTextAlignmentCenter];
            lbl_title1.font=[UIFont systemFontOfSize:12];
//            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"提示：系统将在24小时后自动确认收货，如果您还没收到美食，请及时联系卖家，如需第三方调解，请联系掌尚街客服."];
//            [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(6,17)];
            lbl_title1.text=@"提示：系统将在24小时后自动确认收货，如果您还没收到美食，请及时联系卖家，如需第三方调解，请联系掌尚街客服.";
            [lbl_title1 setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title1.numberOfLines=0;
            [BackView_OrderTitle addSubview:lbl_title1];
            
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-60, lbl_title1.frame.origin.y+lbl_title1.frame.size.height+5, 60, 30)];
            [cansalOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            [cansalOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.cornerRadius=5;
            cansalOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            [cansalOrder addTarget:self action:@selector(CancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            UIButton * btn_cuidan=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, lbl_title1.frame.origin.y+lbl_title1.frame.size.height+5, 60, 30)];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
            [btn_cuidan setTitle:@"电话催单" forState:UIControlStateNormal];
            [btn_cuidan setTitleColor:[UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
            [btn_cuidan.layer setBorderColor:colorref];
            btn_cuidan.layer.borderWidth=1.0;
            btn_cuidan.layer.cornerRadius=5;
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_cuidan addTarget:self action:@selector(CuidanForTel) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_cuidan];
            UIButton * btn_ReciveGood=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-240, lbl_title1.frame.origin.y+lbl_title1.frame.size.height+5, 60, 30)];
            [btn_ReciveGood setTitle:@"确认收货" forState:UIControlStateNormal];
            [btn_ReciveGood setTitleColor:[UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            btn_ReciveGood.layer.borderWidth=1.0;
            btn_ReciveGood.layer.cornerRadius=5;
            btn_ReciveGood.titleLabel.font=[UIFont systemFontOfSize:13];
            
            [btn_ReciveGood.layer setBorderColor:colorref];
            //    btn_ReciveGood.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0]);
            [btn_ReciveGood addTarget:self action:@selector(OrderReciver) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_ReciveGood];
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 5://未支付
        {
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:244/255.0 green:243/255.0 blue:241/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, (SCREEN_WIDTH-80)/2, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.text=@"未付款";
            [backview_StatusInfo addSubview:lbl_title];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(lbl_title.frame.origin.x+lbl_title.frame.size.width, 10, 1, 20)];
            fenge.backgroundColor=[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
            [backview_StatusInfo addSubview:fenge];
            //    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:nil userInfo:nil repeats:YES];
            //    [timer setFireDate:[NSDate distantPast]];//开启
            UILabel * lbl_TimeCount=[[UILabel alloc] initWithFrame:CGRectMake(fenge.frame.origin.x+fenge.frame.size.width, 10,(SCREEN_WIDTH-80)/2 , 20)];
            [lbl_TimeCount setTextAlignment:NSTextAlignmentCenter];
            lbl_TimeCount.text=[NSString stringWithFormat:@"请付款"];
            [backview_StatusInfo addSubview:lbl_TimeCount];
            fenge.backgroundColor=[UIColor colorWithRed:221/255.0 green:220/255.0 blue:218/255.0 alpha:1.0];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [cansalOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            [cansalOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.cornerRadius=5;
            cansalOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            cansalOrder.tag=[dict[@"status"] intValue];
            [cansalOrder addTarget:self action:@selector(CancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            UIButton * btn_cuidan=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-170, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_cuidan setTitle:@"付款" forState:UIControlStateNormal];
            [btn_cuidan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_cuidan.layer.borderWidth=1.0;
            btn_cuidan.layer.cornerRadius=5;
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_cuidan addTarget:self action:@selector(PayWithThisOrder:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_cuidan];
            
            
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            //                lbl_Image_First.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 7:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, SCREEN_WIDTH, 100);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, backview_StatusInfo.frame.size.width, 40)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"商家较忙或其他原因未接单，\n如已付款系统将自动返还";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake(85, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            lbl_Image_First.textColor=[UIColor grayColor];
            [BackView_img_status addSubview:lbl_Image_First];
            
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"no_icon.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"订单取消";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            lbl_Image_Third.textColor=[UIColor grayColor];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 8:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, SCREEN_WIDTH, 100);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, backview_StatusInfo.frame.size.width, 40)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"商家较忙或其他原因未接单，\n如已付款系统将自动返还";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake(85, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            [BackView_img_status addSubview:lbl_Image_First];
            
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"no_icon.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"订单取消";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 9:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, SCREEN_WIDTH, 100);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"退款成功，交易关闭，欢迎下次光临";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake(85, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            [BackView_img_status addSubview:lbl_Image_First];
            
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"no_icon.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"订单取消";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 10:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, BackView_OrderTitle.frame.size.width, BackView_OrderTitle.frame.size.height-70);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 0, backview_StatusInfo.frame.size.width-20, 40)];
            //            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"感谢您对掌尚街的支持\n欢迎提出宝贵意见，我们会继承为您服务";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor colorWithRed:255/255.0 green:80/255.0 blue:43/255.0 alpha:1.0];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            UIButton * btn_tousu=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_tousu setTitle:@"订单投诉" forState:UIControlStateNormal];
            [btn_tousu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_tousu.layer.masksToBounds=YES;
            btn_tousu.layer.borderWidth=1.0;
            btn_tousu.layer.cornerRadius=5;
            btn_tousu.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_tousu setTitleColor:[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0] forState:UIControlStateNormal];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
            [btn_tousu.layer setBorderColor:colorref];
            [btn_tousu addTarget:self action:@selector(btn_tousuclick:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_tousu];
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(btn_tousu.frame.origin.x-10-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [cansalOrder setTitle:@"评价" forState:UIControlStateNormal];
            [cansalOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cansalOrder.layer.masksToBounds=YES;
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.cornerRadius=5;
            cansalOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            [cansalOrder setTitleColor:[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0] forState:UIControlStateNormal];
            [cansalOrder.layer setBorderColor:colorref];
            [cansalOrder addTarget:self action:@selector(dingdanTousu) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            //            UIButton * btn_ReciveGood=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-210, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            //            [btn_ReciveGood setTitle:@"确认收货" forState:UIControlStateNormal];
            //            [btn_ReciveGood setTitleColor:[UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
            //            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            //            btn_ReciveGood.layer.borderWidth=1.0;
            //            btn_ReciveGood.layer.cornerRadius=5;
            //            btn_ReciveGood.titleLabel.font=[UIFont systemFontOfSize:13];
            //            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            //            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
            //            [btn_ReciveGood.layer setBorderColor:colorref];
            //            [btn_ReciveGood addTarget:self action:@selector(OrderReciver) forControlEvents:UIControlEventTouchUpInside];
            //            [BackView_OrderTitle addSubview:btn_ReciveGood];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-210)/4+5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-120)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-210)/4*2+lbl_Image_First.frame.size.width+5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (SCREEN_WIDTH-120)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"no_icon.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-210)/4*3+lbl_Image_First.frame.size.width*2+5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"订单取消";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 11:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, SCREEN_WIDTH, 100);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"您的订单已经取消，正在为您退款";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake(85, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"正在进行退款";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            [BackView_img_status addSubview:lbl_Image_First];
            
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"no_icon.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"订单取消";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 12:
        {
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+10, SCREEN_WIDTH-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"感谢您使用掌上街，欢迎再次订餐";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            UIButton * btn_tousu=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_tousu setTitle:@"订单投诉" forState:UIControlStateNormal];
            [btn_tousu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_tousu.layer.masksToBounds=YES;
            btn_tousu.layer.borderWidth=1.0;
            btn_tousu.layer.cornerRadius=5;
            btn_tousu.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_tousu setTitleColor:[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0] forState:UIControlStateNormal];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
            [btn_tousu.layer setBorderColor:colorref];
            [btn_tousu addTarget:self action:@selector(btn_tousuclick:) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_tousu];
            
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y-30, SCREEN_WIDTH, BackView_OrderTitle.frame.size.height-60);
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, SCREEN_WIDTH, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:13];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (SCREEN_WIDTH-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 15)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:13];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        default:
            break;
    }
    
    
    
    
    

    UIView * lastView=[OrderAfterPay.subviews lastObject];
    UIView * BackView_OrderListTitle=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, SCREEN_WIDTH, 40)];
    BackView_OrderListTitle.backgroundColor=[UIColor whiteColor];
    UIImageView * Img_orderListTitle=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    Img_orderListTitle.image=[UIImage imageNamed:@"res_pic"];
    [BackView_OrderListTitle addSubview:Img_orderListTitle];
    UILabel * lbl_CantingTitle=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, 150, 20)];
    if (dict[@"resname"]!=[NSNull null]) {
        lbl_CantingTitle.text=dict[@"resname"];
    }
    else
    {
        lbl_CantingTitle.text=@"";
    }
    [BackView_OrderListTitle addSubview:lbl_CantingTitle];
    UIImageView * goImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-20, (BackView_OrderListTitle.frame.size.height-15)/2, 11, 15)];
    goImage.image=[UIImage imageNamed:@"go.png"];
    [BackView_OrderListTitle addSubview:goImage];
    [OrderAfterPay addSubview:BackView_OrderListTitle];
    
    
    float sumprice=0;
    if (_orderData.count>0) {
        for (int i=0; i<_orderData.count; i++) {
            lastView=[OrderAfterPay.subviews lastObject];
            UIView *orderBackground=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, SCREEN_WIDTH,30)];
            lastView=[self.view.subviews lastObject];
            orderBackground.backgroundColor=[UIColor whiteColor];
            UILabel *itemName=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 180, 20)];
            itemName.text=_orderData[i][@"goodsname"];
            itemName.textColor=[UIColor grayColor];
            [orderBackground addSubview:itemName];
            UILabel * itemnum=[[UILabel alloc] initWithFrame:CGRectMake(itemName.frame.origin.x+itemName.frame.size.width, 5, 60, 20)];
            itemnum.text=[NSString stringWithFormat:@"x%@",_orderData[i][@"count"]];
            itemnum.textColor=[UIColor grayColor];
            [orderBackground addSubview:itemnum];
            UILabel * itemprice=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 5, 80, 20)];
            itemprice.text=[NSString stringWithFormat:@"¥%.2f",[_orderData[i][@"count"] intValue]*[_orderData[i][@"price"] floatValue]];
            itemprice.textAlignment=NSTextAlignmentRight;
            itemprice.textColor=[UIColor grayColor];
            [orderBackground addSubview:itemprice];
            [OrderAfterPay addSubview:orderBackground];
            sumprice+=[_orderData[i][@"count"] intValue]*[_orderData[i][@"price"] floatValue];
        }
        sumprice+=[OrderInfo[@"deliveryprice"] floatValue];
    }
    
    lastView=[OrderAfterPay.subviews lastObject];
    UIView * peisongfei=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH, 40)];
    peisongfei.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_sunTitle1=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    lbl_sunTitle1.text=@"配送费";
    [peisongfei addSubview:lbl_sunTitle1];
    UILabel * lbl_sumPrice1=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, 80, 20)];
    lbl_sumPrice1.textAlignment=NSTextAlignmentRight;
    lbl_sumPrice1.text=[NSString stringWithFormat:@"¥%.2f",[OrderInfo[@"deliveryprice"] floatValue]];
    [peisongfei addSubview:lbl_sumPrice1];
    [OrderAfterPay addSubview:peisongfei];

    
    
    
    
    
    lastView=[OrderAfterPay.subviews lastObject];
    UIView * BackView_SumPrice=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH, 40)];
    BackView_SumPrice.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_sunTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    lbl_sunTitle.text=@"合计：";
    [BackView_SumPrice addSubview:lbl_sunTitle];
    UILabel * lbl_sumPrice=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, 80, 20)];
    lbl_sumPrice.text=[NSString stringWithFormat:@"¥%.2f",sumprice];
    lbl_sumPrice.textAlignment=NSTextAlignmentRight;
    [BackView_SumPrice addSubview:lbl_sumPrice];
    [OrderAfterPay addSubview:BackView_SumPrice];
    if ([dict[@"status"] intValue]!=1) {
        UIView * BackView_AgainOrder=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_SumPrice.frame.origin.y+BackView_SumPrice.frame.size.height+1, SCREEN_WIDTH, 50)];
        BackView_AgainOrder.backgroundColor=[UIColor whiteColor];
        UIButton * btn_OtherOrder=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100-20, 10, 100, 30)];
        btn_OtherOrder.layer.masksToBounds=YES;
        btn_OtherOrder.layer.cornerRadius=6;
        btn_OtherOrder.layer.borderWidth=1;
        btn_OtherOrder.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0]);
        [btn_OtherOrder setTitle:@"再来一单" forState:UIControlStateNormal];
        [btn_OtherOrder setTitleColor:[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0] forState:UIControlStateNormal];
        [btn_OtherOrder addTarget:self action:@selector(TryAnotherOrder) forControlEvents:UIControlEventTouchUpInside];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
        [btn_OtherOrder.layer setBorderColor:colorref];
        [BackView_AgainOrder addSubview:btn_OtherOrder];
        [OrderAfterPay addSubview:BackView_AgainOrder];
    }
    lastView=[OrderAfterPay.subviews lastObject];
    
    UIView * BackVeiw_OrderInfo=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH, 180)];
    BackVeiw_OrderInfo.backgroundColor=[UIColor whiteColor];
    UIImageView * Img_OrderInfo=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    Img_OrderInfo.image=[UIImage imageNamed:@"res_info"];
    [BackVeiw_OrderInfo addSubview:Img_OrderInfo];
    UILabel * lbl_OrderInfoTitle=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, 150, 20)];
    lbl_OrderInfoTitle.text=@"订单详情";
    [BackVeiw_OrderInfo addSubview:lbl_OrderInfoTitle];
    UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(10, lbl_OrderInfoTitle.frame.origin.y+lbl_OrderInfoTitle.frame.size.height+2, SCREEN_WIDTH-20, 1)];
    fenge1.backgroundColor=[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
    [BackVeiw_OrderInfo addSubview:fenge1];
    UILabel * lbl_dingdanNum=[[UILabel alloc] initWithFrame:CGRectMake(10, fenge1.frame.origin.y+fenge1.frame.size.height+8, SCREEN_WIDTH, 20)];
    lbl_dingdanNum.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_dingdanNum.text=[NSString stringWithFormat:@"订单号码：%@",dict[@"ordernum"]];
    lbl_dingdanNum.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanNum];
    UILabel * lbl_dingdanTime=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_dingdanNum.frame.origin.y+lbl_dingdanNum.frame.size.height+8, SCREEN_WIDTH, 20)];
    lbl_dingdanTime.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_dingdanTime.text=[NSString stringWithFormat:@"订单时间：%@",dict[@"updatetime"]];
    lbl_dingdanTime.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanTime];
    UILabel * lbl_dingdanPayWay=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_dingdanTime.frame.origin.y+lbl_dingdanTime.frame.size.height+8, SCREEN_WIDTH, 20)];
    lbl_dingdanPayWay.font=[UIFont fontWithName:@"Helvetica" size:15];
    BOOL val=[dict[@"payway"] boolValue];
    lbl_dingdanPayWay.text=[NSString stringWithFormat:@"支付方式：%@",val?@"货到付款":@"在线支付"];
    lbl_dingdanPayWay.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanPayWay];
    UILabel * lbl_dingdanPhoneNum=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_dingdanPayWay.frame.origin.y+lbl_dingdanPayWay.frame.size.height+8, SCREEN_WIDTH, 20)];
    lbl_dingdanPhoneNum.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_dingdanPhoneNum.text=[NSString stringWithFormat:@"手机号码：%@",dict[@"phonenum"]];
    lbl_dingdanPhoneNum.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanPhoneNum];
    UILabel * lbl_dingdanAddress=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_dingdanPhoneNum.frame.origin.y+lbl_dingdanPhoneNum.frame.size.height+8, SCREEN_WIDTH, 20)];
    lbl_dingdanAddress.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_dingdanAddress.text=[NSString stringWithFormat:@"收餐地址：%@",dict[@"address"]];
    lbl_dingdanAddress.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanAddress];
    [OrderAfterPay addSubview:BackVeiw_OrderInfo];
    OrderAfterPay.frame=CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, BackVeiw_OrderInfo.frame.origin.y+BackVeiw_OrderInfo.frame.size.height+49);
    [scrollView_AfterPay setContentSize:CGSizeMake(SCREEN_WIDTH, OrderAfterPay.frame.size.height+20)];
    [scrollView_AfterPay addSubview:OrderAfterPay];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (void)doneLoadingViewData{
    
    //  model should call this when its done loading
    self.reloading = NO;
    [self.refreshHeaderAndFooterView RefreshScrollViewDataSourceDidFinishedLoading:scrollView_AfterPay];
    
}
#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.refreshHeaderAndFooterView RefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.refreshHeaderAndFooterView RefreshScrollViewDidEndDragging:scrollView];
    //请求数据
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"RefreshRequestDataVackCall:"];
    [dataprovider GetOrderInfoWithOrderNum:OrderInfo[@"ordernum"]];
}
#pragma mark -
#pragma mark RefreshHeaderAndFooterViewDelegate Methods

- (void)RefreshHeaderAndFooterDidTriggerRefresh:(RefreshHeaderAndFooterView*)view{
    self.reloading = YES;
    if (view.refreshHeaderView.state == PullRefreshLoading) {//下拉刷新动作的内容
        NSLog(@"header");
        [self performSelector:@selector(doneLoadingViewData) withObject:nil afterDelay:3.0];
        
    }
}

- (BOOL)RefreshHeaderAndFooterDataSourceIsLoading:(RefreshHeaderAndFooterView*)view{
    
    return self.reloading; // should return if data source model is reloading
    
}
- (NSDate*)RefreshHeaderAndFooterDataSourceLastUpdated:(RefreshHeaderAndFooterView*)view{
    return [NSDate date];
}

-(void)RefreshRequestDataVackCall:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        OrderInfo=dict[@"data"];
    }
    NSLog(@"刷新请求数据：%@",dict);
    [self PayForOrder:dict[@"data"]];
}

-(void)CancelBtnClick:(UIButton *)sender
{
    if (sender.tag!=0) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"CancelOrderBackCall:"];
        [dataprovider CancelOrderWithOrderNum:OrderInfo[@"ordernum"]];
    }
    else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"美食已经制作，\n是否联系商家取消订单？"
                                                       message:@"确定拨打电话？"
                                                      delegate:self
                                             cancelButtonTitle:@"取消"
                                             otherButtonTitles:@"呼叫", nil];
        [alert show];
    }
    
}
-(void)CancelOrderBackCall:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        //重新给页面赋值
        for (UIView * item in scrollView_AfterPay.subviews) {
            [item removeFromSuperview];
        }
        OrderInfo=dict[@"data"];
        [self PayForOrder:OrderInfo];
        
    }
}

-(void)btn_tousuclick:(UIButton *)sender
{
    OtherOfMineViewController * otherofmine=[[OtherOfMineViewController alloc] initWithNibName:@"OtherOfMineViewController" bundle:[NSBundle mainBundle]];
    otherofmine.celltag=2;
    [self.navigationController pushViewController:otherofmine animated:YES];
}
-(void)CuidanForTel
{
    NSLog(@"电话催单。%@",OrderInfo);
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@""
                                                   message:OrderInfo[@"resphone"]!=[NSNull null]?OrderInfo[@"resphone"]:@"餐厅未设置电话号码"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"呼叫", nil];
    [alert show];
}

-(void)OrderReciver
{
    NSLog(@"确认收货");
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"orderReciverBackcall:"];
    [dataprovider OrderReciver:OrderInfo[@"ordernum"]];
}

-(void)orderReciverBackcall:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderInfoBackCall:"];
        [dataprovider GetOrderInfoWithOrderNum:_orderInfoDetial[@"ordernum"]];
    }
}
-(void)dingdanTousu
{
    NSLog(@"订单评价");
    _mypingjia=[[PingjiaForOrderViewController alloc] init];
    _mypingjia.goodsList=_orderData;
    _mypingjia.price=_lastprice;
    _mypingjia.OrderInfo=OrderInfo;
    [self.navigationController pushViewController:_mypingjia animated:YES];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (1==buttonIndex&&OrderInfo[@"resphone"]!=[NSNull null]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",OrderInfo[@"resphone"]]]];
    }
}

/**
 *  倒计时时间到，取消订单
 *
 *  @param timerLabel <#timerLabel description#>
 *  @param countTime  <#countTime description#>
 */
-(void)timerLabel:(MZTimerLabel*)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime{
    //time is up, what should I do master?
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"CancelOrderBackCall:"];
    [dataprovider CancelOrderWithOrderNum:OrderInfo[@"ordernum"]];
}

-(void)TryAnotherOrder
{
    if (OrderInfo[@"resid"]!=[NSNull null]) {
        _myCanting=[[CantingInfoViewController alloc] initWithNibName:@"CantingInfoViewController" bundle:[NSBundle mainBundle]];
        _myCanting.resid=OrderInfo[@"resid"];
        _myCanting.name=OrderInfo[@"resname"];
        _myCanting.peisongData=OrderInfo[@"deliveryprice"];
        _myCanting.beginprice=OrderInfo[@"begindeliveryprice"];
        [self.navigationController pushViewController:_myCanting animated:YES];
    }
}
-(void)clickLeftButton:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(NSString * )GetResiveOrderTime:(NSString *)date
{
    NSArray *array = [date componentsSeparatedByString:@" "];
    if (array.count>1) {
        NSArray *datearray=[array[1] componentsSeparatedByString:@":"];
        int hour=[datearray[0] intValue];
        int minute=[datearray[1] intValue];
        if (minute<50) {
            minute+=10;
        }
        if (minute>=50) {
            hour+=1;
            minute-=50;
        }
        if (minute<10) {
            return [NSString stringWithFormat:@"%2d:0%d",hour,minute];
        }
        else
        {
            return [NSString stringWithFormat:@"%2d:%2d",hour,minute];
        }
        
    }
    return @"";
}

-(void)RefReshView
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderInfoBackCall:"];
    [dataprovider GetOrderInfoWithOrderNum:_orderInfoDetial[@"ordernum"]];
}

-(void)PayWithThisOrder:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"正在进行支付。。" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetChargeBackCall:"];
        if ([OrderInfo[@"payway"] intValue]==2) {
            NSDictionary * prm=@{@"channel":@"wx",@"amount":[NSString stringWithFormat:@"%.0f",[OrderInfo[@"orderprice"] floatValue]*100],@"ordernum":OrderInfo[@"ordernum"],@"subject":@"外卖微信支付",@"body":@"外卖"};
            //                NSDictionary * prm=@{@"channel":@"wx",@"amount":@"1",@"ordernum":dict[@"data"][@"ordernum"],@"subject":@"外卖微信支付",@"body":@"外卖"};
            [dataprovider GetchargeForPay:prm];
        }
        else if([_orderInfoDetial[@"payway"] intValue]==0)
        {
            NSDictionary * prm=@{@"channel":@"alipay",@"amount":[NSString stringWithFormat:@"%.0f",[OrderInfo[@"orderprice"] floatValue]*100],@"ordernum":OrderInfo[@"ordernum"],@"subject":@"外卖2",@"body":@"外卖"};
            //                NSDictionary * prm=@{@"channel":@"alipay",@"amount":@"1",@"ordernum":dict[@"data"][@"ordernum"],@"subject":@"外卖2",@"body":@"外卖"};
            [dataprovider GetchargeForPay:prm];
        }
    
}
-(void)GetChargeBackCall:(id)dict
{
    NSLog(@"%@",dict);
    [SVProgressHUD dismiss];
    
    if (dict) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str_data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
            if ([_orderInfoDetial[@"payway"] intValue]==3) {
                [Pingpp createPayment:str_data viewController:self appURLScheme:@"wx9039702cc87118c0" withCompletion:^(NSString *result, PingppError *error) {
                    if ([result isEqualToString:@"success"]) {
                        NSLog(@"支付成功");
                    } else {
                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                    }
                }];
            }else{
                [Pingpp createPayment:str_data viewController:self appURLScheme:@"BGTakeOut" withCompletion:^(NSString *result, PingppError *error) {
                    if ([result isEqualToString:@"success"]) {
                        NSLog(@"支付成功");
                    } else {
                        NSLog(@"PingppError: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                    }
                }];
            }
            
        
        
        
    }
}


@end
