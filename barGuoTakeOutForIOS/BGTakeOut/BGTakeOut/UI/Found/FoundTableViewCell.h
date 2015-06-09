//
//  FoundTableViewCell.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/5.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FoundTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *GroupTitle;
@property (weak, nonatomic) IBOutlet UIImageView *img_1;
@property (weak, nonatomic) IBOutlet UIImageView *img_2;
@property (weak, nonatomic) IBOutlet UIImageView *img_3;
@property (weak, nonatomic) IBOutlet UIImageView *img_4;
@property (weak, nonatomic) IBOutlet UIImageView *img_5;
@property (weak, nonatomic) IBOutlet UIButton *btn_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;
@property (weak, nonatomic) IBOutlet UIButton *btn_4;
@property (weak, nonatomic) IBOutlet UIButton *btn_5;

@property (weak, nonatomic) IBOutlet UILabel *lbl_1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_2;
@property (weak, nonatomic) IBOutlet UILabel *lbl_3;
@property (weak, nonatomic) IBOutlet UILabel *lbl_4;
@property (weak, nonatomic) IBOutlet UILabel *lbl_5;
- (void)setFrame:(CGRect)frame;
@end
