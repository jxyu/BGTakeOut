//
//  PingjiaForOrderViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/18.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "PingjiaForOrderViewController.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "DataProvider.h"
#import "AMRatingControl.h"

@interface PingjiaForOrderViewController ()

@end

@implementation PingjiaForOrderViewController
{
    AMRatingControl *starRatingView;
    NSString * starScore;
    UILabel * lbl_starTitle;
    
    UITextView * txtV_PingjiaContent;
    UILabel *uilabelcontent;
    UILabel *lbl_zishucontent;
    
    UIButton * btn_Submit;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self setBarTitle:@"餐厅名称"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self addRightbuttontitle:@"取消"];
    
    UIView * BackView_Star=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 50)];
    BackView_Star.backgroundColor=[UIColor whiteColor];
    lbl_starTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 15, 80, 20)];
    lbl_starTitle.text=@"总体评价";
    [BackView_Star addSubview:lbl_starTitle];
    starRatingView=[[AMRatingControl alloc] initWithLocation:CGPointMake(lbl_starTitle.frame.size.width+lbl_starTitle.frame.origin.x+5, 12)
                                                        emptyColor:[UIColor lightGrayColor]
                                                        solidColor:[UIColor redColor]
                                                      andMaxRating:5];
    [starRatingView setUserInteractionEnabled:YES];
    starRatingView.backgroundColor=[UIColor clearColor];
    [starRatingView addTarget:self action:@selector(GetScoreForPingjia:) forControlEvents:UIControlEventEditingDidEnd];
    [BackView_Star addSubview:starRatingView];
    [self.view addSubview:BackView_Star];
    
    UIView * BackView_content=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_Star.frame.origin.y+BackView_Star.frame.size.height+20, SCREEN_WIDTH, 80)];
    BackView_content.backgroundColor=[UIColor whiteColor];
    txtV_PingjiaContent=[[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [txtV_PingjiaContent setKeyboardType:UIKeyboardTypeDefault];
    txtV_PingjiaContent.delegate=self;
    [BackView_content addSubview:txtV_PingjiaContent];
    
    uilabelcontent=[[UILabel alloc] initWithFrame:CGRectMake(17, 10, 300, 15)];
    uilabelcontent.text = @"写点评价吧，对其他小伙伴帮助很大哦";
    uilabelcontent.enabled = NO;//lable必须设置为不可用
    uilabelcontent.font=[UIFont systemFontOfSize:13];
    uilabelcontent.backgroundColor = [UIColor clearColor];
    [BackView_content addSubview:uilabelcontent];
    lbl_zishucontent=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160,BackView_content.frame.size.height-30, 150, 15)];
    lbl_zishucontent.text=@"还能输入140个字";
    lbl_zishucontent.enabled=NO;
    lbl_zishucontent.font=[UIFont systemFontOfSize:13];
    lbl_zishucontent.backgroundColor=[UIColor clearColor];
    [BackView_content addSubview:lbl_zishucontent];
    [self.view addSubview:BackView_content];
    UIView * BackView_goodList=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_content.frame.origin.y+BackView_content.frame.size.height+20, SCREEN_WIDTH, _goodsList.count*50)];
    UIView * lastView;
    if (_goodsList.count>0) {
        for (int i=0; i<_goodsList.count; i++) {
            lastView=[BackView_goodList.subviews lastObject];
            UIView *orderBackground=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, SCREEN_WIDTH,30)];
            lastView=[self.view.subviews lastObject];
            orderBackground.backgroundColor=[UIColor whiteColor];
            UILabel *itemName=[[UILabel alloc] initWithFrame:CGRectMake(15, 5, 150, 20)];
            itemName.text=_goodsList[i][@"goodsname"];
            [orderBackground addSubview:itemName];
            UILabel * itemnum=[[UILabel alloc] initWithFrame:CGRectMake(itemName.frame.origin.x+itemName.frame.size.width, 5, 40, 20)];
            itemnum.text=[NSString stringWithFormat:@"%@",_goodsList[i][@"count"]];
            [orderBackground addSubview:itemnum];
            UILabel * itemprice=[[UILabel alloc] initWithFrame:CGRectMake(orderBackground.frame.size.width-100, 5, 90, 20)];
            itemprice.text=[NSString stringWithFormat:@"¥%.2f",[_goodsList[i][@"price"] floatValue]];
            [orderBackground addSubview:itemprice];
            [BackView_goodList addSubview:orderBackground];
        }
        [self.view addSubview:BackView_goodList];
    }
    btn_Submit=[[UIButton alloc] initWithFrame:CGRectMake(40, BackView_goodList.frame.origin.y+BackView_goodList.frame.size.height+20, SCREEN_WIDTH-80, 30)];
    [btn_Submit setTitle:@"提交" forState:UIControlStateNormal];
    [btn_Submit setBackgroundColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0]];
    [btn_Submit addTarget:self action:@selector(SubmitFunction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_Submit];
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score{
    starScore = [NSString stringWithFormat:@"%0.2f",score * 10 ];
    [btn_Submit setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];
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
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)SubmitFunction
{
    if (_OrderInfo) {
        NSDictionary* prm=@{@"userid":_OrderInfo[@"userid"],@"resid":_OrderInfo[@"resid"],@"starnum":starScore,@"ordernum":_OrderInfo[@"ordernum"],@"content":txtV_PingjiaContent.text};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"SubmitBackCall:"];
        [dataprovider SubmitUserOrderPingjia:prm];
        [SVProgressHUD showWithStatus:@"正在提交" maskType:SVProgressHUDMaskTypeBlack];
    }
}
-(void)clickRightButton:(UIButton *)sender
{
    [txtV_PingjiaContent resignFirstResponder];
}
-(void)SubmitBackCall:(id)dict
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary* userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [SVProgressHUD dismiss];
    if ([dict[@"status"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:@"提交成功" maskType:SVProgressHUDMaskTypeBlack];
        if (userinfoWithFile[@"userid"]) {
            NSDictionary *prm=@{@"userid":userinfoWithFile[@"userid"],@"baguobi":[NSString stringWithFormat:@"%d",(int)_price*10]};
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"AddBGBiBackCall:"];
            [dataprovider AddBGbi:prm];

        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)AddBGBiBackCall:(id)dict
{
    NSLog(@"添加巴国币返回成功");
}

-(void)GetScoreForPingjia:(AMRatingControl *)sender
{
    starScore=[NSString stringWithFormat:@"%ld",(long)sender.rating];
}

@end
