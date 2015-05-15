//
//  LuckyGameViewController.h
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/15.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BaseNavigationController.h"

@interface LuckyGameViewController : BaseNavigationController
@property (strong, nonatomic) IBOutlet UILabel *label1;
@property (strong, nonatomic) IBOutlet UITextField *labelTextField;
@property (strong, nonatomic) IBOutlet UIImageView *plateImageView;
@property (strong, nonatomic) IBOutlet UIImageView *rotateStaticImageView;
- (IBAction)start:(id)sender;

@end
