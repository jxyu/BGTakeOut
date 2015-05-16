//
//  ShopAlbumViewController.m
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/16.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "ShopAlbumViewController.h"

@interface ShopAlbumViewController ()

@end

@implementation ShopAlbumViewController
#pragma mark - vc-lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
-(void)initView{
    _lblTitle.text=@"店铺相册";
   [self addLeftButton:@"ic_actionbar_back.png"];
    
    CGRect rect = {{20,100},{250,340}};
    slideImageView = [[SlideImageView alloc]initWithFrame:rect ZMarginValue:5 XMarginValue:10 AngleValue:0.3 Alpha:1000];
    slideImageView.borderColor = [UIColor whiteColor];
    slideImageView.delegate = self;
    [self.view addSubview:slideImageView];
    for(int i=1; i<4; i++)
    {
        NSString* imageName = [NSString stringWithFormat:@"%d.jpg",i%4];
        UIImage* image = [UIImage imageNamed:imageName];
        [slideImageView addImage:image];
    }
    [slideImageView setImageShadowsWtihDirectionX:2 Y:2 Alpha:0.7];
    [slideImageView reLoadUIview];
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
-(void)clickLeftButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
