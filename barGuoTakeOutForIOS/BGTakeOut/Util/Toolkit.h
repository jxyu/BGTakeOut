//
//  Toolkit.h
//  Blinq
//
//  Created by Sugar on 13-8-27.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Toolkit : NSObject

//+ (NSString *)getSystemLanguage;
//+ (void)setSystemLanguage:(NSString *)strLanguage;
 + (BOOL)isEnglishSysLanguage;
+ (BOOL)isSystemIOS7;
+(BOOL)isSystemIOS8;
// + (UIImage *)drawsimiLine:(UIImageView *)imageView;
//+ (void)setExtraCellLineHidden: (UITableView *)tableView; //隐藏多余的seperator

+ (NSString *)base64EncodedStringFrom:(NSData *)data;
@end
