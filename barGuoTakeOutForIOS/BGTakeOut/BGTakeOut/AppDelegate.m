//
//  AppDelegate.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "AppDelegate.h"
#import "DataProvider.h"
#import "UMSocial.h"
#import "UMessage.h"
#define appKey @"6d6636b9d200"
#define appSecret @"04507a9ebfb819fedcb19e598d8be0f1"

#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000
@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - app's lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [SMS_SDK registerApp:appKey withSecret:appSecret];//设置短信appkey
    
    [UMSocialData setAppKey:umeng_app_key];//设置友盟appkey
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:umeng_app_key launchOptions:launchOptions];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
    if(UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0"))
    {
        //register remoteNotification types
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    } else{
        //register remoteNotification types
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
#else
    
    //register remoteNotification types
    [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
     |UIRemoteNotificationTypeSound
     |UIRemoteNotificationTypeAlert];
    
#endif
    
    //for log
    [UMessage setLogEnabled:YES];
    
    /**
     设置显示的根视图
     
     :returns: 0
     */
        firstCol=[[FirstScrollController alloc]init];
    _tabBarViewCol = [[CustomTabBarViewController alloc] init];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds] ];
    if ([get_sp(@"FIRST_ENTER")isEqualToString:@"1"]) {
        self.window.rootViewController =_tabBarViewCol;
    }
    else
    {
        self.window.rootViewController =firstCol;
    }
    
    [self.window makeKeyAndVisible];
    //[self getAliPay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeRootView) name:@"changeRootView" object:nil];

    [self.window makeKeyAndVisible];
    return YES;
}

#pragma mark - 推送和第三方分享

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [UMessage registerDeviceToken:deviceToken];

    NSString* stringDeviceToken=    [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    set_sp(stringDeviceToken, @"devicetoken");
    //TODO: 是否已经登录，登录使用userid和devicetoken绑定调用推送接口，没有登录不进行绑定，在登陆后绑定
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary* userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userinfoWithFile){
        //!!!:  已经登录完成，
        DataProvider* dataProvider=[[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"commitSuccess"];
        [dataProvider commitdevicetokenWithUserid:userinfoWithFile[@"userid"] token:stringDeviceToken];
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
    }
    
}
-(void)commitSuccess:(id)dict{
    DLog(@"commitUser-device token:%@",dict);
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    //关闭友盟自带的弹出框
    //        [UMessage setAutoAlert:YES];
    
    DLog(@"remote:%@",userInfo);
    [UMessage didReceiveRemoteNotification:userInfo];
    NSString* content=[[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    //        self.userInfo = userInfo;
    //定制自定的的弹出框
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:content
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        
    }
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
#pragma mark - 自定义tabbarVC的相关方法
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

#pragma mark - 放在单例delegate中的接口方法

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

-(void)GetCantingXiangqing:(NSString *)resid anduserid:(NSString *)userid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetCantingXiangqing:resid anduserid:userid];
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
-(void)EditAddress:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider EditAddress:prm];
}

-(void)GetOrdersList:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetOrdersList:prm];
}
-(void)AddOrDelcollection:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider AddOrDelcollection:prm];
}
-(void)GetAllCollection:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetAllCollection:prm];
}
-(void)chengpinInfo
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider chengpinInfo];
}
-(void)chengpinSubmit:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider chengpinSubmit:prm];
}
-(void)GetZhaoShangInfo
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetZhaoShangInfo];
}
-(void)zhaoshangSubmit:(id)prm
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider zhaoshangSubmit:prm];
}
-(void)GetBGBangDetialWith:(NSString * )articleid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetBGBangDetialWith:articleid];
}
-(void)GetBGBangTypewithtype:(NSString *)type andupid :(NSString *)upid
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider GetBGBangTypewithtype:type andupid:upid];
}


@end
