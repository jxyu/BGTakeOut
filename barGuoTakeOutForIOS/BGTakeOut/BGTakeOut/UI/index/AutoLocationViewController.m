//
//  AutoLocationViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/20.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "AutoLocationViewController.h"
#import "CCLocationManager.h"
#import "DataProvider.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "LoginViewController.h"


#define KAreaListHeight 50
#define KAreaListY 121
#define Kleft self.view.bounds.size.width/8
#define KScrollHeight 300

@interface AutoLocationViewController ()
@property (nonatomic,strong)UIButton * autoLocation;
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property(nonatomic ,strong)UIButton * sender;
@property(nonatomic,strong)UIButton * selectArea;//手动选择地区
@property(nonatomic,strong)UIView * SelectView;
@property(nonatomic,strong)LoginViewController *loginVC;

@end

@implementation AutoLocationViewController
{
    UIImageView * image_left;
    UIImageView * image_right;
    NSString * province;//省份
    NSString *provinceid;//省份id
    NSString * city;//市
    NSString *cityid;//市id
    NSString *district;//县区
    NSString * districtid;//县区ID
    NSString * street;//街道
    NSString * streetid;//街道ID
    NSString * userid;
    UIScrollView * historyScrollView;
    NSArray *itemArray;
    BOOL IsareaListShow;
    UIScrollView * CityareaScroll;
    UIScrollView * ThirdareaScroll;
    UIScrollView * StreetScroll;
    NSDictionary* userinfoWithFile;
}

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    itemArray=[[NSArray alloc] init];
    IsareaListShow=NO;
    // Do any additional setup after loading the view from its nib.
    [self myinitView];
}

-(void)myinitView
{
    userid=@"";
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if (userinfoWithFile[@"userid"]) {
        userid=userinfoWithFile[@"userid"];
        //添加导航栏
        [self setBarTitle:@"自动定位"];
        [self addLeftButton:@"ic_actionbar_back.png"];
        image_left=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, _lblTitle.frame.origin.y+13, 13, 15)];
        image_left.tag=1111;
        image_left.image=[UIImage imageNamed:@"index_location"];
//        [self.view addSubview:image_left];
        image_right=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+35, _lblTitle.frame.origin.y+18, 12, 7)];
        image_right.tag=1112;
        image_right.image=[UIImage imageNamed:@"index_down"];
        [self.view addSubview:image_right];
        //    for (UIView *items in self.navigationController.view.subviews) {
        //        if ([items isKindOfClass:[UIImageView class]]) {
        //            UIImageView * item=(UIImageView *)items;
        //            if (item.tag==1111||item.tag==1112) {
        //                [item removeFromSuperview];
        //            }
        //        }
        //    }
#pragma mark 添加手动切换按钮
        UIView * lastObject=[self.view.subviews lastObject];
        CGFloat y=lastObject.frame.size.height;
        CGFloat h=60*SCREEN_HEIGHT/568;
        _selectArea=[[UIButton alloc] initWithFrame:CGRectMake(0,NavigationBar_HEIGHT+20 , SCREEN_WIDTH, h)];
        _selectArea.backgroundColor=[UIColor whiteColor];
        _selectArea.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
        [_selectArea setTitle:@"    手动切换省 市 区 街道" forState:UIControlStateNormal];
        [_selectArea setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_selectArea addTarget:self action:@selector(GetAreaList) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_selectArea];
        
        //    #pragma mark 添加手动输入送餐地址按钮//2015-5－20鲁森说这个不要了
        //    lastObject=[self.view.subviews lastObject];
        //    y=lastObject.frame.size.height+lastObject.frame.origin.y+1;
        //    UIButton * selectAreaPsn=[[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth, h)];
        //    selectAreaPsn.backgroundColor=[UIColor whiteColor];
        //    selectAreaPsn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
        //    [selectAreaPsn setTitle:@"    详细送餐地址" forState:UIControlStateNormal];
        //    [selectAreaPsn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //    [self.view addSubview:selectAreaPsn];
        
#pragma mark添加切换地址
        lastObject=[self.view.subviews lastObject];
        y=lastObject.frame.size.height+lastObject.frame.origin.y+1;
        UIView * backgroundview =[[UIView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
        backgroundview.backgroundColor=[UIColor whiteColor];
        UIButton * changeAdress=[[UIButton alloc] initWithFrame:CGRectMake(15, 10, SCREEN_WIDTH-30, 40)];
        changeAdress.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
        changeAdress.layer.masksToBounds=YES;
        changeAdress.layer.cornerRadius=6;
        [changeAdress setTitle:@"切换地址" forState:UIControlStateNormal];
        [changeAdress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [changeAdress addTarget:self action:@selector(changeAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [backgroundview addSubview:changeAdress];
        [self.view addSubview:backgroundview];
        
#pragma mark添加自动定位按钮
        lastObject=[self.view.subviews lastObject];
        y=lastObject.frame.size.height+lastObject.frame.origin.y+5;
        _autoLocation=[[UIButton alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h)];
        _autoLocation.backgroundColor=[UIColor whiteColor];
        [_autoLocation setImage:[UIImage imageNamed:@"Image-3"] forState:UIControlStateNormal];
        _autoLocation.imageEdgeInsets=UIEdgeInsetsMake(0, 15, 0, 280);
        _autoLocation.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
        [_autoLocation setTitle:@"      自动定位" forState:UIControlStateNormal];
        [_autoLocation setTitleColor:[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_autoLocation addTarget:self action:@selector(AutoGetLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_autoLocation];
        
#pragma mark 添加历史纪录按钮
        lastObject=[self.view.subviews lastObject];
        y=lastObject.frame.size.height+lastObject.frame.origin.y+5;
        UIButton * historyLocation=[[UIButton alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, h-10)];
        historyLocation.backgroundColor=[UIColor whiteColor];
        historyLocation.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft ;
        [historyLocation setTitle:@"  历史地址" forState:UIControlStateNormal];
        [historyLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:historyLocation];
        lastObject=[self.view.subviews lastObject];
        y=lastObject.frame.size.height+lastObject.frame.origin.y+5;
        historyScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-y-5)];
        historyScrollView.scrollEnabled=YES;
        historyScrollView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetLocHistoryBackCall:"];
        [dataprovider GetLocHistory:userinfoWithFile[@"userid"]];
    }
    else
    {
        _loginVC=[[LoginViewController alloc] init];
        [_loginVC setDelegateObject:self setBackFunctionName:@"loginVCBackCall"];
        [self.navigationController pushViewController:_loginVC animated:YES];
    }
    
}
-(void)loginVCBackCall
{
    [self myinitView];
}

-(void)GetLocHistoryBackCall:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        for (UIView *item in historyScrollView.subviews) {
            [item removeFromSuperview];
        }
        itemArray=dict[@"data"];
        for (int i=0; i<itemArray.count; i++) {
            UIView *lastview=[historyScrollView.subviews lastObject];
            UIView * itemBackView=[[UIView alloc] initWithFrame:CGRectMake(0, lastview.frame.origin.y+lastview.frame.size.height+1, historyScrollView.frame.size.width, 40)];
            itemBackView.backgroundColor=[UIColor whiteColor];
            UIImageView * img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 18)];
            img_icon.image=[UIImage imageNamed:@"ic_location_gray"];
            [itemBackView addSubview:img_icon];
            UILabel * lbl_locationTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_icon.frame.origin.x+img_icon.frame.size.width+10, 10, SCREEN_WIDTH-100, 20)];
            lbl_locationTitle.textColor=[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0];
            lbl_locationTitle.text=itemArray[i][@"location"];
            [itemBackView addSubview:lbl_locationTitle];
            
            UIButton * btn_del=[[UIButton alloc] initWithFrame:CGRectMake(lbl_locationTitle.frame.origin.x+lbl_locationTitle.frame.size.width+25, 10, 20, 20)];
            btn_del.tag=[itemArray[i][@"id"] intValue];
            [btn_del setImage:[UIImage imageNamed:@"delHistory"] forState:UIControlStateNormal];
            [btn_del addTarget:self action:@selector(delHistoryAddress:) forControlEvents:UIControlEventTouchUpInside];
            [itemBackView addSubview:btn_del];
            [historyScrollView addSubview:itemBackView];
        }
        UIView * lastview=[historyScrollView.subviews lastObject];
        UIView * clearhistory=[[UIView alloc] initWithFrame:CGRectMake(0, lastview.frame.origin.y+lastview.frame.size.height+1, historyScrollView.frame.size.width, 40)];
        clearhistory.backgroundColor=[UIColor whiteColor];
        UIButton * btn_delAll=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, clearhistory.frame.size.width, 40)];
        [btn_delAll setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [btn_delAll addTarget:self action:@selector(delAllHistory) forControlEvents:UIControlEventTouchUpInside];
        [btn_delAll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [clearhistory addSubview:btn_delAll];
        [historyScrollView addSubview:clearhistory];
        lastview=[historyScrollView.subviews lastObject];
        historyScrollView.contentSize=CGSizeMake(0, lastview.frame.origin.y+lastview.frame.size.height+5);
        [self.view addSubview:historyScrollView];
    }
}
/**
 *  清空所有历史记录
 */
-(void)delAllHistory
{
    [historyScrollView removeFromSuperview];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"ClearAllHistoryBackCall:"];
    [dataprovider ClearLocHistory:userid];
}

-(void)ClearAllHistoryBackCall:(id)dict
{
    NSLog(@"%@",dict);
}

/**
 *  删除单个历史记录
 *
 *  @param sender <#sender description#>
 */
-(void)delHistoryAddress:(UIButton *)sender
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"dellongHistory:"];
    [dataprovider dellongHistory:[NSString stringWithFormat:@"%ld",(long)sender.tag]];
}

-(void)dellongHistory:(id)dict
{
    NSLog(@"%@",dict);
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetLocHistoryBackCall:"];
    [dataprovider GetLocHistory:userid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}
#pragma mark 自动定位
-(void)AutoGetLocation
{
    [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
        NSLog(@"%@",addressString);
        [self setBarTitle:[addressString stringByReplacingOccurrencesOfString:@"(null)" withString:@""]] ;
        image_left.frame=CGRectMake(_lblTitle.frame.origin.x-12, image_left.frame.origin.y, 13, 15);
        image_right.frame=CGRectMake(image_left.frame.origin.x+130, image_right.frame.origin.y, 12, 7);
        NSDictionary * dict=[[NSDictionary alloc] init];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AreaInfo.plist"];
        BOOL result= [dict writeToFile:plistPath atomically:YES];
        if (result) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"changecity_success" object:nil];
        }
    }];
}

#pragma mark 获取数据
-(void)GetAreaList
{
    _SelectView =[[UIView alloc] initWithFrame:CGRectMake(0, KAreaListY, SCREEN_WIDTH, SCREEN_HEIGHT-KAreaListY)];
    DataProvider * dataProvider =[[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"BulidAreaList:"];
    [dataProvider GetArea:@"" andareatype:@"0"];
   
}
#pragma mark 新建地区选择view
-(void)BulidAreaList:(id)dict
{
    
    if (!IsareaListShow) {
        UIScrollView * areaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/3, _SelectView.frame.size.height)];
        areaScroll.scrollEnabled=YES;
        areaScroll.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        id result =dict;
        if (result) {
            NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
            for (int i=0; i<areaArray.count; i++) {
                UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, i*(KAreaListHeight+1), SCREEN_WIDTH/3, KAreaListHeight)];
                areaitem.backgroundColor=[UIColor whiteColor];
                [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"provincename"]] forState:UIControlStateNormal];
                areaitem.tag=[areaArray[i][@"provinceid"] intValue];
                [areaitem addTarget:self action:@selector(AreaItemClick:) forControlEvents:UIControlEventTouchUpInside];
                [areaScroll addSubview:areaitem];
            }
            areaScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+5));
        }
        [_SelectView addSubview:areaScroll];
        [self.view addSubview:_SelectView];
        IsareaListShow=YES;
    }
    else
    {
        [_SelectView removeFromSuperview];
        IsareaListShow=NO;
    }
    
}

#pragma mark 选择省份事件
-(void)AreaItemClick:(UIButton *)sender
{
    @try {
        NSArray * superarray= sender.superview.subviews;
        for (UIView * item in superarray) {
            if ([item isKindOfClass:[UIButton class]]) {
                UIButton * items=(UIButton *)item;
                if(item.tag!=sender.tag)
                {
                    item.backgroundColor=sender.backgroundColor;
                    [items setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }
        sender.backgroundColor=[UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
        [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        DataProvider * dataProvider =[[DataProvider alloc] init];
        NSString * str=[NSString stringWithFormat:@"00%ld",(long)sender.tag];
        NSRange loaction= [sender.currentTitle rangeOfString:@"全国"];
        if (loaction.length>0) {
            province=[NSString stringWithFormat:@"%@",sender.currentTitle];
            provinceid=str;
            [self SubmitquanguoData];
        }
        else
        {
            NSRange r= [sender.currentTitle rangeOfString:@"全省"];
            switch (str.length) {
                case 6:
                    [CityareaScroll removeFromSuperview];
                    [ThirdareaScroll removeFromSuperview];
                    [StreetScroll removeFromSuperview];
                    province=[NSString stringWithFormat:@"%@",sender.currentTitle];
                    provinceid=str;
                    [dataProvider setDelegateObject:self setBackFunctionName:@"SecondBulidAreaList:"];
                    [dataProvider GetArea:str andareatype:@"1"];
                    break;
                case 9:
                    city=[NSString stringWithFormat:@"%@",sender.currentTitle];
                    cityid=str;
                    [dataProvider setDelegateObject:self setBackFunctionName:@"ThridBulidAreaList:"];
                    [dataProvider GetArea:str andareatype:@"2"];
                    break;
                default:
                    if (r.length>0) {
                        city=[NSString stringWithFormat:@"%@",sender.currentTitle];
                        cityid=str;
                        [self SubmitAllData];
                    }
                    break;
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"定位页面%@",exception);
    }
    @finally {
        
    }
}

#pragma mark 创建市列表
-(void)SecondBulidAreaList:(id)dict
{
    @try {
        CityareaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, _SelectView.frame.size.height)];
        CityareaScroll.scrollEnabled=YES;
        CityareaScroll.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        id result =dict;
        if (result) {
            NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
            for (int i=0; i<areaArray.count; i++) {
                UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, i*(KAreaListHeight+1), SCREEN_WIDTH/3, KAreaListHeight)];
                areaitem.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
                [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"cityname"]] forState:UIControlStateNormal];
                areaitem.tag=[areaArray[i][@"cityid"] intValue];
                [areaitem addTarget:self action:@selector(AreaItemClick:) forControlEvents:UIControlEventTouchUpInside];
                [CityareaScroll addSubview:areaitem];
            }
            CityareaScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+1));
        }
        [_SelectView addSubview:CityareaScroll];

    }
    @catch (NSException *exception) {
        NSLog(@"定位页，创建城市列表%@",exception);
    }
    @finally {
        
    }
    
}

#pragma mark 创建县区列表
-(void)ThridBulidAreaList:(id)dict
{
    @try {
        ThirdareaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 0, SCREEN_WIDTH/3, KScrollHeight)];
        ThirdareaScroll.scrollEnabled=YES;
        ThirdareaScroll.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        id result =dict;
        if (result) {
            NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
            for (int i=0; i<areaArray.count; i++) {
                UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, i*(KAreaListHeight+1), SCREEN_WIDTH/3, KAreaListHeight)];
                areaitem.backgroundColor=[UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
                [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"districtname"]] forState:UIControlStateNormal];
                areaitem.tag=[areaArray[i][@"districtid"] intValue];
                [areaitem addTarget:self action:@selector(submitAreaClick:) forControlEvents:UIControlEventTouchUpInside];
                [ThirdareaScroll addSubview:areaitem];
            }
            ThirdareaScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+1));
        }
        [_SelectView addSubview:ThirdareaScroll];
    }
    @catch (NSException *exception) {
        NSLog(@"定位页面，创建县区列表%@",exception);
    }
    @finally {
        
    }
    
}

-(void)GetStreetBackcall:(id)dict
{
    NSLog(@"%@",dict);
    @try {
        StreetScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/5*3, 0, SCREEN_WIDTH/5*2, _SelectView.frame.size.height)];
        StreetScroll.scrollEnabled=YES;
        StreetScroll.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        id result =dict;
        if (result) {
            NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
            for (int i=0; i<areaArray.count; i++) {
                UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, i*(KAreaListHeight+1), SCREEN_WIDTH/5*2, KAreaListHeight)];
                areaitem.backgroundColor=[UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
                [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"streetname"]] forState:UIControlStateNormal];
                areaitem.tag=[areaArray[i][@"streetid"] intValue];
                [areaitem addTarget:self action:@selector(submitAreaClick:) forControlEvents:UIControlEventTouchUpInside];
                [StreetScroll addSubview:areaitem];
            }
            StreetScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+1));
        }
        [_SelectView addSubview:StreetScroll];
        
    }
    @catch (NSException *exception) {
        NSLog(@"定位页，街道列表%@",exception);
    }
    @finally {
        
    }
}

#pragma mark 提交选定的地区
-(void)submitAreaClick:(UIButton *)sender
{
//    street=sender.currentTitle;
//    streetid=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    NSString * str=[NSString stringWithFormat:@"00%ld",(long)sender.tag];
    district= sender.currentTitle;
    districtid=str;
    NSString *lastArea=[NSString stringWithFormat:@"%@%@%@",province,city,sender.currentTitle];
    [_selectArea setTitle:lastArea forState:UIControlStateNormal];
    _selectArea.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_SelectView removeFromSuperview];
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"submitBackCall:"];
    [dataprovider submitLocHistory:userid andlocation:lastArea];
}

-(void)SubmitquanguoData
{
    NSString *lastArea=[NSString stringWithFormat:@"%@",province];
    [_selectArea setTitle:lastArea forState:UIControlStateNormal];
    _selectArea.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_SelectView removeFromSuperview];
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"submitBackCall:"];
    [dataprovider submitLocHistory:userid andlocation:lastArea];
}
-(void)SubmitAllData
{
    NSString *lastArea=[NSString stringWithFormat:@"%@%@",province,city];
    [_selectArea setTitle:lastArea forState:UIControlStateNormal];
    _selectArea.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_SelectView removeFromSuperview];
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"submitBackCall:"];
    [dataprovider submitLocHistory:userid andlocation:lastArea];
}
-(void)submitBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetLocHistoryBackCall:"];
        [dataprovider GetLocHistory:userinfoWithFile[@"userid"]];
    }
}

-(void)changeAddressButtonClick
{
    if (province&&city&&district) {
        NSString *lastArea=[NSString stringWithFormat:@"%@%@%@",province,city,district];
        NSDictionary * areadict=@{@"area":lastArea};
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelectorInBackground:func_selector withObject:areadict];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSLog(@"回调失败...");
        }
        NSDictionary * dict=@{@"provinceid":provinceid,@"provinceTitle":province,@"cityid":cityid,@"cityTitle":city,@"districtid":districtid,@"districtTitle":district};
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AreaInfo.plist"];
        BOOL result= [dict writeToFile:plistPath atomically:YES];
        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changecity_success" object:nil];
        }
    }
    else if (province&&city)
    {
        NSString *lastArea=[NSString stringWithFormat:@"%@%@",province,city];
        NSDictionary * areadict=@{@"area":lastArea};
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelectorInBackground:func_selector withObject:areadict];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            NSLog(@"回调失败...");
        }
        NSDictionary * dict=@{@"provinceid":provinceid,@"provinceTitle":province,@"cityid":cityid,@"cityTitle":city};
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AreaInfo.plist"];
        BOOL result= [dict writeToFile:plistPath atomically:YES];
        if (result) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changecity_success" object:nil];
        }

    }
    else
    {
        if (provinceid&&province) {
            NSString *lastArea=[NSString stringWithFormat:@"%@",province];
            NSDictionary * areadict=@{@"area":lastArea};
            SEL func_selector = NSSelectorFromString(callBackFunctionName);
            if ([CallBackObject respondsToSelector:func_selector]) {
                NSLog(@"回调成功...");
                [CallBackObject performSelectorInBackground:func_selector withObject:areadict];
                [self.navigationController popToRootViewControllerAnimated:YES];
            }else{
                NSLog(@"回调失败...");
            }
            NSDictionary * dict=@{@"provinceid":provinceid,@"provinceTitle":province};
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                      NSUserDomainMask, YES) objectAtIndex:0];
            NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AreaInfo.plist"];
            BOOL result= [dict writeToFile:plistPath atomically:YES];
            if (result) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changecity_success" object:nil];
            }
        }
        else
        {
            UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择地区或者自动定位" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
        }
    }
}
@end
