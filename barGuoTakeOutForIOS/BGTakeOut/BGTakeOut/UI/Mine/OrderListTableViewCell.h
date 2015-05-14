//
//  OrderListTableViewCell.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *resname;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
