//
//  FirstScrollController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/20.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstScrollController : UIViewController<UIScrollViewDelegate>
 
@property(nonatomic,strong)UIScrollView *scrollBG;
@property(nonatomic,strong)UIPageControl *pageCol;
@end
