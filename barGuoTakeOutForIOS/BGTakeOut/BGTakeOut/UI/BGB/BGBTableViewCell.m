//
//  BGBTableViewCell.m
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/16.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BGBTableViewCell.h"

@implementation BGBTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)inputEnd:(id)sender {
    [_textField resignFirstResponder];
}
@end
