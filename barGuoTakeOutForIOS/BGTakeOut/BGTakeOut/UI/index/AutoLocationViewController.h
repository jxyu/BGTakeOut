//
//  AutoLocationViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/20.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"

@interface AutoLocationViewController : BaseNavigationController
{
    id CallBackObject;
    NSString * callBackFunctionName;
}

- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName;

@end
