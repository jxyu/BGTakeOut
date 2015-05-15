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


#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

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
    scrollView_AfterPay=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    scrollView_AfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    scrollView_AfterPay.scrollEnabled=YES;
    scrollView_AfterPay.delegate=self;
    
    OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
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
    NSLog(@"获取订单信息%@",dict);
    if (1==[dict[@"status"] intValue]) {
        NSData * data=[dict[@"data"][@"goodsdetail"] dataUsingEncoding:NSUTF8StringEncoding];
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:nil];
        _orderData=(NSArray *)jsonObject;
        [self PayForOrder:dict[@"data"]];
        
    }
}

-(void)PayForOrder:(NSDictionary *)dict
{
    
    
    
    UIView * BackView_OrderTitle=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, 200)];
    BackView_OrderTitle.backgroundColor=[UIColor whiteColor];
    UIImageView * img_Status_icon=[[UIImageView alloc] initWithFrame:CGRectMake(40, 20, 20, 20)];
    UILabel * lbl_Status=[[UILabel alloc] initWithFrame:CGRectMake(img_Status_icon.frame.origin.x+img_Status_icon.frame.size.width, 20, 200, 20)];
    NSString *imagename;
    switch ([dict[@"status"] intValue]) {
        case 0:
            imagename=@"paysure.png";
            lbl_Status.text=@"提交订单，等待付款";
            
            break;
        case 1:
            imagename=@"timer.png";
            lbl_Status.text=@"付款完成，等待餐厅接单";
            break;
        case 2:
            imagename=@"timer.png";
            lbl_Status.text=@"餐厅接单完成，正在配送";
            break;
        case 3:
            imagename=@"paysure.png";
            lbl_Status.text=@"买家确认收货,交易成功";
            break;
        case 4:
            imagename=@"timer.png";
            lbl_Status.text=@"卖家已接单，正在配送";
            break;
        case 7:
            imagename=@"no_icon.png";
            lbl_Status.text=@"未付款,订单取消，交易关闭";
            break;
        case 8:
            imagename=@"no_icon.png";
            lbl_Status.text=@"已付款，订单取消，等待退款";
            break;
        case 9:
            imagename=@"no_icon.png";
            lbl_Status.text=@"退款成功，交易关闭";
            break;
        default:
            break;
    }
    img_Status_icon.image=[UIImage imageNamed:imagename];
    [BackView_OrderTitle addSubview:img_Status_icon];
    [BackView_OrderTitle addSubview:lbl_Status];
    
        switch ([dict[@"status"] intValue]) {
        case 0:
        {
            
        }
            break;
        case 1://已支付，等待接单
        {
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, KWidth-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:244/255.0 green:243/255.0 blue:241/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, (KWidth-80)/2, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.text=@"已等待";
            [backview_StatusInfo addSubview:lbl_title];
            UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(lbl_title.frame.origin.x+lbl_title.frame.size.width, 10, 1, 20)];
            fenge.backgroundColor=[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
            [backview_StatusInfo addSubview:fenge];
            //    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:nil userInfo:nil repeats:YES];
            //    [timer setFireDate:[NSDate distantPast]];//开启
            UILabel * lbl_TimeCount=[[UILabel alloc] initWithFrame:CGRectMake(fenge.frame.origin.x+fenge.frame.size.width, 10,(KWidth-80)/2 , 20)];
            [lbl_TimeCount setTextAlignment:NSTextAlignmentCenter];
            lbl_TimeCount.text=[NSString stringWithFormat:@"预计10分钟内接单"];
            [backview_StatusInfo addSubview:lbl_TimeCount];
            fenge.backgroundColor=[UIColor colorWithRed:221/255.0 green:220/255.0 blue:218/255.0 alpha:1.0];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-10-60, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height, 60, 30)];
            [cansalOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0]);
            [cansalOrder addTarget:self action:@selector(CancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            
            
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, KWidth, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:15];
            lbl_Image_First.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 2:
        {
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, KWidth-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"美食收到了吗，如果还未收到，记得电话催单哦";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor colorWithRed:255/255.0 green:80/255.0 blue:43/255.0 alpha:1.0];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-10-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [cansalOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            [cansalOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.cornerRadius=5;
            cansalOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            [cansalOrder addTarget:self action:@selector(CancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            UIButton * btn_cuidan=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-140, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_cuidan setTitle:@"电话催单" forState:UIControlStateNormal];
            [btn_cuidan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_cuidan.layer.borderWidth=1.0;
            btn_cuidan.layer.cornerRadius=5;
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_cuidan addTarget:self action:@selector(CuidanForTel) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_cuidan];
            UIButton * btn_ReciveGood=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-210, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_ReciveGood setTitle:@"确认收货" forState:UIControlStateNormal];
            [btn_ReciveGood setTitleColor:[UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            btn_ReciveGood.layer.borderWidth=1.0;
            btn_ReciveGood.layer.cornerRadius=5;
            btn_ReciveGood.titleLabel.font=[UIFont systemFontOfSize:13];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
            [btn_ReciveGood.layer setBorderColor:colorref];
            [btn_ReciveGood addTarget:self action:@selector(OrderReciver) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_ReciveGood];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, KWidth, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:15];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 3:
        {
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, KWidth-80, 40)];
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
            
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-10-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [cansalOrder setTitle:@"订单投诉" forState:UIControlStateNormal];
            [cansalOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.cornerRadius=5;
            cansalOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            [cansalOrder addTarget:self action:@selector(dingdanTousu) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, KWidth, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:15];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 4:
        {
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, KWidth-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"美食收到了吗，如果还未收到，记得电话催单哦";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor colorWithRed:255/255.0 green:80/255.0 blue:43/255.0 alpha:1.0];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            UIButton * cansalOrder=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-10-60, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [cansalOrder setTitle:@"取消订单" forState:UIControlStateNormal];
            [cansalOrder setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            cansalOrder.layer.borderWidth=1.0;
            cansalOrder.layer.cornerRadius=5;
            cansalOrder.titleLabel.font=[UIFont systemFontOfSize:13];
            [cansalOrder addTarget:self action:@selector(CancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:cansalOrder];
            UIButton * btn_cuidan=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-140, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_cuidan setTitle:@"电话催单" forState:UIControlStateNormal];
            [btn_cuidan setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn_cuidan.layer.borderWidth=1.0;
            btn_cuidan.layer.cornerRadius=5;
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            [btn_cuidan addTarget:self action:@selector(CuidanForTel) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_cuidan];
            UIButton * btn_ReciveGood=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-210, backview_StatusInfo.frame.origin.y+backview_StatusInfo.frame.size.height+5, 60, 30)];
            [btn_ReciveGood setTitle:@"确认收货" forState:UIControlStateNormal];
            [btn_ReciveGood setTitleColor:[UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0] forState:UIControlStateNormal];
            btn_cuidan.titleLabel.font=[UIFont systemFontOfSize:13];
            btn_ReciveGood.layer.borderWidth=1.0;
            btn_ReciveGood.layer.cornerRadius=5;
            btn_ReciveGood.titleLabel.font=[UIFont systemFontOfSize:13];
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
            [btn_ReciveGood.layer setBorderColor:colorref];
            //    btn_ReciveGood.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:255/255.0 green:116/255.0 blue:15/255.0 alpha:1.0]);
            [btn_ReciveGood addTarget:self action:@selector(OrderReciver) forControlEvents:UIControlEventTouchUpInside];
            [BackView_OrderTitle addSubview:btn_ReciveGood];
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, KWidth, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:15];
            [BackView_img_status addSubview:lbl_Image_First];
            UIView * gotoNext=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext];
            UIImageView * secondImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext.frame.origin.x+gotoNext.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            secondImg.layer.masksToBounds=YES;
            secondImg.layer.cornerRadius=10;
            secondImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            secondImg.image=[UIImage imageNamed:@"sencond.png"];
            [BackView_img_status addSubview:secondImg];
            UILabel * lbl_Image_Second=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*2+lbl_Image_First.frame.size.width, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Second.text=@"餐厅接单";
            lbl_Image_Second.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Second];
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(secondImg.frame.origin.x+secondImg.frame.size.width, secondImg.frame.origin.y+(secondImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"thitd.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            UIView * gotoNext3=[[UIView alloc] initWithFrame:CGRectMake(ThirdImg.frame.origin.x+ThirdImg.frame.size.width, ThirdImg.frame.origin.y+(ThirdImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext3.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext3];
            UIImageView * FourthImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext3.frame.origin.x+gotoNext3.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            FourthImg.layer.masksToBounds=YES;
            FourthImg.layer.cornerRadius=10;
            FourthImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            FourthImg.image=[UIImage imageNamed:@"sure.png"];
            UILabel * lbl_Image_Forth=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*4+lbl_Image_First.frame.size.width*3, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Forth.text=@"已收货";
            lbl_Image_Forth.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Forth];
            [BackView_img_status addSubview:FourthImg];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 7:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, KWidth, 100);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, KWidth-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"订单取消成功";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, KWidth, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake(85, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:15];
            [BackView_img_status addSubview:lbl_Image_First];
            
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"no_icon.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 8:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, KWidth, 100);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, KWidth-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"订单取消成功，正在退款";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, KWidth, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake(85, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:15];
            [BackView_img_status addSubview:lbl_Image_First];
            
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"no_icon.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        case 9:
        {
            BackView_OrderTitle.frame=CGRectMake(BackView_OrderTitle.frame.origin.x, BackView_OrderTitle.frame.origin.y, KWidth, 100);
            UIView * backview_StatusInfo=[[UIView alloc] initWithFrame:CGRectMake(40, img_Status_icon.frame.origin.y+img_Status_icon.frame.size.height+2, KWidth-80, 40)];
            backview_StatusInfo.backgroundColor=[UIColor colorWithRed:253/255.0 green:229/255.0 blue:225/255.0 alpha:1.0];
            UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(0, 10, backview_StatusInfo.frame.size.width, 20)];
            [lbl_title setTextAlignment:NSTextAlignmentCenter];
            lbl_title.font=[UIFont systemFontOfSize:12];
            lbl_title.text=@"退款成功，交易关闭";
            [lbl_title setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_title.numberOfLines=0;
            lbl_title.textColor=[UIColor grayColor];
            [backview_StatusInfo addSubview:lbl_title];
            [BackView_OrderTitle addSubview:backview_StatusInfo];
            
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            [OrderAfterPay addSubview:BackView_OrderTitle];
            UIView * BackView_img_status=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_OrderTitle.frame.origin.y+BackView_OrderTitle.frame.size.height+5, KWidth, 60)];
            BackView_img_status.backgroundColor=[UIColor whiteColor];
            UIImageView * firstImg=[[UIImageView alloc] initWithFrame:CGRectMake(105, 10, 20, 20)];
            firstImg.layer.masksToBounds=YES;
            firstImg.layer.cornerRadius=10;
            firstImg.image=[UIImage imageNamed:@"first.png"];
            firstImg.backgroundColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:firstImg];
            UILabel * lbl_Image_First=[[UILabel alloc] initWithFrame:CGRectMake(85, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_First.text=@"订单提交";
            lbl_Image_First.font=[UIFont fontWithName:@"Helvetica" size:15];
            [BackView_img_status addSubview:lbl_Image_First];
            
            UIView * gotoNext2=[[UIView alloc] initWithFrame:CGRectMake(firstImg.frame.origin.x+firstImg.frame.size.width, firstImg.frame.origin.y+(firstImg.frame.size.height/2), (KWidth-160)/3, 1)];
            gotoNext2.backgroundColor=[UIColor grayColor];
            [BackView_img_status addSubview:gotoNext2];
            UIImageView * ThirdImg=[[UIImageView alloc] initWithFrame:CGRectMake(gotoNext2.frame.origin.x+gotoNext2.frame.size.width, firstImg.frame.origin.y, 20, 20)];
            ThirdImg.layer.masksToBounds=YES;
            ThirdImg.layer.cornerRadius=10;
            ThirdImg.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
            ThirdImg.image=[UIImage imageNamed:@"no_icon.png"];
            [BackView_img_status addSubview:ThirdImg];
            UILabel * lbl_Image_Third=[[UILabel alloc] initWithFrame:CGRectMake((KWidth-280)/5*3+lbl_Image_First.frame.size.width*2, firstImg.frame.origin.y+firstImg.frame.size.height+10, 70, 10)];
            lbl_Image_Third.text=@"配送中";
            lbl_Image_Third.font=[UIFont fontWithName:@"Helvetica" size:15];
            //    lbl_Image_Second.textColor=[UIColor colorWithRed:83/255.0 green:193/255.0 blue:36/255.0 alpha:1.0];
            [BackView_img_status addSubview:lbl_Image_Third];
            [OrderAfterPay addSubview:BackView_img_status];
        }
            break;
        default:
            break;
    }
    
    
    
    
    

    UIView * lastView=[OrderAfterPay.subviews lastObject];
    UIView * BackView_OrderListTitle=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height, KWidth, 40)];
    BackView_OrderListTitle.backgroundColor=[UIColor whiteColor];
    UIImageView * Img_orderListTitle=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    Img_orderListTitle.image=[UIImage imageNamed:@"Home"];
    [BackView_OrderListTitle addSubview:Img_orderListTitle];
    UILabel * lbl_CantingTitle=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, 150, 20)];
    lbl_CantingTitle.text=dict[@"resname"];
    [BackView_OrderListTitle addSubview:lbl_CantingTitle];
    UIImageView * goImage=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-10-20, (BackView_OrderListTitle.frame.size.height-25)/2, 20, 25)];
    goImage.image=[UIImage imageNamed:@"go.png"];
    [BackView_OrderListTitle addSubview:goImage];
    [OrderAfterPay addSubview:BackView_OrderListTitle];
    
    
    float sumprice=0;
    if (_orderData.count>0) {
        for (int i=0; i<_orderData.count; i++) {
            lastView=[OrderAfterPay.subviews lastObject];
            UIView *orderBackground=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, KWidth,30)];
            lastView=[self.view.subviews lastObject];
            orderBackground.backgroundColor=[UIColor whiteColor];
            UILabel *itemName=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 20)];
            itemName.text=_orderData[i][@"goodsname"];
            [orderBackground addSubview:itemName];
            UILabel * itemnum=[[UILabel alloc] initWithFrame:CGRectMake(itemName.frame.origin.x+itemName.frame.size.width, 5, 40, 20)];
            itemnum.text=[NSString stringWithFormat:@"X%@",_orderData[i][@"goodsNum"]];
            [orderBackground addSubview:itemnum];
            UILabel * itemprice=[[UILabel alloc] initWithFrame:CGRectMake(itemnum.frame.origin.x+itemnum.frame.size.width, 5, 90, 20)];
            itemprice.text=[NSString stringWithFormat:@"%.2f",[_orderData[i][@"goodsNum"] intValue]*[_orderData[i][@"goodsprice"] floatValue]];
            [orderBackground addSubview:itemprice];
            [OrderAfterPay addSubview:orderBackground];
            sumprice+=[_orderData[i][@"goodsNum"] intValue]*[_orderData[i][@"goodsprice"] floatValue];
        }
    }
    
    lastView=[OrderAfterPay.subviews lastObject];
    UIView * BackView_SumPrice=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, KWidth, 40)];
    BackView_SumPrice.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_sunTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
    lbl_sunTitle.text=@"合计：";
    [BackView_SumPrice addSubview:lbl_sunTitle];
    UILabel * lbl_sumPrice=[[UILabel alloc] initWithFrame:CGRectMake(KWidth-100, 10, 80, 20)];
    lbl_sumPrice.text=[NSString stringWithFormat:@"¥%.2f",sumprice];
    [BackView_SumPrice addSubview:lbl_sumPrice];
    [OrderAfterPay addSubview:BackView_SumPrice];
    UIView * BackView_AgainOrder=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_SumPrice.frame.origin.y+BackView_SumPrice.frame.size.height+1, KWidth, 50)];
    BackView_AgainOrder.backgroundColor=[UIColor whiteColor];
    UIButton * btn_OtherOrder=[[UIButton alloc] initWithFrame:CGRectMake(KWidth-100-20, 10, 100, 30)];
    btn_OtherOrder.layer.masksToBounds=YES;
    btn_OtherOrder.layer.cornerRadius=6;
    btn_OtherOrder.layer.borderWidth=1;
    btn_OtherOrder.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0]);
    [btn_OtherOrder setTitle:@"再来一单" forState:UIControlStateNormal];
    [btn_OtherOrder setTitleColor:[UIColor colorWithRed:246/255.0 green:135/255.0 blue:82/255.0 alpha:1.0] forState:UIControlStateNormal];
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,116/255.0, 15/255.0, 1 });
    [btn_OtherOrder.layer setBorderColor:colorref];
    [BackView_AgainOrder addSubview:btn_OtherOrder];
    [OrderAfterPay addSubview:BackView_AgainOrder];
    
    UIView * BackVeiw_OrderInfo=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_AgainOrder.frame.origin.y+BackView_AgainOrder.frame.size.height+5, KWidth, 160)];
    BackVeiw_OrderInfo.backgroundColor=[UIColor whiteColor];
    UIImageView * Img_OrderInfo=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    Img_OrderInfo.image=[UIImage imageNamed:@"Home"];
    [BackVeiw_OrderInfo addSubview:Img_OrderInfo];
    UILabel * lbl_OrderInfoTitle=[[UILabel alloc] initWithFrame:CGRectMake(40, 10, 150, 20)];
    lbl_OrderInfoTitle.text=@"订单详情";
    [BackVeiw_OrderInfo addSubview:lbl_OrderInfoTitle];
    UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(10, lbl_OrderInfoTitle.frame.origin.y+lbl_OrderInfoTitle.frame.size.height+2, KWidth-20, 1)];
    fenge1.backgroundColor=[UIColor colorWithRed:209/255.0 green:209/255.0 blue:209/255.0 alpha:1.0];
    [BackVeiw_OrderInfo addSubview:fenge1];
    UILabel * lbl_dingdanNum=[[UILabel alloc] initWithFrame:CGRectMake(10, fenge1.frame.origin.y+fenge1.frame.size.height+8, KWidth, 10)];
    lbl_dingdanNum.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_dingdanNum.text=[NSString stringWithFormat:@"订单号码：%@",dict[@"ordernum"]];
    lbl_dingdanNum.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanNum];
    UILabel * lbl_dingdanTime=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_dingdanNum.frame.origin.y+lbl_dingdanNum.frame.size.height+8, KWidth, 10)];
    lbl_dingdanTime.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_dingdanTime.text=[NSString stringWithFormat:@"订单时间：%@",dict[@"updatetime"]];
    lbl_dingdanTime.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanTime];
    UILabel * lbl_dingdanPayWay=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_dingdanTime.frame.origin.y+lbl_dingdanTime.frame.size.height+8, KWidth, 10)];
    lbl_dingdanPayWay.font=[UIFont fontWithName:@"Helvetica" size:15];
    BOOL val=[dict[@"payway"] boolValue];
    lbl_dingdanPayWay.text=[NSString stringWithFormat:@"支付方式：%@",val?@"货到付款":@"在线支付"];
    lbl_dingdanPayWay.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanPayWay];
    UILabel * lbl_dingdanPhoneNum=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_dingdanPayWay.frame.origin.y+lbl_dingdanPayWay.frame.size.height+8, KWidth, 10)];
    lbl_dingdanPhoneNum.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_dingdanPhoneNum.text=[NSString stringWithFormat:@"手机号码：%@",dict[@"phonenum"]];
    lbl_dingdanPhoneNum.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanPhoneNum];
    UILabel * lbl_dingdanAddress=[[UILabel alloc] initWithFrame:CGRectMake(10, lbl_dingdanPhoneNum.frame.origin.y+lbl_dingdanPhoneNum.frame.size.height+8, KWidth, 10)];
    lbl_dingdanAddress.font=[UIFont fontWithName:@"Helvetica" size:15];
    lbl_dingdanAddress.text=[NSString stringWithFormat:@"收餐地址：%@",dict[@"address"]];
    lbl_dingdanAddress.textColor=[UIColor grayColor];
    [BackVeiw_OrderInfo addSubview:lbl_dingdanAddress];
    [OrderAfterPay addSubview:BackVeiw_OrderInfo];
    
    [scrollView_AfterPay setContentSize:CGSizeMake(KWidth, OrderAfterPay.frame.size.height)];
   
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
}

-(void)CancelBtnClick
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"CancelOrderBackCall:"];
    [dataprovider CancelOrderWithOrderNum:OrderInfo[@"ordernum"]];
}
-(void)CancelOrderBackCall:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        //重新给页面赋值
        OrderInfo=dict[@"data"];
        [self PayForOrder:OrderInfo];
        for (UIView * item in scrollView_AfterPay.subviews) {
            [item removeFromSuperview];
        }
    }
}

-(void)CuidanForTel
{
    NSLog(@"电话催单。%@",OrderInfo);
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@""
                                                   message:OrderInfo[@"resphone"]
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"呼叫", nil];
    [alert show];
}

-(void)OrderReciver
{
    NSLog(@"确认收货");
}
-(void)dingdanTousu
{
    NSLog(@"订单投诉");
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    if (1==buttonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",OrderInfo[@"resphone"]]]];
    }
}


@end
