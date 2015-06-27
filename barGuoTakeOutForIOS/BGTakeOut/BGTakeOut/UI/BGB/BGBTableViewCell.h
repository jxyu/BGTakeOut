//
//  BGBTableViewCell.h
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/16.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGBTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;
- (IBAction)inputEnd:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *img_hongxing;

@end
