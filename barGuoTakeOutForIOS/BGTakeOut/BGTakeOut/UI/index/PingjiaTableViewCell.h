//
//  PingjiaTableViewCell.h
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/19.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMRatingControl.h"
@interface PingjiaTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel* usernameLbl;
@property(nonatomic,strong)UILabel* pingjiaContentLbl;
@property(nonatomic,strong)AMRatingControl* starRatingView;

-(void)setPingjiaText:(NSString*)text;
-(id)initWithReuseIdentifier:(NSString*)reuseIdentifier;
@end
