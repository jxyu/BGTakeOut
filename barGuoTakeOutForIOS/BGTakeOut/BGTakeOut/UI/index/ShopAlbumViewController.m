//
//  ShopAlbumViewController.m
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/16.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "ShopAlbumViewController.h"
#import "DataProvider.h"
#import "UIImageView+WebCache.h"
@interface ShopAlbumViewController ()

@end

@implementation ShopAlbumViewController
#pragma mark - vc-lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma amrk - vc_init

-(void)initView{
    _lblTitle.text=@"店铺相册";
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    
}
-(void)initData{
    DataProvider* tDataProvider=[[DataProvider alloc] init];
    [tDataProvider setDelegateObject:self setBackFunctionName:@"getShopAlbum:"];
    [tDataProvider getResAlbumWithResid:_resid];
}
#pragma mark vc_action
-(void)clickLeftButton:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark data_provider_delegate
-(void)getShopAlbum:(NSArray*)dict{
    //    UIImageView* imgView=[[UIImageView alloc] init];
    
    
    
    CGRect rect = {{20,100},{250,340}};
    slideImageView = [[SlideImageView alloc]initWithFrame:rect ZMarginValue:5 XMarginValue:10 AngleValue:0.3 Alpha:1000];
    slideImageView.borderColor = [UIColor whiteColor];
    slideImageView.delegate = self;
    [self.view addSubview:slideImageView];
    for (int i=0; i<dict.count; i++) {
        //        [imgView sd_setImageWithURL:[NSURL URLWithString:@"http://cc.cocimg.com/api/uploads/20150430/1430388577515100.jpg"] placeholderImage:[UIImage imageNamed:@"1136-1"]];
        //!!!: 图片显示使用上面的链接可以正常显示，使用服务器返回的图片链接，错误 -1100  ，怀疑是使用外链进行多次跳转，服务器没有设置商铺相册对应的模块
        UIImageView* imgView=[[UIImageView alloc] init];
        [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://112.74.76.91/baguo/%@",[[dict objectAtIndex:i] objectForKey:@"picurl"]]] placeholderImage:[UIImage imageNamed:@"1136-1"] options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
            [slideImageView addImage:imgView.image];
            [slideImageView setImageShadowsWtihDirectionX:2 Y:2 Alpha:0.7];
            
            [slideImageView reLoadUIview];
        }];
    }
    //    [slideImageView addImage:imgView.image];
}



@end
