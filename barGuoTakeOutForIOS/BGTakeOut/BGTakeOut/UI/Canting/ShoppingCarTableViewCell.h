//
//  ShoppingCarTableViewCell.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/19.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShoppingCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_title;
@property (weak, nonatomic) IBOutlet UIButton *btn_jia;
@property (weak, nonatomic) IBOutlet UILabel *lbl_num;
@property (weak, nonatomic) IBOutlet UIButton *btn_jian;

@end
