//
//  ViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "ViewController.h"
#import "AFHTTPRequestOperation.h"
#import "DataProvider.h"
#import <CoreLocation/CoreLocation.h>
#import "CCLocationManager.h"
#import "RegViewController.h"
#import <SMS_SDK/SMS_SDK.h>
#import "IndexViewController.h"

#define IS_IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)

@interface ViewController ()
@property(nonatomic,strong)IndexViewController * indexview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    获取当前的经纬度
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        NSLog(@"%f %f",locationCorrrdinate.latitude,locationCorrrdinate.longitude);
    }];
//    CCLocationManager * locationmanager= [[CCLocationManager alloc] init];
    [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
        NSLog(@"%@",addressString);
    }];
    self.indexview=[[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:[NSBundle mainBundle]];
    UIView *itemview=_indexview.view;
    
    [self.view addSubview:itemview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)GetImg:(UIButton *)sender {
    DataProvider *dataProvider=[[DataProvider alloc] init];
    
    [dataProvider PostGetMsg];
}

- (IBAction)GetJoke:(UIButton *)sender {
    DataProvider * dataProvider =[[DataProvider alloc] init];
    
    [dataProvider GetJoke];
}

- (IBAction)GetLiPin:(UIButton *)sender {

//    DataProvider * dataProvider =[[DataProvider alloc] init];
//    
//    [dataProvider GetLipin];
    
    RegViewController* reg=[[RegViewController alloc] init];
    [self presentViewController:reg animated:YES completion:^{
        
    }];

}

- (IBAction)GetArea:(UIButton *)sender {
    DataProvider * dataProvider =[[DataProvider alloc] init];
    
    [dataProvider GetArea:@"" andareatype:@"0"];
}

- (IBAction)LoadIndex:(UIButton *)sender {
    self.indexview=[[IndexViewController alloc] initWithNibName:@"IndexViewController" bundle:[NSBundle mainBundle]];
    UIView *itemview=_indexview.view;
    
    [self.view addSubview:itemview];
    
}
@end
