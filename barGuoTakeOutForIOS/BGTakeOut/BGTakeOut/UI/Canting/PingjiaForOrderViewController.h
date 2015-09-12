//
//  PingjiaForOrderViewController.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/18.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
#import "TQStarRatingView.h"

@interface PingjiaForOrderViewController : BaseNavigationController<StarRatingViewDelegate,UITextViewDelegate>
@property(nonatomic,strong)NSArray * goodsList;
@property(nonatomic,strong)NSDictionary *OrderInfo;
@property(nonatomic)float price;

@end
