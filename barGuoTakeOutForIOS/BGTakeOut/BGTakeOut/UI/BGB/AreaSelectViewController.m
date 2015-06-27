//
//  AreaSelectViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/6/27.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "AreaSelectViewController.h"
#import "DataProvider.h"
#import "WantRecommendViewController.h"


#define KAreaListHeight 50

@interface AreaSelectViewController ()

@end

@implementation AreaSelectViewController
{
    NSString * province;//省份
    NSString *provinceid;//省份id
    NSString * city;//市
    NSString *cityid;//市id
    NSString *district;//县区
    NSString * districtid;//县区ID
    NSString * street;//街道
    NSString * streetid;//街道ID
    NSString * userid;
    NSArray *itemArray;
    UIScrollView * CityareaScroll;
    UIScrollView * ThirdareaScroll;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"所属区域";
    [self addLeftButton:@"ic_actionbar_back.png"];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self LoadAllData];
}

-(void)LoadAllData
{
    DataProvider * dataprovider=[DataProvider alloc];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetAllAreaBackCall:"];
    [dataprovider GetAllArea:@"" andareatype:@"0"];
}


-(void)GetAllAreaBackCall:(id)dict
{
        UIScrollView * areaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH/3, SCREEN_HEIGHT-65)];
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
    [self.view addSubview:areaScroll];
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
        switch (str.length) {
            case 6:
                [CityareaScroll removeFromSuperview];
                [ThirdareaScroll removeFromSuperview];
                province=[NSString stringWithFormat:@"%@",sender.currentTitle];
                provinceid=str;
                [dataProvider setDelegateObject:self setBackFunctionName:@"SecondBulidAreaList:"];
                [dataProvider GetAllArea:str andareatype:@"1"];
                break;
            case 9:
                city=[NSString stringWithFormat:@"%@",sender.currentTitle];
                cityid=str;
                [dataProvider setDelegateObject:self setBackFunctionName:@"ThridBulidAreaList:"];
                [dataProvider GetAllArea:str andareatype:@"2"];
                break;
            default:
                break;
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
        CityareaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 65, SCREEN_WIDTH/3, SCREEN_HEIGHT-65)];
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
        [self.view addSubview:CityareaScroll];
        
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
        ThirdareaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 65, SCREEN_WIDTH/3, SCREEN_HEIGHT-65)];
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
        [self.view addSubview:ThirdareaScroll];
    }
    @catch (NSException *exception) {
        NSLog(@"定位页面，创建县区列表%@",exception);
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
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WantRecommendViewController class]]) {
            WantRecommendViewController*want=(WantRecommendViewController*)temp;
            want.privateid=provinceid;
            want.privatetitle=province;
            want.cityid=cityid;
            want.citytitle=city;
            want.xianquid=districtid;
            want.xianqutitle=district;
            [self.navigationController popToViewController:want animated:YES];
        }
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
