//
//  ShopAlbumViewController.h
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/16.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BaseNavigationController.h"
#import "SlideImageView.h"
@interface ShopAlbumViewController : BaseNavigationController<SlideImageViewDelegate>
{
    SlideImageView* slideImageView;

}


@end
