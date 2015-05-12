//
//  IndexViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/17.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "IndexViewController.h"
#import "SDCycleScrollView.h"
#import "DataProvider.h"
#import "CCLocationManager.h"
#define kSWidth self.view.bounds.size.width
#define kSHeight self.view.bounds.size.height
#define kJianXi 5
#define tabBarButtonNum 4
#define KURL @"http://121.42.139.60/baguo/"

@interface IndexViewController ()
{
}
@property(nonatomic,strong)SDCycleScrollView *cycleScrollView;
@property(nonatomic,strong)UIButton * AutoLocation;
//@property(nonatomic,strong)UIView * package;
//@property(nonatomic,strong)UIView * Page;


@end

@implementation IndexViewController
{
    UIView * page;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [NSThread detachNewThreadSelector:@selector(PostGetMsg) toTarget:dataprovider withObject:nil];
//    NSThread * newthread=[[NSThread alloc] initWithTarget:dataprovider selector:@selector(PostGetMsg) object:nil];
//    [newthread start];
//    _BaGuoBang.
    page=[[UIView alloc ] initWithFrame:CGRectMake(0, 0, kSWidth, kSHeight-49)];
    [self.view addSubview:page];
    _mytablebar.delegate=self;
    _mytablebar.selectedItem=_index;
    //添加top
    UIView * top =[[UIView alloc] initWithFrame:CGRectMake(0, 0, kSWidth, 64)];
    UIColor * bgColor = [UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    top.backgroundColor=bgColor;
    _AutoLocation = [[UIButton alloc] initWithFrame:CGRectMake(20, (64-10)/2, kSWidth-40, 25)];
    [_AutoLocation setTitle:@"自动定位" forState:UIControlStateNormal];
    [_AutoLocation setImage:[UIImage imageNamed:@"ic_location"] forState:UIControlStateNormal];
    [_AutoLocation addTarget:self action:@selector(GetLocation) forControlEvents:UIControlEventTouchUpInside];
    [page addSubview:top];
    [top addSubview:_AutoLocation];
    [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
        NSRange range=[addressString rangeOfString:@"中国"];
        [_AutoLocation setTitle:[addressString substringFromIndex:range.length+range.location] forState:UIControlStateNormal];
    }];
    
    
    UIView * lastinarray=[page.subviews lastObject] ;
    CGFloat y=[lastinarray frame].origin.y+lastinarray.frame.size.height;

//    _package=[[UIView alloc] initWithFrame:CGRectMake(0, y, kSWidth, kSHeight-y-49)];
//    [self.view addSubview:_package];
//    _Page=[[UIView alloc] initWithFrame:CGRectMake(0, y, kSWidth, kSHeight-y-49)];
    UIView * fillview=[[UIView alloc] initWithFrame:CGRectMake(0, y, kSWidth, 120)];
    fillview.tag=101;
    [page addSubview:fillview];
    
    //添加我要点餐按钮
    lastinarray=[page.subviews lastObject];
    y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
    UIButton * WaiMai= [[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth, 100)];
    [WaiMai setImage:[UIImage imageNamed:@"WaiMai.jpg"] forState:UIControlStateNormal];
    [WaiMai addTarget:self action:@selector(DoMyWaiMai) forControlEvents:UIControlEventTouchUpInside];
    [page addSubview:WaiMai];
    
    //添加每日笑话按钮
    lastinarray=[page.subviews lastObject] ;
    y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
    UIButton * Joke= [[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth/2-1, 70)];
    [Joke setImage:[UIImage imageNamed:@"joke.jpg"] forState:UIControlStateNormal];
    [Joke addTarget:self action:@selector(JumpToJoke) forControlEvents:UIControlEventTouchUpInside];
    [page addSubview:Joke];
    
    //添加幸运星按钮
    lastinarray=[page.subviews lastObject] ;
    CGFloat x=lastinarray.frame.size.width+2;
    UIButton * luck= [[UIButton alloc] initWithFrame:CGRectMake(x, y, kSWidth/2-1, 70)];
    [luck setImage:[UIImage imageNamed:@"luck.jpg"] forState:UIControlStateNormal];
    [page addSubview:luck];
    
    //更多礼品按钮
    lastinarray=[page.subviews lastObject] ;
    y=[lastinarray frame].origin.y+lastinarray.frame.size.height+kJianXi;
    UIButton * Gift= [[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth, 28)];
    [Gift setImage:[UIImage imageNamed:@"lipin_more.jpg"] forState:UIControlStateNormal];
    [Gift addTarget:self action:@selector(MoreGift) forControlEvents:UIControlEventTouchUpInside];
    [page addSubview:Gift];
    
    //添加下面展示的三样礼品
    lastinarray=[page.subviews lastObject] ;
    y=[lastinarray frame].origin.y+lastinarray.frame.size.height;
    UIButton * Gift_1= [[UIButton alloc] initWithFrame:CGRectMake(0, y, kSWidth/2, 120)];
    [Gift_1 setImage:[UIImage imageNamed:@"lipin_weidan.png"] forState:UIControlStateNormal];
    Gift_1.backgroundColor=[UIColor brownColor];
    [Gift_1 addTarget:self action:@selector(testclick) forControlEvents:UIControlEventTouchUpInside];
    [page addSubview:Gift_1];
    lastinarray=[page.subviews lastObject] ;
    x=lastinarray.frame.size.width;
    UIButton * Gift_2 =[[UIButton alloc] initWithFrame:CGRectMake(x, y, kSWidth/2, 60)];
    [Gift_2 setImage:[UIImage imageNamed:@"lipin_xiaomi.png"] forState:UIControlStateNormal];
    Gift_2.backgroundColor=[UIColor brownColor];
    Gift_2.layer.borderWidth=1.0;
    [page addSubview:Gift_2];
    lastinarray=[page.subviews lastObject] ;
    y=[lastinarray frame].origin.y+lastinarray.frame.size.height;
    UIButton * Gift_3= [[UIButton alloc] initWithFrame:CGRectMake(x, y, kSWidth/2, 60)];
    [Gift_3 setImage:[UIImage imageNamed:@"lipin_kindle.png"] forState:UIControlStateNormal] ;
    Gift_3.backgroundColor=[UIColor brownColor];
    Gift_3.layer.borderWidth=1.0;
    [page addSubview:Gift_3];
    
    //获取轮播图片
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"ContinueAddUIView:"];
    [dataprovider PostGetMsg];
}


-(void)ContinueAddUIView:(id)dict
{
    //添加scollView
    id result =dict;
    NSMutableArray *images = [[NSMutableArray alloc] init];
    for (int i=0; i<[result[@"data"] count]; i++) {
        UIImage * img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,result[@"data"][i][@"adurl"]]]]] ;
        [images addObject:img];
    }
    
    NSArray *titles = @[@"第一张轮播图",
                        @"第二张轮播图",
                        @"第三张轮播图",
                        @"第四张轮播图"
                        ];
    // 创建带标题的图片轮播器
    for (UIView *item in page.subviews) {
        if(101==item.tag)
        {
            _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:item.frame imagesGroup:images ];
        }
    }
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
    _cycleScrollView.titlesGroup = titles;
    
    [page addSubview:_cycleScrollView];
    
    
}

//点击tab页时的响应
-(void)onTabButtonPressed:(UIButton *)sender
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)GetLocation
{
    self.autolocation=[[AutoLocationViewController alloc] initWithNibName:@"AutoLocationViewController" bundle:[NSBundle mainBundle]];
    UIView *itemview=_autolocation.view;
    [self.view addSubview:itemview];
}

-(void)DoMyWaiMai
{
    self.myWaiMai=[[WaiMAIViewController alloc] initWithNibName:@"WaiMAIViewController" bundle:[NSBundle mainBundle]];
                   UIView * item =_myWaiMai.view;
                   [self.view addSubview:item];
                   }

-(void)JumpToJoke
{
    self.myJoke=[[JokeViewController alloc] initWithNibName:@"JokeViewController" bundle:[NSBundle mainBundle]];
    UIView * item =_myJoke.view;
    [self.view addSubview:item];
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"%ld",item.tag);
    switch (item.tag) {
        case 1:
        {
            _mytablebar.selectedItem=_index;
            if (self.myBGBang) {
                [_myBGBang.view removeFromSuperview];
            }
            if (self.myFound) {
                [_myFound.view removeFromSuperview];
            }
            if (self.myMine) {
                [_myMine.view removeFromSuperview];
            }
        }
            break;
        case 2:
        {
            self.myBGBang=[[BGBangViewController alloc] initWithNibName:@"BGBangViewController" bundle:[NSBundle mainBundle]];
            UIView * item =_myBGBang.view;
            [page addSubview:item];
            
        }
            break;
        case 3:
        {
            self.myFound=[[FoundViewController alloc] initWithNibName:@"FoundViewController" bundle:[NSBundle mainBundle]];
            UIView * item=_myFound.view;
            [page addSubview:item];
        }
            break;
        case 4:
        {
            self.myMine=[[MineViewController alloc] initWithNibName:@"MineViewController" bundle:[NSBundle mainBundle]];
            UIView * item=_myMine.view;
            [page addSubview:item];
        }
            break;
        default:
            break;
    }
}

-(void)MoreGift
{
    self.myGiftView=[[BGGiftViewController alloc] initWithNibName:@"BGGiftViewController" bundle:[NSBundle mainBundle]];
    UIView * item =_myGiftView.view;
    [self.view addSubview:item];
}

-(void)testclick
{
//    ResInfoViewController * myrest=[[ResInfoViewController alloc] initWithNibName:@"ResInfoViewController" bundle:[NSBundle mainBundle]];
//    UIView * item =myrest.view;
//    [self.view addSubview:item];
}

@end
