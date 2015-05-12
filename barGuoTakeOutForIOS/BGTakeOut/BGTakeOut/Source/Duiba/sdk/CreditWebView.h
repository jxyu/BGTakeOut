//
//  CreditWebView.h
//  dui88-iOS-sdk
//
//  Created by xuhengfei on 14-6-13.
//  Copyright (c) 2014年 cpp. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CreditWebView : UIWebView<UIWebViewDelegate>
@property (nonatomic,assign) id<UIWebViewDelegate> webDelegate;

-(id)initWithFrame:(CGRect)frame andUrl:(NSString*)url;
@end


