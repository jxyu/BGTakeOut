//
//  UserInfoViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/5.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAddressViewController.h"
#import "BaseNavigationController.h"
#import "AddressListViewController.h"

@interface UserInfoViewController : BaseNavigationController
{
    id CallBackObject;
    NSString * callBackFunctionName;
}

//执行回调函数
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@property(nonatomic,copy)id UserInfoData;
@property(nonatomic,strong)AddAddressViewController * myAddress;
@property(nonatomic,strong)AddressListViewController * myaddressList;
@end
