//
//  TableViewCell.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/23.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "TableViewCell.h"


@implementation TableViewCell


-(void)initLayout{
    
    _starRatingView= [[AMRatingControl alloc] initWithLocation:CGPointMake(0, 0)
                                                    emptyColor:[UIColor lightGrayColor]
                                                    solidColor:[UIColor redColor]
                                                  andMaxRating:5];
    [_starRatingView setUserInteractionEnabled:NO];
    _starRatingView.backgroundColor=[UIColor clearColor];
    [_PingjiaView addSubview:_starRatingView];
    
//    self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 4, _PingjiaView.frame.size.width-4, _PingjiaView.frame.size.height-4) numberOfStars:5];
//    self.starRateView.scorePercent = 0.5;
//    self.starRateView.allowIncompleteStar = YES;
//    self.starRateView.hasAnimation = YES;
//    [_PingjiaView addSubview:self.starRateView];
    
}

- (void)awakeFromNib {
    // Initialization code
    
//    _starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0 , _PingjiaView.frame.size.width, _PingjiaView.frame.size.height) numberOfStar:5];
//    _starRatingView.delegate = self;
//    UIButton * zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0,0 , _PingjiaView.frame.size.width, _PingjiaView.frame.size.height)];
//    
//    [_PingjiaView addSubview:_starRatingView];
//    [_PingjiaView addSubview:zhezhao];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
//    self.scoreLabel.text = [NSString stringWithFormat:@"%0.2f",score * 10 ];
}

@end
