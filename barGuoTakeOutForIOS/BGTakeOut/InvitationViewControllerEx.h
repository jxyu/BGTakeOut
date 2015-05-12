//
//  InvitationViewControllerEx.h
//  SMS_SDKDemo
//
//  Created by 中扬科技 on 14-7-15.
//  Copyright (c) 2014年 中扬科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvitationViewControllerEx : UIViewController<UITableViewDataSource,UITableViewDelegate>

-(void)setData:(NSString*)name;
-(void)setPhone:(NSString *)phone AndPhone2:(NSString*)phone2;

@end
