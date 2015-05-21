//
//  RankCategoryViewController.h
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/21.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BaseNavigationController.h"

@interface RankCategoryViewController : BaseNavigationController
@property(nonatomic,strong)NSString* oneid;
@property(nonatomic,strong)NSString*    onetitle;
@property(nonatomic,strong)NSString* twoid;
@property(nonatomic,strong)NSString*    twotitle;
@property(nonatomic,strong)NSString* threeid;
@property(nonatomic,strong)NSString*    threetitle;
//第几级
@property(nonatomic,strong)NSNumber* rank;
@end
