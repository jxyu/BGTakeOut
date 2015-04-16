//
//  DataProvider.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/15.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchAPI.h>
@class DataProvider;

#define APIKey @"3ae841f9667a4d85ae3449855ac43617"

@interface DataProvider : NSObject <MAMapViewDelegate, AMapSearchDelegate>
@property(nonatomic,strong)MAMapView * mapView;
@property(nonatomic,strong)AMapSearchAPI * search;
@property(nonatomic,strong)CLLocation * location;
-(void)PostGetMsg:(NSString *)uri;
-(void)GetJoke;
-(void)GetLipin;

//获取当前位置
-(void)GetLocation;


@end
