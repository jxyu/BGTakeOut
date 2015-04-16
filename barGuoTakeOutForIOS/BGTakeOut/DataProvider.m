//
//  DataProvider.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/15.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "DataProvider.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"



@implementation DataProvider 


#pragma mark 获取轮播图片信息
-(void)PostGetMsg:(NSString *)uri
{
    NSString * str=uri;
    NSURL * url=[NSURL URLWithString:[str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation * httprequest=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httprequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSString * datastr= httprequest.responseString;
        NSData * data=httprequest.responseData;
        
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"返回数据：%@",dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"发生错误！%@",error);
    }];
    
    
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:httprequest];
}

#pragma mark 获取笑话信息
-(void)GetJoke{
//    NSString * xiaohua=[NSString stringWithFormat:@"http://121.42.139.60/baguo/dailyjokes.php"];
//    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
//    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
//    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
//    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];//可接收到的数据类型
//    
//    NSDictionary * prm=@{@"page":@"1",@"num":@"2"};
//    
//    [manage POST:xiaohua parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
////        NSDictionary * dict =responseObject;
//        NSString * str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
//        
//        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        for (int i=0; i<[dict[@"data"] count]; i++) {
//            NSLog(@"%@",dict[@"data"][i][@"content"]);
//        }
////        NSLog(@"Json:%@",dict[@"data"] );
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error:%@",error);
//    }];
    [self initMapView];
    [self initSearch];
}

-(void)GetLipin{
    NSString * xiaohua=[NSString stringWithFormat:@"http://121.42.139.60/baguo/gifts.php"];
    [self PostGetMsg:xiaohua];
}

-(void)GetLocation
{
    
}
-(void)initMapView
{
    [MAMapServices sharedServices].apiKey=APIKey;
    _mapView=[[MAMapView alloc] init];
    _mapView.delegate=self;
    _mapView.showsUserLocation=YES;
}

-(void)initSearch
{
    _search=[[AMapSearchAPI alloc] initWithSearchKey:APIKey Delegate:self];
}



-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    NSLog(@"userLocation: %@", userLocation.location);
    _location = [userLocation.location copy];

}



@end
