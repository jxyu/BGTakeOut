//
//  UIImage+NSBundle.m
//  Blinq
//
//  Created by user on 13-9-2.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "UIImage+NSBundle.h"

@implementation UIImage (NSBundle)

+ (UIImage *)imageWithBundleName:(NSString *)strImage
{
    NSString *strPath = [[NSBundle mainBundle] pathForResource:strImage ofType:nil];
    return [UIImage imageWithContentsOfFile:strPath];
}

@end
