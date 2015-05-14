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

@interface BGBangDetialViewController ()

@end

@implementation BGBangDetialViewController
{
    UIScrollView * ScrollView_page;
    UIView * page;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"巴国榜文章详情"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    page=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-20)];
    page.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:page];
    ScrollView_page=[[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-20-35)];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetBGBangDetialBackCall:"];
    [dataprovider GetBGBangDetialWith:_articleid];
}

-(void)GetBGBangDetialBackCall:(id)dict
{
    NSLog(@"%@",dict);
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
