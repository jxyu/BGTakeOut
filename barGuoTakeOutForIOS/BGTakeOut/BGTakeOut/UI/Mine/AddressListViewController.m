//
//  AddressListViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/6/2.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "AddressListViewController.h"
#import "AddAddressViewController.h"
#import "CommenDef.h"
#import "AppDelegate.h"

@interface AddressListViewController ()
@property(nonatomic,strong)AddAddressViewController *myAddress;
@end

@implementation AddressListViewController
{
    NSArray *AddressArray;
    UIView *_page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBarTitle:@"收货地址"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    _page=[[UIView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _page.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:_page];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAll) name:@"refresh_Address" object:nil];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"Btn_AddressManagerBackCall:"];
    [dataprovider GetUserAddressListWithPage:@"1" andnum:@"16" anduserid:_userid andisgetdefault:@""];
}

-(void)refreshAll
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"Btn_AddressManagerBackCall:"];
    [dataprovider GetUserAddressListWithPage:@"1" andnum:@"16" anduserid:_userid andisgetdefault:@""];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)Btn_AddressManagerBackCall:(id)dict
{
    for (UIView *item in _page.subviews) {
        [item removeFromSuperview];
    }
    
    NSLog(@"获取收货地址：%@",dict);
    AddressArray=[[NSArray alloc] init];
    
    UIScrollView *scrollView_address=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-104)];
    scrollView_address.scrollEnabled=YES;
    
    if (1==[dict[@"status"] intValue]) {
        AddressArray=dict[@"data"];
        NSArray * addressArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        for (int i=0; i<addressArray.count; i++) {
            UIView * lastView=[scrollView_address.subviews lastObject];
            UIView * view_address=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+5, SCREEN_WIDTH, 100)];
            view_address.backgroundColor=[UIColor colorWithRed:94/255.0 green:107/255.0 blue:133/255.0 alpha:1.0];
            UILabel * lbl_name=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 50)];
            lbl_name.text=addressArray[i][@"realname"];
            lbl_name.font=[UIFont systemFontOfSize:14];
            lbl_name.textColor=[UIColor whiteColor];
            [view_address addSubview:lbl_name];
            UILabel * lbl_phoneNum=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-160, 10, 150, 20)];
            lbl_phoneNum.text=addressArray[i][@"phonenum"];
            lbl_phoneNum.textColor=[UIColor whiteColor];
            [view_address addSubview:lbl_phoneNum];
            UILabel * lbl_address=[[UILabel alloc]initWithFrame:CGRectMake(10, lbl_name.frame.origin.y+lbl_name.frame.size.height+5,SCREEN_WIDTH-50 , 50)];
            [lbl_address setLineBreakMode:NSLineBreakByWordWrapping];
            lbl_address.numberOfLines=0;
            lbl_address.text=[NSString stringWithFormat:@"%@%@",[addressArray[i][@"isdefault"] isEqual:@"1"]?@"［默认］":@"",addressArray[i][@"addressdetail"]];
            lbl_address.font=[UIFont systemFontOfSize:13];
            lbl_address.textColor=[UIColor whiteColor];
            [view_address addSubview:lbl_address];
            
            UIButton * Btn_zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-40, view_address.frame.size.height)];
            Btn_zhezhao.tag=i;
            [Btn_zhezhao addTarget:self action:@selector(CellClickFuc:) forControlEvents:UIControlEventTouchUpInside];
            [view_address addSubview:Btn_zhezhao];
            [scrollView_address addSubview:view_address];
            if ([addressArray[i][@"isdefault"] isEqual:@"1"]) {
                UIImageView * img_default=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 40, 20, 20)];
                img_default.image=[UIImage imageNamed:@"sure.png"];
                img_default.layer.masksToBounds=YES;
                img_default.layer.cornerRadius=10;
                img_default.layer.borderWidth=1;
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 1,1,1,1 });
                [img_default.layer setBorderColor:colorref];
                [view_address addSubview:img_default];
            }
            UIButton * btn_SetDefault=[[UIButton alloc] initWithFrame:CGRectMake(Btn_zhezhao.frame.size.width, 0, 40, view_address.frame.size.height)];
            [btn_SetDefault addTarget:self action:@selector(SetDefaultAddress:) forControlEvents:UIControlEventTouchUpInside];
            btn_SetDefault.tag=i;
            [view_address addSubview:btn_SetDefault];
        }
        
        
    }
    UIView * lastView=[scrollView_address.subviews lastObject];
    [scrollView_address setContentSize:CGSizeMake(0, lastView.frame.origin.y+lastView.frame.size.height)];
    [_page addSubview:scrollView_address];
    
    
    UIView * BackView_addAddres=[[UIView alloc] initWithFrame:CGRectMake(0, _page.frame.size.height-40, SCREEN_WIDTH, 40)];
    BackView_addAddres.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    UIButton * btn_addAddress=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, 5, 100, 30)];
    btn_addAddress.layer.masksToBounds=YES;
    btn_addAddress.layer.cornerRadius=10;
    btn_addAddress.titleLabel.font=[UIFont systemFontOfSize:15];
    
    
    [btn_addAddress setTitle:@"添加地址" forState:UIControlStateNormal];
    [btn_addAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_addAddress.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
    [btn_addAddress addTarget:self action:@selector(btn_addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [BackView_addAddres addSubview:btn_addAddress];
    [_page addSubview:BackView_addAddres];
}
-(void)btn_addAddressClick
{
    
    self.myAddress=[[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:[NSBundle mainBundle]];
    _myAddress.userid=_userid;
    [self.navigationController pushViewController:_myAddress animated:YES];
}

-(void)CellClickFuc:(UIButton * )sender
{
    NSLog(@"%ld",(long)sender.tag);
    if (!_isSelect) {
        self.myAddress=[[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:[NSBundle mainBundle]];
        _myAddress.userid=_userid;
        _myAddress.dict=AddressArray[sender.tag];
        [self.navigationController pushViewController:_myAddress animated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"select_address" object:AddressArray[sender.tag]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
-(void)SetDefaultAddress:(UIButton *)sender
{
    NSMutableDictionary* prm=[[NSMutableDictionary alloc] initWithDictionary:AddressArray[sender.tag]];
    [prm setObject:@"1" forKey:@"isdefault"];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"SetDefautaddressBackCall:"];
    [dataprovider EditAddress:prm];
}
-(void)SetDefautaddressBackCall:(id)dict
{
    NSLog(@"设置默认地址%@",dict);
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"Btn_AddressManagerBackCall:"];
    [dataprovider GetUserAddressListWithPage:@"1" andnum:@"16" anduserid:_userid andisgetdefault:@""];;
}



@end
