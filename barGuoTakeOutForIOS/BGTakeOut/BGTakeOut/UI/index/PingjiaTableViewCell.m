//
//  PingjiaTableViewCell.m
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/19.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "PingjiaTableViewCell.h"

@implementation PingjiaTableViewCell

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self=[self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initLayout];
    }
    return self;
}
-(void)initLayout{
    _usernameLbl = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*2/3, 8, SCREEN_WIDTH/3-8, 40)];
    _usernameLbl.textAlignment=NSTextAlignmentRight ;
    _usernameLbl.textColor=[UIColor lightGrayColor];
    _usernameLbl.font=[UIFont systemFontOfSize:15.0];
    [self addSubview:_usernameLbl];
    
//    _starRatingView= [[AMRatingControl alloc] initWithLocation:CGPointMake(8, 12)
//                                                    emptyColor:[UIColor lightGrayColor]
//                                                    solidColor:[UIColor redColor]
//                                                  andMaxRating:5];
//    [_starRatingView setUserInteractionEnabled:NO];
//    _starRatingView.backgroundColor=[UIColor clearColor];
//    [self addSubview:_starRatingView];
//    
//    
//    _pingjiaContentLbl = [[UILabel alloc] initWithFrame:CGRectMake(8, 48, SCREEN_WIDTH-16, 40)];
//    [self addSubview:_pingjiaContentLbl];
    self.starRateView = [[CWStarRateView alloc] initWithFrame:CGRectMake(0, 4, 8, 12) numberOfStars:5];
    
    self.starRateView.allowIncompleteStar = YES;
    self.starRateView.hasAnimation = YES;
}
-(void)setPingjiaText:(NSString *)text{
    CGRect frame=[self frame];
    self.pingjiaContentLbl.text=text;
    self.pingjiaContentLbl.numberOfLines=10;
    CGSize size=CGSizeMake(SCREEN_WIDTH-16, 1000);
    CGSize labelSize=[self.pingjiaContentLbl.text sizeWithFont:self.pingjiaContentLbl.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    
    self.pingjiaContentLbl.frame=CGRectMake(self.pingjiaContentLbl.frame.origin.x, _pingjiaContentLbl.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height=labelSize.height+60;
    self.frame=frame;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
