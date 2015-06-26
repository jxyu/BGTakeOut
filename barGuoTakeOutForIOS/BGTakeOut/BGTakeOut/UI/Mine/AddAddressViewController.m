//
//  AddAddressViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/12.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "AddAddressViewController.h"
#import "DataProvider.h"
#import "CommenDef.h"
#import "AppDelegate.h"

@interface AddAddressViewController ()


@end

@implementation AddAddressViewController
{
    float ScreenWidth;
    float ScreenHeight;
    UITextField * txt_name;
    UITextField * txt_phonenum;
    UITextField * txt_youbian;
    UITextField * txt_area;
    UITextField * txt_address;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    ScreenHeight=[UIScreen mainScreen].bounds.size.height;
    ScreenWidth=[UIScreen mainScreen].bounds.size.width;
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self setBarTitle:@"收货地址"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    if (_dict) {
        [self addRightbuttontitle:@"修改"];
        UIView * BackView_name=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, ScreenWidth, 40)];
        BackView_name.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_nameTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_nameTitle.text=@"收货人";
        [lbl_nameTitle setTextColor:[UIColor grayColor]];
        [BackView_name addSubview:lbl_nameTitle];
        txt_name=[[UITextField alloc] initWithFrame:CGRectMake(lbl_nameTitle.frame.origin.x+lbl_nameTitle.frame.size.width+10, 10, ScreenWidth-110, 20)];
        txt_name.text=_dict[@"realname"]==[NSNull null]?@"":_dict[@"realname"];
        [txt_name setKeyboardType:UIKeyboardTypeDefault];
        [BackView_name addSubview:txt_name];
        [self.view addSubview:BackView_name];
        
        UIView * BackView_phoneNum=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_name.frame.size.height+BackView_name.frame.origin.y+1, ScreenWidth, 40)];
        BackView_phoneNum.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_phoneNumTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_phoneNumTitle.text=@"手机号码";
        [lbl_phoneNumTitle setTextColor:[UIColor grayColor]];
        [BackView_phoneNum addSubview:lbl_phoneNumTitle];
        txt_phonenum=[[UITextField alloc] initWithFrame:CGRectMake(lbl_phoneNumTitle.frame.origin.x+lbl_phoneNumTitle.frame.size.width+10, 10, ScreenWidth-110, 20)];
        txt_phonenum.text=_dict[@"phonenum"]==[NSNull null]?@"":_dict[@"phonenum"];
        [txt_phonenum setKeyboardType:UIKeyboardTypeNumberPad];
        [BackView_phoneNum addSubview:txt_phonenum];
        [self.view addSubview:BackView_phoneNum];
        
        UIView * BackView_youbian=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_phoneNum.frame.size.height+BackView_phoneNum.frame.origin.y+1, ScreenWidth, 40)];
        BackView_youbian.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_youbianTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_youbianTitle.text=@"邮政编码";
        [lbl_youbianTitle setTextColor:[UIColor grayColor]];
        [BackView_youbian addSubview:lbl_youbianTitle];
        txt_youbian=[[UITextField alloc] initWithFrame:CGRectMake(lbl_youbianTitle.frame.origin.x+lbl_youbianTitle.frame.size.width+10, 10, ScreenWidth-110, 20)];
        txt_youbian.text=_dict[@"postcode"]==[NSNull null]?@"":_dict[@"postcode"];
        [txt_youbian setKeyboardType:UIKeyboardTypeNumberPad];
        [BackView_youbian addSubview:txt_youbian];
        [self.view addSubview:BackView_youbian];
        
        UIView * BackView_Area=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_youbian.frame.size.height+BackView_youbian.frame.origin.y+1, ScreenWidth, 40)];
        BackView_Area.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_areaTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_areaTitle.text=@"所在地区";
        [lbl_areaTitle setTextColor:[UIColor grayColor]];
        [BackView_Area addSubview:lbl_areaTitle];
        txt_area=[[UITextField alloc] initWithFrame:CGRectMake(lbl_areaTitle.frame.origin.x+lbl_areaTitle.frame.size.width, 10, ScreenWidth-110, 20)];
        txt_area.text=_dict[@"address"]==[NSNull null]?@"":_dict[@"address"];
        [txt_area setKeyboardType:UIKeyboardTypeDefault];
        [BackView_Area addSubview:txt_area];
        [self.view addSubview:BackView_Area];
        
        UIView * BackView_address=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_Area.frame.size.height+BackView_Area.frame.origin.y+1, ScreenWidth, 40)];
        BackView_address.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_addressTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_addressTitle.text=@"详细地址";
        [lbl_addressTitle setTextColor:[UIColor grayColor]];
        [BackView_address addSubview:lbl_addressTitle];
        txt_address=[[UITextField alloc] initWithFrame:CGRectMake(lbl_addressTitle.frame.origin.x+lbl_addressTitle.frame.size.width, 10, ScreenWidth-110, 20)];
        txt_address.text=_dict[@"addressdetail"]==[NSNull null]?@"":_dict[@"addressdetail"];
        [txt_address setKeyboardType:UIKeyboardTypeDefault];
        [BackView_address addSubview:txt_address];
        [self.view addSubview:BackView_address];
        
        
        UIView * BackView_del=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_address.frame.size.height+BackView_address.frame.origin.y+20, ScreenWidth, 40)];
        BackView_del.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_delTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        lbl_delTitle.text=@"删除收货地址";
        [lbl_delTitle setTextColor:[UIColor redColor]];
        [BackView_del addSubview:lbl_delTitle];
        UIButton * btn_del=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, BackView_del.frame.size.width, BackView_del.frame.size.height)];
        [btn_del addTarget:self action:@selector(delBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [BackView_del addSubview:btn_del];
        [self.view addSubview:BackView_del];
        
    }
    else
    {
        [self addRightbuttontitle:@"保存"];
        UIView * BackView_name=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, ScreenWidth, 40)];
        BackView_name.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_nameTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_nameTitle.text=@"收货人";
        [lbl_nameTitle setTextColor:[UIColor grayColor]];
        [BackView_name addSubview:lbl_nameTitle];
        txt_name=[[UITextField alloc] initWithFrame:CGRectMake(lbl_nameTitle.frame.origin.x+lbl_nameTitle.frame.size.width+10, 10, ScreenWidth-110, 20)];
        txt_name.placeholder=@"请输入姓名";
        [txt_name setKeyboardType:UIKeyboardTypeDefault];
        [BackView_name addSubview:txt_name];
        [self.view addSubview:BackView_name];
        
        UIView * BackView_phoneNum=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_name.frame.size.height+BackView_name.frame.origin.y+1, ScreenWidth, 40)];
        BackView_phoneNum.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_phoneNumTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_phoneNumTitle.text=@"手机号码";
        [lbl_phoneNumTitle setTextColor:[UIColor grayColor]];
        [BackView_phoneNum addSubview:lbl_phoneNumTitle];
        txt_phonenum=[[UITextField alloc] initWithFrame:CGRectMake(lbl_phoneNumTitle.frame.origin.x+lbl_phoneNumTitle.frame.size.width+10, 10, ScreenWidth-110, 20)];
        txt_phonenum.placeholder=@"请输入手机号";
        [txt_phonenum setKeyboardType:UIKeyboardTypeNumberPad];
        [BackView_phoneNum addSubview:txt_phonenum];
        [self.view addSubview:BackView_phoneNum];
        
        UIView * BackView_youbian=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_phoneNum.frame.size.height+BackView_phoneNum.frame.origin.y+1, ScreenWidth, 40)];
        BackView_youbian.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_youbianTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_youbianTitle.text=@"邮政编码";
        [lbl_youbianTitle setTextColor:[UIColor grayColor]];
        [BackView_youbian addSubview:lbl_youbianTitle];
        txt_youbian=[[UITextField alloc] initWithFrame:CGRectMake(lbl_youbianTitle.frame.origin.x+lbl_youbianTitle.frame.size.width+10, 10, ScreenWidth-110, 20)];
        txt_youbian.placeholder=@"请输入邮编";
        [txt_youbian setKeyboardType:UIKeyboardTypeNumberPad];
        [BackView_youbian addSubview:txt_youbian];
        [self.view addSubview:BackView_youbian];
        
        UIView * BackView_Area=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_youbian.frame.size.height+BackView_youbian.frame.origin.y+1, ScreenWidth, 40)];
        BackView_Area.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_areaTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_areaTitle.text=@"所在地区";
        [lbl_areaTitle setTextColor:[UIColor grayColor]];
        [BackView_Area addSubview:lbl_areaTitle];
        txt_area=[[UITextField alloc] initWithFrame:CGRectMake(lbl_areaTitle.frame.origin.x+lbl_areaTitle.frame.size.width, 10, ScreenWidth-110, 20)];
        txt_area.placeholder=@"请输入所在地区";
        [txt_area setKeyboardType:UIKeyboardTypeDefault];
        [BackView_Area addSubview:txt_area];
        [self.view addSubview:BackView_Area];
        
        UIView * BackView_address=[[UIView alloc] initWithFrame:CGRectMake(0, BackView_Area.frame.size.height+BackView_Area.frame.origin.y+1, ScreenWidth, 40)];
        BackView_address.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_addressTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        lbl_addressTitle.text=@"详细地址";
        [lbl_addressTitle setTextColor:[UIColor grayColor]];
        [BackView_address addSubview:lbl_addressTitle];
        txt_address=[[UITextField alloc] initWithFrame:CGRectMake(lbl_addressTitle.frame.origin.x+lbl_addressTitle.frame.size.width, 10, ScreenWidth-110, 20)];
        txt_address.placeholder=@"请输入地址";
        [txt_address setKeyboardType:UIKeyboardTypeDefault];
        [BackView_address addSubview:txt_address];
        [self.view addSubview:BackView_address];
    }
    
    //    UIView * BackView_name=[[UIView alloc] initWithFrame:CGRectMake(0, navigationBarsub.frame.size.height, ScreenWidth, 40)];
    //    BackView_name.backgroundColor=[UIColor whiteColor];
    //    UILabel * lbl_nameTitle=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    //    lbl_nameTitle.text=@"收货人";
    //    [lbl_nameTitle setTextColor:[UIColor grayColor]];
    //    [BackView_name addSubview:lbl_nameTitle];
    //    UITextField * txt_name=[[UITextField alloc] initWithFrame:CGRectMake(lbl_nameTitle.frame.origin.x+lbl_nameTitle.frame.size.width, 10, 100, 20)];
    //    txt_name.placeholder=[@"请输入姓名"];
    //    [txt_name setKeyboardType:UIKeyboardTypeDefault];
    //    [BackView_name addSubview:txt_name];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)delBtnClick:(UIButton *)sender
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"delAddressBackCall:"];
    [dataprovider delAddress:_dict[@"addid"]];
    
}

-(void)delAddressBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_Address" object:nil];
    }
}

-(void)clickRightButton:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"保存中.." maskType:SVProgressHUDMaskTypeBlack];
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
    [dict setObject:_userid forKey:@"userid"];
    if (txt_name.text) {
        [dict setObject:txt_name.text forKey:@"realname"];
        if (txt_phonenum.text) {
            [dict setObject:txt_phonenum.text forKey:@"phonenum"];
            if (txt_youbian.text) {
                [dict setObject:txt_youbian.text forKey:@"postcode"];
                if (txt_area.text) {
                    [dict setObject:txt_area.text forKey:@"address"];
                    if (txt_address.text) {
                        [dict setObject:txt_address.text forKey:@"addressdetail"];
                        
                        if (_dict) {
                            [dict setObject:_dict[@"isdefault"] forKey:@"isdefault"];
                            [dict setObject:_dict[@"addid"] forKey:@"addid"];
                            DataProvider *dataprovider=[[DataProvider alloc] init];
                            [dataprovider setDelegateObject:self setBackFunctionName:@"SaveAddressBackCall:"];
                            [dataprovider EditAddress:dict];
                        }
                        else
                        {
                            DataProvider *dataprovider=[[DataProvider alloc] init];
                            [dataprovider setDelegateObject:self setBackFunctionName:@"SaveAddressBackCall:"];
                            [dataprovider saveAddress:dict];
                        }
                        
                    }
                    else
                    {
                        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                                      message:NSLocalizedString(@"请填写详细地址", nil)
                                                                     delegate:self
                                                            cancelButtonTitle:@"确定"
                                                            otherButtonTitles:nil, nil];
                        [alert show];
                    }
                }
                else
                {
                    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                                  message:NSLocalizedString(@"请填写地区", nil)
                                                                 delegate:self
                                                        cancelButtonTitle:@"确定"
                                                        otherButtonTitles:nil, nil];
                    [alert show];
                }
            }
            else
            {
                UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                              message:NSLocalizedString(@"请填写手机号", nil)
                                                             delegate:self
                                                    cancelButtonTitle:@"确定"
                                                    otherButtonTitles:nil, nil];
                [alert show];
            }
        }
        else
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                          message:NSLocalizedString(@"请填写手机号", nil)
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                      message:NSLocalizedString(@"请填写姓名", nil)
                                                     delegate:self
                                            cancelButtonTitle:@"确定"
                                            otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)SaveAddressBackCall:(id)dict
{
    NSLog(@"保存收货地址%@",dict);
    if (1==[dict[@"status"] intValue]) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh_Address" object:nil];
    }
    [SVProgressHUD dismiss];
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
