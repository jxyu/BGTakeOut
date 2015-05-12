//
//  CreditWebViewController.h
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-5-16.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreditWebView.h"

@interface CreditWebViewController : UIViewController

@property(nonatomic,strong) NSString *needRefreshUrl;
-(id)initWithUrl:(NSString*)url;
-(id)initWithUrlByPresent:(NSString *)url;
-(id)initWithRequest:(NSURLRequest*)request;

@end
