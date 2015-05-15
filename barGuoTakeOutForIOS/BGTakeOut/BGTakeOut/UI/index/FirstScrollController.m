//
//  FirstScrollController.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/20.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "FirstScrollController.h"

@interface FirstScrollController ()

@end

@implementation FirstScrollController
@synthesize scrollBG,pageCol;
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollBG=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollBG.delegate=self;
    scrollBG.showsHorizontalScrollIndicator=NO;
    scrollBG.contentSize=CGSizeMake(SCREEN_WIDTH*3, SCREEN_HEIGHT);
    scrollBG.pagingEnabled=YES;
    [self.view addSubview:scrollBG];
    
    for (int i=0; i<3; i++) {
        UIImageView *imgInfo=[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*i,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
        imgInfo.image=[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i+1]];
        [scrollBG addSubview:imgInfo];
    }
    
    pageCol=[[UIPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, 320, 20)];
    pageCol.numberOfPages=3;
    //pageCol.center=CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT-30);
    [self.view addSubview:pageCol];
    
    pageCol.hidden=YES;
    // Do any additional setup after loading the view from its nib.
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    int pageIndex = fabs(sender.contentOffset.x) /sender.frame.size.width;
    pageCol.currentPage = pageIndex;
    
    if (sender.contentOffset.x>(SCREEN_WIDTH*2+60)) {
        

        set_sp(@"1", @"FIRST_ENTER");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeRootView" object:nil ];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
