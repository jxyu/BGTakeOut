//
//  GoodsTableViewCell.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/28.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodimg;
@property (weak, nonatomic) IBOutlet UILabel *goodName;
@property (weak, nonatomic) IBOutlet UILabel *goodSell;
@property (weak, nonatomic) IBOutlet UILabel *personPush;
@property (weak, nonatomic) IBOutlet UILabel *goodPrice;
@property (weak, nonatomic) IBOutlet UIButton *goodAdd;

@end
