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
-(void)dellongHistory:(NSString * )historyid;
-(void)GetLocHistory:(NSString *)userid;
-(void)submitLocHistory:(NSString *)userid andlocation:(NSString *)location;
-(void)ClearLocHistory:(NSString *)userid;
-(void)PostGetMsg;
-(void)GetJoke:(NSString *)page andnum:(NSString *)num;
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
-(void)GetCantingXiangqing:(NSString *)resid anduserid:(NSString *)userid;
-(void)GetPinglun:(NSString *)resid andpage:(NSString *)page andnumInPage:(NSString *)num andiscontaintext:(NSString *)iscontaintext;
-(void)GetOrderInfoWithOrderNum:(NSString *)ordernum;
-(void)GetchargeForPay:(id)prm;
-(void)CancelOrderWithOrderNum:(NSString *)ordernum;
-(void)GetUserAddressListWithPage:(NSString *)page andnum:(NSString *)num anduserid:(NSString *)userid andisgetdefault:(NSString *)isgetdefault;
-(void)saveAddress:(id)prm;
-(void)EditAddress:(id)prm;
-(void)GetOrdersList:(id)prm;
-(void)AddOrDelcollection:(id)prm;
-(void)GetAllCollection:(id)prm;
-(void)chengpinInfo;
-(void)chengpinSubmit:(id)prm;
-(void)GetZhaoShangInfo;
-(void)zhaoshangSubmit:(id)prm;
-(void)GetBGBangDetialWith:(NSString * )articleid;
-(void)GetBGBangTypewithtype:(NSString *)type andupid :(NSString *)upid;

-(void)SubmitUserOrderPingjia:(id)prm;
-(void)SubmitBGBangPingjia:(id)prm;
-(void)BGBangDianzanFuncWithuserid:(NSString *)userid andartid:(NSString *)articleid;
-(void)BGBangXintuijian:(id)prm;
-(void)AddBGbi:(id)prm;
-(void)GetOrderPrice:(id)prm;
-(void)OrderReciver:(NSString *)ordernum;
-(void)IsLuckDay:(NSString *)userid;
-(void)GetLuckGift:(NSString *)userid;
-(void)CheckIsPhoneExist:(NSString *)phone;
-(void)GetSomeInfonWithType:(NSString *)type;

/**
 *  获得兑吧详情页
 *
 *  @param appkey    兑吧appkey
 *  @param appsecret 兑吧appsecret
 *  @param userid    用户id
 *  @param url       需跳转页面
 */
-(void)getduibaurlForDetailWithAppkey:(NSString*)appkey appsecret:(NSString*)appsecret userid:(NSString*) userid url:(NSString*)url;
/**
 *  获得兑吧自动登录url
 *
 *  @param appkey    appkey
 *  @param appsecret appsecret
 *  @param userid    用户id
 */
-(void)getduibaurlWithAppkey:(NSString*)appkey appsecret:(NSString*)appsecret userid:(NSString*)userid;
/**
 *  提交当前用户的devicetoken
 *
 *  @param userid 当前用户的id
 *  @param token  用户的token
 */
-(void)commitdevicetokenWithUserid:(NSString*)userid token:(NSString*)token;

/**
 *  获得餐厅评论
 *
 *  @param page   页数
 *  @param num    每页的条数
 *  @param resid  餐厅id
 *  @param isText 是否包含内容的评论，0代表全部，1代表有内容
 */
-(void)getCommentsWihtPage:(NSInteger)page num:(NSInteger)num resid:(NSInteger)resid iscontaintext:(NSInteger)isText;
/**
 *  获得订单详情
 *
 *  @param ordernum 订单号
 
 返回值说明：status:代表订单状态
 
 0->提交订单，等待付款
 1->付款完成，等待餐厅接单
 2->餐厅接单完成
 3->买家确认收货,交易成功
 4->正在配送
 
 7->未付款,订单取消，交易关闭
 8->已付款，订单取消，等待退款
 9->退款成功，交易关闭
 10->已付款，订单取消，等待卖家审核
 */
-(void)getOrderDetailWithOrdernum:(NSString*)ordernum ;
/**
 *  获得巴国榜推荐的分类列表
 *
 *  @param type type:0为一级目录，1位二级目录，2位三级目录，必填
 *  @param upid 上一级目录的id,int,必填；
 */
-(void)getBaguoRankCateWithType:(NSString*)type upid:(NSString*)upid;
/**
 *  巴国榜-我要推荐
 *
 *  @param username  用户名
 *  @param resname   餐厅名
 *  @param adr       餐厅地址
 *  @param contact   联系方式
 *  @param resdetail 详情
 *  @param img1      推荐图片1
 *  @param img2      推荐图片2
 *  @param img3      推荐图片3
 *  @param img4      推荐图片4
 *  @param oneid     所属一级分类id
 *  @param twoid     所属二级分类id
 *  @param threeid   所属三级分类id
 */
-(void)commitRecommendWithusername:(NSString*)username resname:(NSString*)resname resaddress:(NSString*)adr contacts:(NSString*)contact resdetail:(NSString*)resdetail img1:(NSString*)img1 img2:(NSString*)img2 img3:(NSString*)img3 img4:(NSString*)img4 oneid:(NSString*)oneid twoid:(NSString*)twoid threeid:(NSString*)threeid;
/**
 *  获得餐厅相册
 *
 *  @param resid 餐厅id
 */
-(void)getResAlbumWithResid:(NSString*)resid;

//执行回调函数
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

-(void)PostRequest:(NSString *)url andpram:(NSDictionary *)pram;
- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url;

@end
