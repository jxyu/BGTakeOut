//
//  AppDelegate.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "AppDelegate.h"
#import "DataProvider.h"
#define appKey @"6d6636b9d200"
#define appSecret @"04507a9ebfb819fedcb19e598d8be0f1"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [SMS_SDK registerApp:appKey withSecret:appSecret];
    _tabBarViewCol = [[CustomTabBarViewController alloc] init];
    self.window.rootViewController=_tabBarViewCol;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)changeRootView
{
    self.window.rootViewController=_tabBarViewCol;
}


- (void)showTabBar
{
    [_tabBarViewCol showTabBar];
}
- (void)hiddenTabBar
{
    [_tabBarViewCol hideCustomTabBar];
}
-(CustomTabBarViewController *)getTabBar
{
    return _tabBarViewCol;
}


-(void)PostGetMsg
{
    DataProvider *dataProvider=[[DataProvider alloc] init];
    
    [dataProvider PostGetMsg];
}

-(void)GetJoke
{
    DataProvider *dataProvider=[[DataProvider alloc] init];
    
    [dataProvider GetJoke];
}

-(void)GetLipin
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetLipin];
}
-(void)GetArea:(NSString *) areaid andareatype:(NSString *)areatype
{
    DataProvider * dataprovider = [[DataProvider alloc] init];
    [dataprovider GetArea:areaid andareatype:areatype];
}

-(void)GetrestaurantList:(NSDictionary *)pram
{
    DataProvider * dataprovider = [[DataProvider alloc] init];
    [dataprovider GetrestaurantList:pram];
}

-(void)GetActivityList
{
    DataProvider * dataprovider = [[DataProvider alloc] init];
    [dataprovider GetActivityList];
}
-(void)GetBGBangText:(NSDictionary *)pram
{
    DataProvider * dataprovider = [[DataProvider alloc] init];
    [dataprovider GetBGBangText:pram];
}

-(void)GetGiftList
{
    DataProvider * dataprovider = [[DataProvider alloc] init];
    [dataprovider GetGiftList];
}

-(void)GetCantingCategory:(NSString *)resid;
{
    DataProvider * dataprovider = [[DataProvider alloc] init];
    [dataprovider GetCantingCategory:resid];
}

-(void)GetGoodsinCategory:(NSString *)categoryid
{
    DataProvider * dataprovider = [[DataProvider alloc] init];
    [dataprovider GetGoodsinCategory:categoryid];
}

-(void)registerPerson:(NSString *)phone andPwd:(NSString *)pwd
{
    DataProvider *dataprovider=[[DataProvider alloc] init];
    [dataprovider registerPerson:phone andPwd:pwd];
}

-(void)Login:(NSString *)phone andPwd:(NSString *)pwd
{
    DataProvider *dataprovider=[[DataProvider alloc] init];
    [dataprovider Login:phone andPwd:pwd];
}
-(void)UpLoadImage:(NSString *)imagePath
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider UpLoadImage:imagePath];
}

-(void)ResetPwd:(NSString * )oldpwd andNewpwd:(NSString *)newpwd anduserid:(NSString *)userid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider ResetPwd:oldpwd andNewpwd:newpwd anduserid:userid];
}

-(void)ChangeNickName:(NSString *)name anduserid:(NSString *)userid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider ChangeNickName:name anduserid:userid];
}

-(void)GetWeather:(NSString *)city
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetWeather:city];
}
-(void)ChangeAvatar:(NSString *)avatarPath anduserid:(NSString *)userid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider ChangeAvatar:avatarPath anduserid:userid];
}
-(void)GetUserInfoWithUserID:(NSString *)userid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetUserInfoWithUserID:userid];
}
-(void)SubmitTousu:(NSString *)content anduserid:(NSString *)userid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider SubmitTousu:content anduserid:userid];
}
-(void)SubmitOrder:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider SubmitOrder:prm];
}

-(void)GetCantingXiangqing:(NSString *)resid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetCantingXiangqing:resid];
}
-(void)GetPinglun:(NSString *)resid andpage:(NSString *)page andnumInPage:(NSString *)num andiscontaintext:(NSString *)iscontaintext
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetPinglun:resid andpage:page andnumInPage:num andiscontaintext:iscontaintext];
}
-(void)GetchargeForPay:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetchargeForPay:prm];
}

-(void)GetOrderInfoWithOrderNum:(NSString *)ordernum
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetOrderInfoWithOrderNum:ordernum];
}
-(void)CancelOrderWithOrderNum:(NSString *)ordernum
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider CancelOrderWithOrderNum:ordernum];
}

-(void)GetUserAddressListWithPage:(NSString *)page andnum:(NSString *)num anduserid:(NSString *)userid andisgetdefault:(NSString *)isgetdefault
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetUserAddressListWithPage:page andnum:num anduserid:userid andisgetdefault:isgetdefault];
}
-(void)saveAddress:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider saveAddress:prm];
}
@end
