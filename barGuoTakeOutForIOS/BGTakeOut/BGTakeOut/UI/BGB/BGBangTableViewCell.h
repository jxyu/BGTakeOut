//
//  BGBangTableViewCell.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/24.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGBangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;
@property (weak, nonatomic) IBOutlet UILabel *Name;
@property (weak, nonatomic) IBOutlet UIImageView *renzheng;
@property (weak, nonatomic) IBOutlet UILabel *adress;
@property (weak, nonatomic) IBOutlet UIButton *dianzan;
@property (weak, nonatomic) IBOutlet UIButton *Btn_share;
@property (weak, nonatomic) IBOutlet UILabel *lbl_renzheng;


@end
