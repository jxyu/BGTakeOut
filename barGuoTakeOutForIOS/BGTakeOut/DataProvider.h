//
//  DataProvider.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/15.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataProvider;

#define APIKey @"3ae841f9667a4d85ae3449855ac43617"

@interface DataProvider : NSObject
{
    id CallBackObject;
    NSString * callBackFunctionName;
}
@property(nonatomic,strong)NSData * data;
-(void)PostGetMsg;
-(void)GetJoke;
-(void)GetLipin;
-(void)GetArea:(NSString *) areaid andareatype:(NSString *)areatype;
-(void)GetrestaurantList:(NSDictionary *)pram;
-(void)GetActivityList;
-(void)GetBGBangText:(NSDictionary *)pram;
-(void)GetGiftList;
-(void)GetCantingCategory:(NSString *)resid;
-(void)GetGoodsinCategory:(NSString *)categoryid;
-(void)registerPerson:(NSString *)phone andPwd:(NSString *)pwd;
-(void)Login:(NSString *)phone andPwd:(NSString *)pwd;
-(void)UpLoadImage:(NSString *)imagePath;
-(void)ResetPwd:(NSString * )oldpwd andNewpwd:(NSString *)newpwd anduserid:(NSString *)userid;
-(void)ChangeNickName:(NSString *)name anduserid:(NSString *)userid;
-(void)GetWeather:(NSString *)city;
-(void)ChangeAvatar:(NSString *)avatarPath anduserid:(NSString *)userid;
-(void)GetUserInfoWithUserID:(NSString *)userid;
-(void)SubmitTousu:(NSString *)content anduserid:(NSString *)userid;
-(void)SubmitOrder:(id)prm;
-(void)GetCantingXiangqing:(NSString *)resid;
-(void)GetPinglun:(NSString *)resid andpage:(NSString *)page andnumInPage:(NSString *)num andiscontaintext:(NSString *)iscontaintext;
-(void)GetOrderInfoWithOrderNum:(NSString *)ordernum;
-(void)GetchargeForPay:(id)prm;
-(void)CancelOrderWithOrderNum:(NSString *)ordernum;
-(void)GetUserAddressListWithPage:(NSString *)page andnum:(NSString *)num anduserid:(NSString *)userid andisgetdefault:(NSString *)isgetdefault;
-(void)saveAddress:(id)prm;
-(void)EditAddress:(id)prm;

//执行回调函数
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;


@end
