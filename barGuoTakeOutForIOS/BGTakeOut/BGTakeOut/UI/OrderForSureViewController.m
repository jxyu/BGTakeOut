//
//  OrderForSureViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/7.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "OrderForSureViewController.h"
#import "ShoppingCarModel.h"
#import "DataProvider.h"
#import "Pingpp.h"
#import "CommenDef.h"
#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height


@interface OrderForSureViewController ()
@property(nonatomic,strong)RefreshHeaderAndFooterView * refreshHeaderAndFooterView;
@property(nonatomic,assign)BOOL reloading;
@end

@implementation OrderForSureViewController
{
    NSDictionary *OrderInfo;
    UIView * myPage;
    UITextField *txt_phoneNum;
    UITextField *txt_address;
    
    UITextView * Costommessage;
    UILabel *uilabel;
    UILabel *lbl_zishu;
    
    UIButton * PayOnLine;
    UIButton * PayWXWay;
    UIButton * PayOutLine;
    BOOL PayOnLineForChange;//yes代表在线支付
    
    UIView * OrderAfterPay;
    UIScrollView * scrollView_AfterPay;
    NSTimer *timer;
    
    
    
}
@synthesize refreshHeaderAndFooterView = _refreshHeaderAndFooterView;
@synthesize reloading = _reloading;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    PayOnLineForChange=YES;
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self setBarTitle:@"订单确认"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    myPage=[[UIView alloc]initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+21, KWidth, KHeight-NavigationBar_HEIGHT-20)];
    myPage.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:myPage];
    
    UIView * BackgroundView1=[[UIView alloc] initWithFrame:CGRectMake(0, 5, KWidth, 40)];
    BackgroundView1.backgroundColor=[UIColor whiteColor];
    UILabel * PhoneNum =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    PhoneNum.text=@"手机号：";
    [BackgroundView1 addSubview:PhoneNum];
    UIView * lastView=[[BackgroundView1 subviews] lastObject];
    CGFloat x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_phoneNum setKeyboardType:UIKeyboardTypeNumberPad];
    [txt_phoneNum setPlaceholder:@"请输入手机号"];
    [BackgroundView1 addSubview:txt_phoneNum];
    [myPage addSubview:BackgroundView1];
    
    lastView=BackgroundView1;
    UIView * BackgroundView2=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y+1, KWidth, 40)];
    BackgroundView2.backgroundColor=[UIColor whiteColor];
    UILabel * Pwd =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    Pwd.text=@"地址：";
    [BackgroundView2 addSubview:Pwd];
    lastView=[[BackgroundView2 subviews] lastObject];
    x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_address=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_address setPlaceholder:@"输入地址"];
    [txt_address setKeyboardType:UIKeyboardTypeDefault];
    [BackgroundView2 addSubview:txt_address];
    [myPage addSubview:BackgroundView2];
    UIView * fillview=[[UIView alloc] initWithFrame:CGRectMake(0, BackgroundView2.frame.size.height+BackgroundView2.frame.origin.y, KWidth, 5)];
    [myPage addSubview:fillview];
    
    for (int i=0; i<_orderData.count; i++) {
        lastView=[myPage.subviews lastObject];
        UIView *orderBackground=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, KWidth,30)];
        lastView=[self.view.subviews lastObject];
        orderBackground.backgroundColor=[UIColor whiteColor];
        ShoppingCarModel *item=_orderData[i];
        UILabel *itemName=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 20)];
        itemName.text=item.Goods[@"name"];
        [orderBackground addSubview:itemName];
        UILabel * itemnum=[[UILabel alloc] initWithFrame:CGRectMake(itemName.frame.origin.x+itemName.frame.size.width, 5, 40, 20)];
        itemnum.text=[NSString stringWithFormat:@"X%d",item.Num];
        [orderBackground addSubview:itemnum];
        UILabel * itemprice=[[UILabel alloc] initWithFrame:CGRectMake(itemnum.frame.origin.x+itemnum.frame.size.width, 5, 50, 20)];
        itemprice.text=[NSString stringWithFormat:@"%.2f",item.Num*[item.Goods[@"price"] floatValue]];
        [orderBackground addSubview:itemprice];
        [myPage addSubview:orderBackground];
    }
    
    lastView=[myPage.subviews lastObject];
    Costommessage=[[UITextView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y+5, KWidth, 80)];
    [Costommessage setKeyboardType:UIKeyboardTypeDefault];
    Costommessage.delegate=self;
    [myPage addSubview:Costommessage];
        uilabel=[[UILabel alloc] initWithFrame:CGRectMake(17, lastView.frame.size.height+lastView.frame.origin.y+18, 100, 10)];
    uilabel.text = @"给餐厅留言..";
    uilabel.enabled = NO;//lable必须设置为不可用
    uilabel.backgroundColor = [UIColor clearColor];
    [myPage addSubview:uilabel];
    lbl_zishu=[[UILabel alloc] initWithFrame:CGRectMake(KWidth-160, lastView.frame.size.height+lastView.frame.origin.y+Costommessage.frame.size.height-10, 150, 10)];
    lbl_zishu.text=@"还能输入140个字";
    lbl_zishu.enabled=NO;
    lbl_zishu.backgroundColor=[UIColor clearColor];
    [myPage addSubview:lbl_zishu];
    
    lastView=Costommessage;
    UIView *peisongfeiView=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, KWidth, 40)];
    peisongfeiView.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_peisongfei=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    lbl_peisongfei.text=@"配送费";
    lbl_peisongfei.textColor=[UIColor colorWithRed:255/255.0 green:113/255.0 blue:14/255.0 alpha:1.0];
    [peisongfeiView addSubview:lbl_peisongfei];
    
    UILabel * lbl_peisongprice=[[UILabel alloc] initWithFrame:CGRectMake(250, 10, 40, 20)];
    lbl_peisongprice.text=_peiSongFeiData;
    lbl_peisongprice.textColor=[UIColor colorWithRed:255/255.0 green:113/255.0 blue:14/255.0 alpha:1.0];
    [peisongfeiView addSubview:lbl_peisongprice];
    [myPage addSubview:peisongfeiView];
    
    lastView=[myPage.subviews lastObject];
    UIView * PayWayBackView=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, KWidth, 100)];
    PayWayBackView.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_payname=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 150, 30)];
    lbl_payname.text=@"支付方式";
    [PayWayBackView addSubview:lbl_payname];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, 40, KWidth-20, 1)];
    fenge.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [PayWayBackView addSubview:fenge];
    PayOnLine=[[UIButton alloc] initWithFrame:CGRectMake(KWidth/4-40, 60, 120, 25)];
    [PayOnLine setTitle:@"在线支付" forState:UIControlStateNormal];
    PayOnLine.tag=1;
    [PayOnLine setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
    [PayOnLine addTarget:self action:@selector(ChangePayWay:) forControlEvents:UIControlEventTouchUpInside];
    [PayOnLine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [PayWayBackView addSubview:PayOnLine];
    PayOutLine=[[UIButton alloc] initWithFrame:CGRectMake(KWidth/4*2, 60, 120, 25)];
    [PayOutLine setTitle:@"货到付款" forState:UIControlStateNormal];
    [PayOutLine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [PayOutLine setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    PayOutLine.tag=2;
    [PayOutLine addTarget:self action:@selector(ChangePayWay:) forControlEvents:UIControlEventTouchUpInside];
    [PayWayBackView addSubview:PayOutLine];
    [myPage addSubview:PayWayBackView];
    
    lastView=[myPage.subviews lastObject];
    UIButton * submitOrder=[[UIButton alloc] initWithFrame:CGRectMake(20, lastView.frame.origin.y+lastView.frame.size.height+5, KWidth-40, 30)];
    [submitOrder setTitle:@"提交订单" forState:UIControlStateNormal];
    [submitOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitOrder.backgroundColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
    [submitOrder addTarget:self action:@selector(SubmitOrderfunc) forControlEvents:UIControlEventTouchUpInside];
    [myPage addSubview:submitOrder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackBtnClick
{
    [self.view removeFromSuperview];
}
-(void)RightButtonClick
{
    [txt_phoneNum resignFirstResponder];
    [txt_address resignFirstResponder];
}

-(void)textViewDidChange:(UITextView *)textView
{
    int textlength=textView.text.length ;
    if (textlength== 0) {
        uilabel.text = @"给餐厅留言..";
    }else{
        uilabel.text = @"";
        lbl_zishu.text=[NSString stringWithFormat:@"还能输入%d个字",140-textlength];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

-(void)ChangePayWay:(UIButton *)sender
{
    if (1==sender.tag) {
        PayOnLineForChange=YES;
        [PayOnLine setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
        [PayOutLine setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    }
    else
    {
        PayOnLineForChange=NO;
        [PayOutLine setImage:[UIImage imageNamed:@"RadioButtonSelected"] forState:UIControlStateNormal];
        [PayOnLine setImage:[UIImage imageNamed:@"RadioButton"] forState:UIControlStateNormal];
    }
}

-(void)SubmitOrderfunc
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary *dictionary =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (dictionary) {
        [self BuildDataToSubmit:dictionary];
    }
    else
    {
        _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UIView * item =_myLogin.view;
        [_myLogin setDelegateObject:self setBackFunctionName:@"LoginBackCall:"];
        [self.view addSubview:item];
    }
}

-(void)LoginBackCall:(id)dict
{
    if (1==[dict[@"status"] integerValue]) {
        [self BuildDataToSubmit:dict[@"data"]];
    }
}
#pragma mark 构建提交订餐所需的参数
-(void)BuildDataToSubmit:(id)dict
{
    NSString * phonenum=txt_phoneNum.text;
    NSMutableDictionary * prm=[[NSMutableDictionary alloc] init];
    [prm setObject:[NSString stringWithFormat:@"%d",[_orderSumPrice intValue]+[_peiSongFeiData intValue]] forKey:@"orderprice"];
    
    [prm setObject:dict[@"userid"] forKey:@"realname"];//此处需修改
    
    if (txt_phoneNum.text) {
        [prm setObject:txt_phoneNum.text forKey:@"phonenum"];
        if (dict[@"userid"]) {
            [prm setObject:dict[@"userid"] forKey:@"userid"];
            
            if (dict[@"username"]) {
                 [prm setObject:dict[@"userid"] forKey:@"username"];
                if (txt_address.text) {
                    [prm setObject:txt_address.text forKey:@"address"];
                    if (PayOnLineForChange) {
                        [prm setObject:@"0"forKey:@"payway"];
                    }else
                    {
                        [prm setObject:@"1"forKey:@"payway"];
                    }
                    if (Costommessage.text) {
                        [prm setObject:Costommessage.text forKey:@"remark"];
                    }
//                    NSMutableArray * orderdataArray=[[NSMutableArray alloc] init];
                    NSMutableString * orderdataStr=[[NSMutableString alloc] init];
                    
                    for (int i=0; i<_orderData.count; i++) {
                        ShoppingCarModel *item=_orderData[i];
                        NSString * jsonStr;
                        if (i ==(_orderData.count-1)) {
                            jsonStr=[NSString stringWithFormat:@"{\"goodsid\":%@,\"goodsname\":%@,\"count\":%d,\"activity\":%@}",item.Goods[@"goodsid"],item.Goods[@"name"],item.Num,item.Goods[@"activity"]];
                        }
                        else{
                            jsonStr=[NSString stringWithFormat:@"{\"goodsid\":%@,\"goodsname\":%@,\"count\":%d,\"activity\":%@},",item.Goods[@"goodsid"],item.Goods[@"name"],item.Num,item.Goods[@"activity"]];
                        }
                        [orderdataStr appendString:jsonStr];
                        [prm setObject:item.Goods[@"resid"] forKey:@"resid"];
                    }
                    
                    [prm setObject:orderdataStr  forKey:@"goodsdetail"];
                    DataProvider * dataprovider=[[DataProvider alloc] init];
                    [dataprovider setDelegateObject:self setBackFunctionName:@"submitOrderBackCall:"];
                    [dataprovider SubmitOrder:prm];
                    
                }
                else
                {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                                  message:NSLocalizedString(@"请填写送餐地址", nil)
                                                                 delegate:self
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
        }
    }else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                      message:NSLocalizedString(@"请填写手机号", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)submitOrderBackCall:(id)dict
{
    NSLog(@"提交订单%@",dict);
    if ([dict[@"status"] intValue]==1) {
        OrderInfo=dict[@"data"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetChargeBackCall:"];
        NSDictionary * prm=@{@"channel":@"alipay",@"amount":@"22",@"ordernum":@"2015050900088",@"subject":@"外卖2",@"body":@"外卖"};
        [dataprovider GetchargeForPay:prm];
    }
}

-(void)PayForOrder:(NSDictionary *)dict
{
    scrollView_AfterPay=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    scrollView_AfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    scrollView_AfterPay.scrollEnabled=YES;
    scrollView_AfterPay.delegate=self;
    
    
    
    RefreshHeaderAndFooterView *view= [[RefreshHeaderAndFooterView alloc] initWithFrame:CGRectMake(scrollView_AfterPay.frame.origin.x, scrollView_AfterPay.frame.origin.y, scrollView_AfterPay.frame.size.width, scrollView_AfterPay.contentSize.height)];
    view.delegate = self;
    [scrollView_AfterPay addSubview:view];
    self.refreshHeaderAndFooterView=view;
    
    
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
            [cansalOrder addTarget:self action:@selector(CancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
            
            OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
            OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
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
//            UILabel * lbl_jiedan
            break;
        case 3:
            imagename=@"paysure.png";
            lbl_Status.text=@"买家确认收货,交易成功";
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
    
    
    
    
    OrderAfterPay =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 800)];
    OrderAfterPay.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
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
    
    UIView * BackView_OrderListTitle=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_img_status.frame.origin.y+BackView_img_status.frame.size.height+5, KWidth, 40)];
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
    
    UIView * lastView;
    float sumprice=0;
    if (_orderData.count>0) {
        for (int i=0; i<_orderData.count; i++) {
            lastView=[OrderAfterPay.subviews lastObject];
            UIView *orderBackground=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, KWidth,30)];
            lastView=[self.view.subviews lastObject];
            orderBackground.backgroundColor=[UIColor whiteColor];
            ShoppingCarModel *item=_orderData[i];
            UILabel *itemName=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 20)];
            itemName.text=item.Goods[@"name"];
            [orderBackground addSubview:itemName];
            UILabel * itemnum=[[UILabel alloc] initWithFrame:CGRectMake(itemName.frame.origin.x+itemName.frame.size.width, 5, 40, 20)];
            itemnum.text=[NSString stringWithFormat:@"X%d",item.Num];
            [orderBackground addSubview:itemnum];
            UILabel * itemprice=[[UILabel alloc] initWithFrame:CGRectMake(itemnum.frame.origin.x+itemnum.frame.size.width, 5, 50, 20)];
            itemprice.text=[NSString stringWithFormat:@"%.2f",item.Num*[item.Goods[@"price"] floatValue]];
            [orderBackground addSubview:itemprice];
            [OrderAfterPay addSubview:orderBackground];
            sumprice+=item.Num*[item.Goods[@"price"] floatValue];
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
    [self.view addSubview:scrollView_AfterPay];
    
    
    
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
    }
}

-(void)GetChargeBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (dict) {
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        NSString* str_data = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [Pingpp createPayment:str_data viewController:self appURLScheme:@"BGTackOut" withCompletion:^(NSString *result, PingppError *error) {
            if ([result isEqualToString:@"success"]) {
                NSLog(@"支付成功");
        } else {
            NSLog(@"PingppError: code=%lu msg=%@", error.code, [error getMsg]);
        }
        }];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
