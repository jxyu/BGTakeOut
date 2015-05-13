//
//  LoginViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/4.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface LoginViewController : BaseNavigationController
{
    id CallBackObject;
    NSString * callBackFunctionName;
}

//执行回调函数
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@end
