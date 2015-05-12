//
//  BGGiftTableViewCell.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/25.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGGiftTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *GiftImage;
@property (weak, nonatomic) IBOutlet UILabel *GiftName;
@property (weak, nonatomic) IBOutlet UILabel *Giftmoney;
@property (weak, nonatomic) IBOutlet UIButton *GiftChange;

@end
