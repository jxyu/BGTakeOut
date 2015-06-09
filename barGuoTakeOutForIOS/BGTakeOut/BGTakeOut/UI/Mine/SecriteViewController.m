//
//  SecriteViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/6/8.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "SecriteViewController.h"

@interface SecriteViewController ()

@end

@implementation SecriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _lblTitle.text=@"隐私政策";
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [_mywebView loadHTMLString:htmlString baseURL:[NSURL URLWithString:htmlPath]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
