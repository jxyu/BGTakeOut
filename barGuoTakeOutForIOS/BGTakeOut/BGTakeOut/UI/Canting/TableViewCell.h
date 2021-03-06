//
//  TableViewCell.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/23.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "AMRatingControl.h"

@interface TableViewCell : UITableViewCell <StarRatingViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *Canting_icon;
@property (weak, nonatomic) IBOutlet UILabel *CantingName;
@property (weak, nonatomic) IBOutlet UIImageView *Renzheng;
@property (weak, nonatomic) IBOutlet UILabel *Qisongjia;
@property (weak, nonatomic) IBOutlet UILabel *Howlong;
@property (weak, nonatomic) IBOutlet UILabel *Adress;
@property (strong, nonatomic) IBOutlet UIView *PingjiaView;
@property (weak, nonatomic) IBOutlet UIView *CantingActive;
//@property(nonatomic,strong)TQStarRatingView *starRatingView;
@property(nonatomic,strong)AMRatingControl * starRatingView;
//@property (strong, nonatomic) CWStarRateView *starRateView;
@property (weak, nonatomic) IBOutlet UILabel *yisong;

-(void)initLayout;

@end
