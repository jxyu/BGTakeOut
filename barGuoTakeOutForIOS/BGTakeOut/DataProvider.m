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
#import "AFURLRequestSerialization.h"
#define KURL @"http://121.42.139.60/baguo/"



@implementation DataProvider
{
    NSString * str;
}

#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

#pragma mark 获取轮播图片信息
-(void)PostGetMsg
{
    NSString * uri=[NSString stringWithFormat:@"%@indexAds.php",KURL];
    NSURL * url=[NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation * httprequest=[[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httprequest setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSString * datastr= httprequest.responseString;
        _data=httprequest.responseData;
        id dict =[NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
        //执行回调操作
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"获取轮播图片回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"获取轮播图片回调失败...");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"获取轮播图片发生错误！%@",error);
    }];
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:httprequest];
}

#pragma mark 获取笑话信息
-(void)GetJoke:(NSString *)page andnum:(NSString *)num
{
    NSString * xiaohua=[NSString stringWithFormat:@"%@dailyjokes.php",KURL];
    NSDictionary * prm=@{@"page":page,@"num":num};
    [self PostRequest:xiaohua andpram:prm];
}

#pragma mark 获取礼品列表
-(void)GetLipin{
    NSString * lipin=[NSString stringWithFormat:@"%@gifts.php",KURL];
    NSDictionary * prm=@{@"page":@"1",@"num":@"2"};
    [self PostRequest:lipin andpram:prm];
    //    NSLog(@"%@",str);
    
    
}

#pragma mark 获取城市列表
-(void)GetArea:(NSString *) areaid andareatype:(NSString *)areatype
{
    NSString * url=[NSString stringWithFormat:@"%@getaddress.php",KURL];
    NSDictionary * prm =@{@"areaid":areaid,@"type":areatype};
    [self PostRequest:url andpram:prm];
    
}

#pragma mark 获取餐厅活动列表
-(void)GetActivityList
{
    NSString * url=[NSString stringWithFormat:@"%@getactivites.php",KURL];
    NSDictionary * prm=@{@"page":@"1",@"num":@"2"};
    [self PostRequest:url andpram:prm];
}

#pragma mark 获取餐厅列表
-(void)GetrestaurantList:(NSDictionary *)pram
{
    NSString * url=[NSString stringWithFormat:@"%@server/Home/Node/api_getRestaurants",KURL];
    NSDictionary * prm =pram;
    [self PostRequest:url andpram:prm];
}

-(void)GetBGBangText:(NSDictionary *)pram
{
    NSString * url=[NSString stringWithFormat:@"%@server/Home/Rank/api_getBaguoRank",KURL];
    NSDictionary * prm =pram;
    [self PostRequest:url andpram:prm];
}

-(void)GetGiftList
{
    NSString * url=[NSString stringWithFormat:@"%@gifts.php",KURL];
    NSDictionary * prm=@{@"page":@"1",@"num":@"6"};
    [self PostRequest:url andpram:prm];
}

-(void)GetCantingCategory:(NSString *)resid
{
    NSString * url=[NSString stringWithFormat:@"%@getgoodscat.php",KURL];
    NSDictionary * prm=@{@"resid":resid};
    [self PostRequest:url andpram:prm];
}

-(void)GetGoodsinCategory:(NSString *)categoryid
{
    NSString * url=[NSString stringWithFormat:@"%@getgoods.php",KURL];
    NSDictionary * prm=@{@"catid":categoryid};
    [self PostRequest:url andpram:prm];
}

-(void)registerPerson:(NSString *)phone andPwd:(NSString *)pwd
{
    if (phone!=nil &&pwd!=nil) {
        NSString * url=[NSString stringWithFormat:@"%@register.php",KURL];
        NSDictionary * prm=@{@"phonenum":phone,@"password":pwd};
        [self PostRequest:url andpram:prm];
    }
}

-(void)Login:(NSString *)phone andPwd:(NSString *)pwd
{
    if (phone!=nil &&pwd!=nil) {
        NSString * url=[NSString stringWithFormat:@"%@login.php",KURL];
        NSDictionary * prm=@{@"phonenum":phone,@"password":pwd};
        [self PostRequest:url andpram:prm];
    }
}

-(void)UpLoadImage:(NSString *)imagePath
{
    if (imagePath) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/Upload/uploadImage",KURL];
        [self uploadImageWithImage:imagePath andurl:url];
    }
}

-(void)ResetPwd:(NSString * )oldpwd andNewpwd:(NSString *)newpwd anduserid:(NSString *)userid
{
    if (oldpwd!=nil &&newpwd!=nil&&userid) {
        NSString * url=[NSString stringWithFormat:@"%@resetpwd.php",KURL];
        NSDictionary * prm=@{@"userid":userid,@"oldpwd":oldpwd,@"newpwd":newpwd};
        [self PostRequest:url andpram:prm];
    }
}

-(void)ChangeNickName:(NSString *)name anduserid:(NSString *)userid
{
    if (name && userid) {
        NSString * url=[NSString stringWithFormat:@"%@edituserinfo.php",KURL];
        NSDictionary * prm=@{@"userid":userid,@"nickname":name};
        [self PostRequest:url andpram:prm];
    }
}
-(void)ChangeAvatar:(NSString *)avatarPath anduserid:(NSString *)userid
{
    if (avatarPath && userid) {
        NSString * url=[NSString stringWithFormat:@"%@edituserinfo.php",KURL];
        NSDictionary * prm=@{@"userid":userid,@"avatar":avatarPath};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetWeather:(NSString *)city
{
    NSString * url=[NSString stringWithFormat:@"http://apistore.baidu.com/microservice/weather?citypinyin=%@",city];
    [self PostRequest:url andpram:nil];
}
-(void)GetUserInfoWithUserID:(NSString *)userid
{
    if (userid) {
        NSString * url=[NSString stringWithFormat:@"%@getuserinfo.php",KURL];
        NSDictionary * prm=@{@"userid":userid};
        [self PostRequest:url andpram:prm];
    }
}

-(void)SubmitTousu:(NSString *)content anduserid:(NSString *)userid
{
    if (userid&&content) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/User/api_lodgeComplaint",KURL];
        NSDictionary * prm=@{@"userid":userid,@"content":content};
        [self PostRequest:url andpram:prm];
    }
}

-(void)SubmitOrder:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/Order/api_commitOrder",KURL];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetCantingXiangqing:(NSString *)resid anduserid:(NSString *)userid
{
    if (resid) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/Node/getResDetail",KURL];
        NSDictionary * prm=@{@"resid":resid,@"userid":userid};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetPinglun:(NSString *)resid andpage:(NSString *)page andnumInPage:(NSString *)num andiscontaintext:(NSString *)iscontaintext
{
    if (resid&&page&&num) {
        NSString * url=[NSString stringWithFormat:@"%@getcomments.php",KURL];
        NSDictionary * prm=@{@"resid":resid,@"page":page,@"num":num,@"iscontaintext":iscontaintext};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetchargeForPay:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@ping++/pay.php",KURL];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetOrderInfoWithOrderNum:(NSString *)ordernum
{
    if (ordernum) {
        NSString * url=[NSString stringWithFormat:@"%@getorderdetail.php",KURL];
        NSDictionary * prm=@{@"ordernum":ordernum};
        [self PostRequest:url andpram:prm];
    }
}

-(void)CancelOrderWithOrderNum:(NSString *)ordernum
{
    if (ordernum) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/Order/api_cancelOrder",KURL];
        NSDictionary * prm=@{@"ordernum":ordernum};
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetUserAddressListWithPage:(NSString *)page andnum:(NSString *)num anduserid:(NSString *)userid andisgetdefault:(NSString *)isgetdefault
{
    if (page&&num&&userid&&isgetdefault) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/User/api_getaddress",KURL];
        NSDictionary * prm=@{@"page":page,@"num":num,@"userid":userid,@"isgetdefault":isgetdefault};
        [self PostRequest:url andpram:prm];
    }
}

-(void)saveAddress:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@addaddress.php",KURL];
        [self PostRequest:url andpram:prm];
    }
}



-(void)getduibaurlForDetailWithAppkey:(NSString*)appkey appsecret:(NSString*)appsecret userid:(NSString*) userid url:(NSString*)url{
    NSString * redirect_url=[NSString stringWithFormat:@"%@server/Home/User/api_getduibaurlfordetail",KURL];
    NSDictionary * prm=@{@"appkey":appkey,@"appsecret":appsecret,@"userid":userid,@"url":url};
    [self PostRequest:redirect_url andpram:prm];
    
}
/**
 *  获得兑吧自动登录url
 *
 *  @param appkey    appkey
 *  @param appsecret appsecret
 *  @param userid    用户id
 */
-(void)getduibaurlWithAppkey:(NSString*)appkey appsecret:(NSString*)appsecret userid:(NSString*)userid{
    if (appkey&&appsecret&&userid) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/User/api_getduibaurl",KURL];
        NSDictionary * prm=@{@"appkey":appkey,@"appsecret":appsecret,@"userid":userid};
        [self PostRequest:url andpram:prm];
    }
    
    
}
-(void)commitdevicetokenWithUserid:(NSString*)userid token:(NSString*)token{
    if(userid&&token){
        NSString * url=[NSString stringWithFormat:@"%@commitdevicetoken.php",KURL];
        NSDictionary * prm=@{@"userid":userid,@"token":token};
        [self PostRequest:url andpram:prm];
    }
};
-(void)EditAddress:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@changeaddress.php",KURL];
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetOrdersList:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@getorders.php",KURL];
        [self PostRequest:url andpram:prm];
    }
}
#pragma mark 添加或者删除收藏
-(void)AddOrDelcollection:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@addcollection.php",KURL];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetAllCollection:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@getcollections.php",KURL];
        [self PostRequest:url andpram:prm];
    }
}

-(void)chengpinInfo
{
    NSString * url=[NSString stringWithFormat:@"%@server/Home/My/apiget_employdetail",KURL];
    [self PostRequest:url andpram:nil];
}
-(void)chengpinSubmit:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/User/api_Employ",KURL];
        [self PostRequest:url andpram:prm];
    }
}

-(void)GetZhaoShangInfo
{
    NSString * url=[NSString stringWithFormat:@"%@server/Home/My/apiget_zhaoshangdetail",KURL];
    [self PostRequest:url andpram:nil];
}
-(void)zhaoshangSubmit:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/User/api_ZhaoShang",KURL];
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetBGBangDetialWith:(NSString * )articleid
{
    if (articleid) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/Rank/api_getBaguoRankDetail",KURL];
        NSDictionary * prm=@{@"articleid":articleid};
        [self PostRequest:url andpram:prm];
    }
}
-(void)GetBGBangTypewithtype:(NSString *)type andupid :(NSString *)upid
{
    if (type&&upid) {
        NSString * url=[NSString stringWithFormat:@"%@getbaguorankcate.php",KURL];
        NSDictionary * prm=@{@"type":type,@"upid":upid};
        [self PostRequest:url andpram:prm];
    }
}

-(void)SubmitUserOrderPingjia:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/Order/api_commitComment",KURL];
        [self PostRequest:url andpram:prm];
    }
}
-(void)SubmitBGBangPingjia:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/Rank/api_commitBaguoRanComment",KURL];
        [self PostRequest:url andpram:prm];
    }
}

-(void)BGBangDianzanFuncWithuserid:(NSString *)userid andartid:(NSString *)articleid
{
    if (userid&&articleid) {
        NSString * url=[NSString stringWithFormat:@"%@getbaguorankcate.php",KURL];
        NSDictionary * prm=@{@"userid":userid,@"articleid":articleid};
        [self PostRequest:url andpram:prm];
    }
}
-(void)BGBangXintuijian:(id)prm
{
    if (prm) {
        NSString * url=[NSString stringWithFormat:@"%@server/Home/Rank/ai_getNewRank",KURL];
        [self PostRequest:url andpram:prm];
    }
}

-(void)PostRequest:(NSString *)url andpram:(NSDictionary *)pram
{
    AFHTTPRequestOperationManager * manage=[[AFHTTPRequestOperationManager alloc] init];
    manage.responseSerializer=[AFHTTPResponseSerializer serializer];
    manage.requestSerializer=[AFHTTPRequestSerializer serializer];
    manage.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];//可接收到的数据类型
    manage.requestSerializer.timeoutInterval=10;//设置请求时限
    NSDictionary * prm =[[NSDictionary alloc] init];
    if (pram!=nil) {
        prm=pram;
    }
    [manage POST:url parameters:prm success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSDictionary * dict =responseObject;
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
    }];
    
}

- (void)uploadImageWithImage:(NSString *)imagePath andurl:(NSString *)url
{
    NSData *data=[NSData dataWithContentsOfFile:imagePath];
    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:data name:@"image" fileName:@"avatar.png" mimeType:@"image/png"];
    }];
    
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData * data =[str dataUsingEncoding:NSUTF8StringEncoding];
        id dict =[NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        SEL func_selector = NSSelectorFromString(callBackFunctionName);
        if ([CallBackObject respondsToSelector:func_selector]) {
            NSLog(@"回调成功...");
            [CallBackObject performSelector:func_selector withObject:dict];
        }else{
            NSLog(@"回调失败...");
        }
        NSLog(@"上传完成");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传失败->%@", error);
    }];
    
    //执行
    NSOperationQueue * queue =[[NSOperationQueue alloc] init];
    [queue addOperation:op];
    
}

#pragma mark 获得餐厅评价
-(void)getCommentsWihtPage:(NSInteger)page num:(NSInteger)num resid:(NSInteger)resid iscontaintext:(NSInteger)isText{
    NSDictionary* param=@{@"page":    [NSString stringWithFormat:@"%ld",page],@"num":    [NSString stringWithFormat:@"%ld",num],@"resid":    [NSString stringWithFormat:@"%ld",resid],@"iscontaintext":    [NSString stringWithFormat:@"%ld",isText]};
    NSString * url=[NSString stringWithFormat:@"%@getcomments.php",KURL];
    [self PostRequest:url andpram:param];
}
#pragma mark 获得订单详情
-(void)getOrderDetailWithOrdernum:(NSString*)ordernum {
    NSDictionary* param=@{@"ordernum":ordernum };
    NSString * url=[NSString stringWithFormat:@"%@getorderdetail.php",KURL];
    [self PostRequest:url andpram:param];
}
@end

