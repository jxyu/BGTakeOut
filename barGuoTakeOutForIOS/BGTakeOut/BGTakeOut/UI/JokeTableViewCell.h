//
//  JokeTableViewCell.h
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/24.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JokeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jokename;
@property (weak, nonatomic) IBOutlet UILabel *jokedate;
@property (weak, nonatomic) IBOutlet UILabel *jokecontent;

@end
