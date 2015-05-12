//
//  UserInfoViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/5.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoViewController : UIViewController
{
    id CallBackObject;
    NSString * callBackFunctionName;
}

//执行回调函数
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@property(nonatomic,copy)id UserInfoData;

@end
