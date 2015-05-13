//
//  CustomTabBarViewController.m
//  Blinq
//
//  Created by Sugar on 13-8-12.
//  Copyright (c) 2013年 Sugar Hou. All rights reserved.
//

#import "CustomTabBarViewController.h"
#import "CommenDef.h"
#import "Toolkit.h"
#import "IndexViewController.h"
#import "BGBangViewController.h"
#import "FoundViewController.h"
#import "MineViewController.h"


#import "UIImage+NSBundle.h"


#define tabBarButtonNum 4

@interface CustomTabBarViewController ()
{
    NSArray *_arrayImages;
    UIButton *_btnSelected;
    UIView *_tabBarBG;
}
@end

@implementation CustomTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //隐藏系统tabbar
    self.tabBar.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
     NSArray *arrayImages_H = [[NSArray alloc] initWithObjects:@"index_11@2x.png",@"index_13@2x.png" ,@"index_15@2x.png",@"index_17@2x.png", nil];
 	NSArray *arrayImages = [[NSArray alloc] initWithObjects:@"index_10@2x.png",@"index_12@2x.png",@"index_14@2x.png",@"index_16@2x.png",  nil];
    NSArray * arrayTitles=[[NSArray alloc] initWithObjects:@"首页",@"巴国榜",@"发现",@"我的", nil];
 
    _tabBarBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - TabBar_HEIGHT, SCREEN_WIDTH, TabBar_HEIGHT)];
      _tabBarBG.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1];
    
    //_tabBarBG.backgroundColor=[UIColor clearColor];
    //_tabBarBG.alpha=0.9;
    [self.view addSubview:_tabBarBG];
//    UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(0,0.3, SCREEN_WIDTH, 0.3)];
//    imageline1.backgroundColor=[UIColor colorWithRed:0.88 green:0.89 blue:0.89 alpha:1];
//    [self.view addSubview:imageline1];
    //自定义tabbar的按钮和图片
	
    int tabBarWitdh = SCREEN_WIDTH * 1.0f / tabBarButtonNum;
	for(int i = 0; i < tabBarButtonNum; i++)
	{
		CGRect frame=CGRectMake(i * tabBarWitdh, 0, tabBarWitdh, 49);
    
		UIButton * btnTabBar = [[UIButton alloc] initWithFrame:frame];
		 [btnTabBar setImage: [UIImage imageWithBundleName:[arrayImages objectAtIndex:i]] forState:UIControlStateNormal];
         [btnTabBar setImage:[UIImage imageWithBundleName:[arrayImages_H objectAtIndex:i]]forState:UIControlStateSelected] ;
		btnTabBar.tag = i + 1000;
		[btnTabBar addTarget:self action:@selector(onTabButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
		[_tabBarBG addSubview:btnTabBar];
        
        
        UILabel *lbl_title = [[UILabel alloc] initWithFrame:CGRectMake(btnTabBar.frame.origin.x, 37, btnTabBar.frame.size.width, 9)];
        lbl_title.text =[arrayTitles objectAtIndex:i];
        lbl_title.textAlignment=NSTextAlignmentCenter;
        lbl_title.numberOfLines = 0;
        lbl_title.font = [UIFont systemFontOfSize:10];
        lbl_title.textColor = [UIColor darkGrayColor];
        lbl_title.backgroundColor = [UIColor clearColor];
        [_tabBarBG addSubview:lbl_title];
        
        
        
        
	}
    
    
   
    IndexViewController *HomeView=[[IndexViewController alloc]init];
    if ([Toolkit isSystemIOS7]||[Toolkit isSystemIOS8])
        HomeView.automaticallyAdjustsScrollViewInsets = NO;
    UINavigationController * homeviewnav=[[UINavigationController alloc]initWithRootViewController:HomeView];
//    homePageNavigation.automaticallyAdjustsScrollViewInsets = YES;
    HomeView.hidesBottomBarWhenPushed = YES;
    homeviewnav.navigationBar.hidden=YES;
    
    BGBangViewController *BGBangView=[[BGBangViewController alloc]init];
    UINavigationController *BGBangViewnav = [[UINavigationController alloc] initWithRootViewController:BGBangView];
    BGBangView.hidesBottomBarWhenPushed=YES;
    BGBangViewnav.navigationBar.hidden=YES;
    
    FoundViewController *foundlistView=[[FoundViewController alloc]init];
    UINavigationController *foundlistViewnav = [[UINavigationController alloc] initWithRootViewController:foundlistView];
    foundlistView.hidesBottomBarWhenPushed = YES;
    foundlistViewnav.navigationBarHidden=YES;
    //消息
    
    MineViewController *mineView=[[MineViewController alloc]init];
    UINavigationController *mineViewnav = [[UINavigationController alloc] initWithRootViewController:mineView];
    mineView.hidesBottomBarWhenPushed=YES;
    mineViewnav.navigationBar.hidden=YES;
 
    //加入到真正的tabbar
    //fix me 商铺选项卡暂时隐藏
    self.viewControllers=[NSArray arrayWithObjects:homeviewnav,BGBangViewnav,foundlistViewnav,mineViewnav,nil];
    
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:0 + 1000];
    [self onTabButtonPressed:btnSender];
    
    
}

 


//点击tab页时的响应
-(void)onTabButtonPressed:(UIButton *)sender
{
    
    
    
    if (_btnSelected == sender)
        return ;
    
    if (_btnSelected)
        _btnSelected.selected = !_btnSelected.selected;
    
    sender.selected = !sender.selected;
    _btnSelected = sender;
    [self setSelectedIndex:sender.tag - 1000];
}

- (void)selectTableBarIndex:(NSInteger)index
{
    if (index < 0 || index > 5)
        return ;
    UIButton *btnSender = (UIButton *)[self.view viewWithTag:index + 1000];
    [self onTabButtonPressed:btnSender];
}

//隐藏tabbar
- (void)hideCustomTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT, 320, _tabBarBG.frame.size.height);
	[UIView commitAnimations];
	
}
//显示tabbar
-(void)showTabBar
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	_tabBarBG.frame=CGRectMake(0, SCREEN_HEIGHT - TabBar_HEIGHT, SCREEN_WIDTH, _tabBarBG.frame.size.height);
	[UIView commitAnimations];
}

- (void)goToHomePage
{
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
