//
//  PingjiaViewController.m
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/16.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "OrderPingjiaViewController.h"
#import "HMSegmentedControl.h"
@interface OrderPingjiaViewController ()

@end

@implementation OrderPingjiaViewController
#pragma mark - vc-lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView{
    _lblTitle.text=@"用户评价";
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    
    
    HMSegmentedControl *segmentedControl3 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"One", @"Two", @"Three", @"4", @"Five"]];
    [segmentedControl3 setFrame:CGRectMake(0, 64, SCREEN_WIDTH, 50)];
    [segmentedControl3 setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Selected index %ld (via block)", (long)index);
    }];
    segmentedControl3.selectionIndicatorHeight = 4.0f;
    segmentedControl3.backgroundColor = [UIColor colorWithRed:0.1 green:0.4 blue:0.8 alpha:1];
    segmentedControl3.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    segmentedControl3.selectionIndicatorColor = [UIColor colorWithRed:0.5 green:0.8 blue:1 alpha:1];
    segmentedControl3.selectionStyle = HMSegmentedControlSelectionStyleBox;
    segmentedControl3.selectedSegmentIndex = HMSegmentedControlNoSegment;
    segmentedControl3.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl3.shouldAnimateUserSelection = NO;
    segmentedControl3.tag = 2;
    [self.view addSubview:segmentedControl3];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
