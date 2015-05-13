//
//  BaseNavigationController.h
//  Blinq
//
//  Created by user on 13-9-2.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//


/*
通用的UINavigationBar
    
Useage:
 
把当前的viewController 继承 BaseNavigationController
 
 */
#import <UIKit/UIKit.h>
#import "Toolkit.h"

#import "Dialog.h"

@interface BaseNavigationController : UIViewController
{
    UIView *_topView;//导航背景图
    UILabel *_lblTitle;//导航标题
    UIButton *_btnLeft;
    UIButton *_btnRight;
    UIImageView *_imgLeft;
    UIImageView *_imgRight;
    UILabel *_lblLeft;
    UILabel *_lblRight;
    
    NSInteger _orginY;
}

- (void)setBarTitle:(NSString *)strTitle;
- (void)addLeftButton:(NSString *)strImage;
- (void)addRightButton:(NSString *)strImage;
- (void)addLeftbuttontitle:(NSString *)strName;
- (void)addRightbuttontitle:(NSString *)strName;

- (void)clickLeftButton:(UIButton *)sender;
- (void)clickRightButton:(UIButton *)sender;

//设置左右按钮文字
- (void)setBarTitleColor:(UIColor *)color;

- (void)addStarToNavigtionBar;

@end
