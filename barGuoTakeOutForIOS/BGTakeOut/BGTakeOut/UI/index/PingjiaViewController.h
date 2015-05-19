//
//  PingjiaViewController.h
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/18.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BaseNavigationController.h"

@interface PingjiaViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
