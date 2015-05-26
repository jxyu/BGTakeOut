//
//  BGBangViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/24.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BGBangViewController.h"
#import "NYSegmentedControl.h"
#import "DataProvider.h"
#import "CommenDef.h"
#import "BGBangTableViewCell.h"
#import "AppDelegate.h"
#import "CCLocationManager.h"
#import "WantRecommendViewController.h"
#import "MJRefresh.h"
#import "MultilevelTableViewCell.h"
#import "UMSocial.h"
#import "UMSocialSnsService.h"
#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define KtextNum 6
#define KURL @"http://121.42.139.60/baguo/"


@interface BGBangViewController ()<UMSocialUIDelegate>
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property(nonatomic,strong)NYSegmentedControl *segmentedControl;
@property(nonatomic,strong)UIView * Page;

@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;

@end

@implementation BGBangViewController
{
    BOOL isClick;
    BOOL isShow;
    UITableView * mytableView;
    NSString * _page;
    NSString * _num;
    NSString * _sort;
    NSString * _oneid;
    NSString * _twoid;
    NSString * _threeid;
    NSString * _lat;
    NSString * _longprm;
    NSMutableArray * _TextArray;
    NSDictionary *dictionary;
    
    NSMutableArray *MenuFirstTypeArray;
    NSMutableArray * MenuSencondTypeArrau;
    BOOL isAgain;//标记是否为第二次请求列表数据
    
    NSInteger table_page;
    
    
    UITableView * menutableView;
    UIScrollView * firstScrollView;
    UIScrollView * thirdScrollView;
    NSMutableArray * categary1;
    NSMutableArray * categary2;
    NSMutableArray * categary3;
    UIView * BackView_paixu;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    dictionary =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    _TextArray=[[NSMutableArray alloc] init];
    categary1=[[NSMutableArray alloc] init];
    categary2=[[NSMutableArray alloc] init];
    categary3=[[NSMutableArray alloc] init];
    isClick=NO;
    isShow=NO;
    if (dictionary[@"userid"]) {
        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
        [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
            NSLog(@"%@",addressString);
            NSString *strUrl = [addressString stringByReplacingOccurrencesOfString:@"中国" withString:@""];
            [self setBarTitle:[strUrl stringByReplacingOccurrencesOfString:@"(null)" withString:@""]] ;
        }];
        //添加Segmented Control
        UIView * lastView=[self.view.subviews lastObject];
        UIView * segmentView=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 50)];
        segmentView.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
        self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"区域榜", @"新推荐"]];
        [_segmentedControl addTarget:self action:@selector(SegMentControlClick) forControlEvents:UIControlEventValueChanged];
        self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
        self.segmentedControl.titleTextColor = [UIColor whiteColor];
        self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
        self.segmentedControl.selectedTitleTextColor = [UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
        self.segmentedControl.borderWidth = 1.0f;
        self.segmentedControl.borderColor = [UIColor whiteColor];
        self.segmentedControl.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
        self.segmentedControl.cornerRadius=16.0f;
        self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor whiteColor];
        self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor whiteColor];
        self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
        self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.segmentedControl sizeToFit];
        self.segmentedControl.frame=CGRectMake(22, 2, SCREEN_WIDTH-44, 36);
        [segmentView addSubview:_segmentedControl];
        [self.view addSubview:segmentView];
        
        lastView=[self.view.subviews lastObject];
        CGFloat ViewHeight=lastView.frame.origin.y+lastView.frame.size.height;
        _Page=[[UIView alloc] initWithFrame:CGRectMake(0,ViewHeight , SCREEN_WIDTH, SCREEN_HEIGHT-ViewHeight-49)];
        [self.view addSubview:_Page];
        
        UIView * BackView_menu=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        BackView_menu.backgroundColor=[UIColor whiteColor];
        UIButton * btn_categray=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/3-30, 30)];
        [btn_categray setTitle:@"默认分类" forState:UIControlStateNormal];
        [btn_categray setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_categray addTarget:self action:@selector(btn_categrayClick) forControlEvents:UIControlEventTouchUpInside];
        btn_categray.titleLabel.font=[UIFont systemFontOfSize:14];
        [BackView_menu addSubview:btn_categray];
        UIImageView * image1=[[UIImageView alloc] initWithFrame:CGRectMake(btn_categray.frame.origin.x+btn_categray.frame.size.width, 15, 13, 10)];
        image1.image=[UIImage imageNamed:@"down"];
        [BackView_menu addSubview:image1];
        UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(image1.frame.origin.x+image1.frame.size.width+7, 5, 1, 30)];
        fenge1.backgroundColor=[UIColor grayColor];
        [BackView_menu addSubview:fenge1];
        UIButton * btn_paixu=[[UIButton alloc] initWithFrame:CGRectMake(fenge1.frame.origin.x+fenge1.frame.size.width+10, 5, SCREEN_WIDTH/3-30, 30)];
        [btn_paixu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_paixu setTitle:@"默认排序" forState:UIControlStateNormal];
        btn_paixu.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn_paixu addTarget:self action:@selector(btn_paixuClick) forControlEvents:UIControlEventTouchUpInside];
        [BackView_menu addSubview:btn_paixu];
        UIImageView * image2=[[UIImageView alloc] initWithFrame:CGRectMake(btn_paixu.frame.origin.x+btn_paixu.frame.size.width, 15, 13, 10)];
        image2.image=[UIImage imageNamed:@"down"];
        [BackView_menu addSubview:image2];
        UIView * fenge2=[[UIView alloc] initWithFrame:CGRectMake(image2.frame.origin.x+image2.frame.size.width+7, 5, 1, 30)];
        fenge2.backgroundColor=[UIColor grayColor];
        [BackView_menu addSubview:fenge2];
        UIButton * btn_myTuijian=[[UIButton alloc] initWithFrame:CGRectMake(fenge2.frame.origin.x+fenge2.frame.size.width+20, 5, SCREEN_WIDTH/3-30, 30)];
        [btn_myTuijian setBackgroundColor:[UIColor colorWithRed:255/255.0 green:180/255.0 blue:1/255.0 alpha:1.0]];
        [btn_myTuijian addTarget:self action:@selector(btn_tuijianClick) forControlEvents:UIControlEventTouchUpInside];
        btn_myTuijian.layer.masksToBounds=YES;
        btn_myTuijian.layer.cornerRadius=6;
        [btn_myTuijian setTitle:@"我要推荐" forState:UIControlStateNormal];
        [btn_myTuijian setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn_myTuijian.titleLabel.font=[UIFont systemFontOfSize:14];
        [BackView_menu addSubview:btn_myTuijian];
        [_Page addSubview:BackView_menu];
        
        
        
        
        lastView =[_Page.subviews lastObject];
        mytableView =[[UITableView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height, _Page.frame.size.width, _Page.frame.size.height-lastView.frame.size.height)];
        
        mytableView.delegate=self;
        mytableView.dataSource=self;
        [_Page addSubview:mytableView];
        __weak typeof(self) weakself=self;
        [mytableView addLegendFooterWithRefreshingBlock:^{
            [weakself loadNewData];
        }];
        [self loadNewData];
        
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"categaryFirstBackCall:"];
        [dataprovider getBaguoRankCateWithType:@"0" upid:@"0"];
        
        // 数据
        self.sorts=@[@"我要推荐"];
        self.areas = @[@"排序方式"];
        self.classifys = @[@"热门分类"];
        NSDictionary * dict=@{@"name":@"热门分类"};
        MenuFirstTypeArray=[[NSMutableArray alloc] initWithObjects:dict, nil];
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            [self MakePramAndGetData:@"1" andNum:@"8" andSort:@"1" andOneid:@"1" andTwoid:@"2" andThreeid:@"9" anduserid:dictionary[@"userid"] andlat:[NSString  stringWithFormat:@"%f",locationCorrrdinate.latitude] andlong:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude]];
        }];
        menutableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH/3, _Page.frame.size.height-40)];
        menutableView.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        menutableView.delegate=self;
        menutableView.dataSource=self;
        menutableView.tag=150;
        
        firstScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, 40, SCREEN_WIDTH/3, _Page.frame.size.height-40)];
        firstScrollView.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        firstScrollView.scrollEnabled=YES;
        thirdScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3*2, 40, SCREEN_WIDTH/3, _Page.frame.size.height-40)];
        thirdScrollView.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        thirdScrollView.scrollEnabled=YES;
    }
    else
    {
        _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        UIView * item =_myLogin.view;
        [_myLogin setDelegateObject:self setBackFunctionName:@"LoginBackCall:"];
        [self.view addSubview:item];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)MakePramAndGetData:(NSString *)page andNum:(NSString *)num andSort:(NSString *)sort andOneid:(NSString *)oneid andTwoid:(NSString *)twoid andThreeid:(NSString *)threeid anduserid:(NSString * )userid andlat:(NSString *)lat andlong:(NSString *)longprm
{
    NSDictionary * prm;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    if (page && num && sort ) {
        prm =[NSDictionary dictionaryWithObjectsAndKeys:
              page,@"page",
              num,@"num",
              sort,@"sort",
              oneid,@"oneid",
              twoid,@"twoid",
              threeid,@"threeid",
              userid,@"userid",
              lat,@"latitude",
              longprm,@"longitude",nil];
    }
    _page=page;
    _num=num;
    _sort=sort;
    _oneid=oneid;
    _twoid=twoid;
    _threeid=threeid;
    _lat=lat;
    _longprm=longprm;
    [dataprovider setDelegateObject:self setBackFunctionName:@"BuildTextItem:"];
    [dataprovider GetBGBangText:prm];
}

-(void)BuildTextItem:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        
        if (!isAgain) {
            NSArray * itemarray=dict[@"data"];
            for (int i=0; i<itemarray.count; i++) {
                [_TextArray addObject:itemarray[i]];
            }
        }
        else
        {
//           [_TextArray removeAllObjects];
          
            _TextArray=dict[@"data"];
        }
        [mytableView reloadData];
    }
}

// tableView分区数量，默认为1，可为其设置为多个列
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// tableView每个列的行数，可以为各个列设置不同的行数，根据section的值判断即可
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==150) {
        return categary1.count;
    }
    else
    {
        return _TextArray.count;
    }
}

// 实现每一行Cell的内容，tableView重用机制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==150) {
        static NSString *CellIdentifier = @"menuCellIdentifier";
        MultilevelTableViewCell *cell = (MultilevelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell  = [[[NSBundle mainBundle] loadNibNamed:@"MultilevelTableViewCell" owner:self options:nil] lastObject];
            cell.backgroundColor=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
            cell.titile.text=categary1[indexPath.row][@"name"];
            switch ([categary1[indexPath.row][@"oneid"] intValue]) {
                case 1:
                    cell.imageview.image=[UIImage imageNamed:@"res_hui"];
                    break;
                case 2:
                    cell.imageview.image=[UIImage imageNamed:@"food_hui"];
                    break;
                case 3:
                    cell.imageview.image=[UIImage imageNamed:@"music_hui"];
                    break;
                case 4:
                    cell.imageview.image=[UIImage imageNamed:@"jiazheng_hui"];
                    break;
                case 5:
                    cell.imageview.image=[UIImage imageNamed:@"wedding_hui"];
                    break;
                case 6:
                    cell.imageview.image=[UIImage imageNamed:@"peixun_hui"];
                    break;
                case 7:
                    cell.imageview.image=[UIImage imageNamed:@"zhuangxiu_hui"];
                    break;
                case 8:
                    cell.imageview.image=[UIImage imageNamed:@"truck_hui"];
                    break;
                    
                default:
                    break;
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
        else
        {
            for (UIView *subView in cell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"BGBangCellIdentifier";
        BGBangTableViewCell *cell = (BGBangTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell  = [[[NSBundle mainBundle] loadNibNamed:@"BGBangTableViewCell" owner:self options:nil] lastObject];
            cell.Name.text=_TextArray[indexPath.row][@"resname"];
            cell.adress.text=_TextArray[indexPath.row][@"resaddress"];
            cell.logoImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,_TextArray[indexPath.row][@"reslogo"]]]]];
            if ([_TextArray[indexPath.row][@"istarted"] intValue]==1) {
                [cell.dianzan setImage:[UIImage imageNamed:@"zan@2x"] forState:UIControlStateNormal];
                [cell.dianzan setTitle:[NSString stringWithFormat:@"(%d)喜欢",[_TextArray[indexPath.row][@"starnum"] intValue]] forState:UIControlStateNormal];
                [cell.dianzan setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else
            {
                [cell.dianzan setTitle:[NSString stringWithFormat:@"(%d)喜欢",[_TextArray[indexPath.row][@"starnum"] intValue]] forState:UIControlStateNormal];
                cell.dianzan.tag=indexPath.row;
                [cell.dianzan addTarget:self action:@selector(dianzanFunction:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            cell.lbl_renzheng.text=[NSString stringWithFormat:@"认证%@分",_TextArray[indexPath.row][@"authenscore"]];
            [cell.Btn_share addTarget:self action:@selector(BGBangShare:) forControlEvents:UIControlEventTouchUpInside];
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
        else
        {
            for (UIView *subView in cell.contentView.subviews)
            {
                [subView removeFromSuperview];
            }
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=100.0;
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==150) {
        _oneid=categary1[indexPath.row][@"oneid"];
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetSecondTypeBackCall:"];
        [dataprovider GetBGBangTypewithtype:@"1" andupid:categary1[indexPath.row][@"oneid"]];
        
        MultilevelTableViewCell *cell=(MultilevelTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        for (int i=0; i<categary1.count; i++) {
            if ([categary1[i][@"oneid"] intValue]!=[categary1[indexPath.row][@"oneid"] intValue]) {
                switch ([categary1[indexPath.row][@"oneid"] intValue]) {
                    case 1:
                        cell.imageview.image=[UIImage imageNamed:@"res_hui"];
                        break;
                    case 2:
                        cell.imageview.image=[UIImage imageNamed:@"food_hui"];
                        break;
                    case 3:
                        cell.imageview.image=[UIImage imageNamed:@"music_hui"];
                        break;
                    case 4:
                        cell.imageview.image=[UIImage imageNamed:@"jiazheng_hui"];
                        break;
                    case 5:
                        cell.imageview.image=[UIImage imageNamed:@"wedding_hui"];
                        break;
                    case 6:
                        cell.imageview.image=[UIImage imageNamed:@"peixun_hui"];
                        break;
                    case 7:
                        cell.imageview.image=[UIImage imageNamed:@"zhuangxiu_hui"];
                        break;
                    case 8:
                        cell.imageview.image=[UIImage imageNamed:@"truck_hui"];
                        break;
                        
                    default:
                        break;
                }
            }
            cell.titile.textColor=[UIColor blackColor];
        }
        
        
        switch ([categary1[indexPath.row][@"oneid"] intValue]) {
            case 1:
                cell.imageview.image=[UIImage imageNamed:@"res"];
                break;
            case 2:
                cell.imageview.image=[UIImage imageNamed:@"food"];
                break;
            case 3:
                cell.imageview.image=[UIImage imageNamed:@"music"];
                break;
            case 4:
                cell.imageview.image=[UIImage imageNamed:@"jiazheng"];
                break;
            case 5:
                cell.imageview.image=[UIImage imageNamed:@"wedding"];
                break;
            case 6:
                cell.imageview.image=[UIImage imageNamed:@"peixun"];
                break;
            case 7:
                cell.imageview.image=[UIImage imageNamed:@"zhuangxiu"];
                break;
            case 8:
                cell.imageview.image=[UIImage imageNamed:@"truck"];
                break;
                
            default:
                break;
        }
        cell.titile.textColor=[UIColor redColor];

    }
    else
    {
        self.BGBangDetialVC=[[BGBangDetialViewController alloc] init];
        _BGBangDetialVC.articleid=_TextArray[indexPath.row][@"articleid"];
        _BGBangDetialVC.userid=dictionary[@"userid"];
        [self.navigationController pushViewController:_BGBangDetialVC animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
}

-(void)SegMentControlClick
{
    NSLog(@"dsfsadfa%ld",(long)self.segmentedControl.selectedSegmentIndex);
    if (1==self.segmentedControl.selectedSegmentIndex) {
//        _Page.hidden=YES;
        NSLog(@"other");
        [menutableView removeFromSuperview];
        [firstScrollView removeFromSuperview];
        [thirdScrollView removeFromSuperview];
        [BackView_paixu removeFromSuperview];
        isAgain=YES;
        NSDictionary * prm=@{@"userid":dictionary[@"userid"],@"page":@"1",@"num":@"8"};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"OtherClickBackCall:"];
        [dataprovider BGBangXintuijian:prm];
    }
    else
    {
        isAgain=YES;
//        _Page.hidden=NO;
        [menutableView removeFromSuperview];
        [firstScrollView removeFromSuperview];
        [thirdScrollView removeFromSuperview];
        [BackView_paixu removeFromSuperview];
        [self MakePramAndGetData:_page andNum:_num andSort:_sort andOneid:_oneid andTwoid:_twoid andThreeid:_threeid anduserid:dictionary[@"userid"] andlat:_lat andlong:_longprm];
        
    }
}

-(void)BGBangShare:(UIButton *)sender
{
    //分享巴国榜
    NSString *shareText = @"快来加入掌尚街，享受生活的乐趣吧！";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"1136-1"];          //分享内嵌图片
NSArray* snsList=    [NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToEmail,UMShareToSms,nil];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:umeng_app_key
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:snsList
                                       delegate:nil];
}

-(void)GetSecondTypeBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        categary2=dict[@"data"];
        for (UIView * item in firstScrollView.subviews) {
            [item removeFromSuperview];
        }
        for (int i=0; i<categary2.count; i++) {
            UIButton * btn_itemInScroll=[[UIButton alloc] initWithFrame:CGRectMake(0, 50*i+2, firstScrollView.frame.size.width, 50)];
            btn_itemInScroll.titleLabel.font=[UIFont systemFontOfSize:14];
            [btn_itemInScroll.titleLabel setTextAlignment:NSTextAlignmentCenter];
            btn_itemInScroll.backgroundColor=[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0];
            [btn_itemInScroll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn_itemInScroll setTitle:categary2[i][@"name"] forState:UIControlStateNormal];
            [btn_itemInScroll setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn_itemInScroll.tag=i;
            [btn_itemInScroll addTarget:self action:@selector(Getthirdcategray:) forControlEvents:UIControlEventTouchUpInside];
            [firstScrollView addSubview:btn_itemInScroll];
        }
        UIView * lastView=[firstScrollView.subviews lastObject];
        firstScrollView.contentSize=CGSizeMake(0, lastView.frame.origin.y+lastView.frame.size.height);
        [_Page addSubview:firstScrollView];

    }
}
-(void)GetthirdTypeBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        categary3=dict[@"data"];
        for (UIView * item in thirdScrollView.subviews) {
            [item removeFromSuperview];
        }
        for (int i=0; i<categary3.count; i++) {
            UIButton * btn_itemInScroll=[[UIButton alloc] initWithFrame:CGRectMake(0, 50*i+2, thirdScrollView.frame.size.width, 50)];
            btn_itemInScroll.titleLabel.font=[UIFont systemFontOfSize:14];
            [btn_itemInScroll.titleLabel setTextAlignment:NSTextAlignmentCenter];
            btn_itemInScroll.backgroundColor=[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0];
            [btn_itemInScroll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn_itemInScroll setTitle:categary3[i][@"name"] forState:UIControlStateNormal];
            [btn_itemInScroll setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn_itemInScroll.tag=i;
            [btn_itemInScroll addTarget:self action:@selector(finishChoosefenlei:) forControlEvents:UIControlEventTouchUpInside];
            [thirdScrollView addSubview:btn_itemInScroll];
        }
        UIView * lastView=[thirdScrollView.subviews lastObject];
        thirdScrollView.contentSize=CGSizeMake(0, lastView.frame.origin.y+lastView.frame.size.height);
        [_Page addSubview:thirdScrollView];
    }
}

-(void)dianzanFunction:(UIButton *)sender
{
    [SVProgressHUD showWithStatus:@"点赞" maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"dianzanBackCall:"];
    [dataprovider BGBangDianzanFuncWithuserid:dictionary[@"userid"] andartid:_TextArray[sender.tag][@"articleid"]];
}
-(void)dianzanBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if ([dict[@"status"] intValue]==1) {
        [SVProgressHUD showSuccessWithStatus:@"点赞成功" maskType:SVProgressHUDMaskTypeBlack];
        [mytableView reloadData];
    }
}

-(void)OtherClickBackCall:(id)dict
{
    NSLog(@"%@",dict);
    _TextArray=dict[@"data"];
    [mytableView reloadData];
}



-(void)loadNewData
{
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    [self MakePramAndGetData:[NSString stringWithFormat:@"%ld",(long)table_page] andNum:_num andSort:_sort andOneid:_oneid andTwoid:_twoid andThreeid:_threeid anduserid:dictionary[@"userid"] andlat:_lat andlong:_longprm];
    table_page++;
}

-(void)btn_categrayClick
{
    NSLog(@"默认分类");
    if (!isClick) {
        [_Page addSubview:menutableView];
        isClick=YES;
    }
    else
    {
        isClick=NO;
        [menutableView removeFromSuperview];
        [firstScrollView removeFromSuperview];
        [thirdScrollView removeFromSuperview];
    }
}

-(void)btn_paixuClick
{
    NSLog(@"默认排序");
    
    if (!isShow) {
        BackView_paixu=[[UIView alloc] initWithFrame:CGRectMake(0, 40, _Page.frame.size.width, 124)];
        BackView_paixu.backgroundColor=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        UIView * itemView=[[UIView alloc] initWithFrame:CGRectMake(0, 1, BackView_paixu.frame.size.width, 30)];
        itemView.backgroundColor=[UIColor whiteColor];
        UIImageView * icon1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
        icon1.image=[UIImage imageNamed:@"xu.png"];
        [itemView addSubview:icon1];
        UILabel * lbl_title1=[[UILabel alloc] initWithFrame:CGRectMake(icon1.frame.origin.x+icon1.frame.size.width+10, 10, 250, 15)];
        lbl_title1.font=[UIFont systemFontOfSize:14];
        lbl_title1.text=@"默认排序";
        [itemView addSubview:lbl_title1];
        UIButton * btn_defaultPaixu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemView.frame.size.width, 30)];
        btn_defaultPaixu.tag=0;
        [btn_defaultPaixu addTarget:self action:@selector(GetListForOrder:) forControlEvents:UIControlEventTouchUpInside];
        [itemView addSubview:btn_defaultPaixu];
        [BackView_paixu addSubview:itemView];
        
        UIView * itemView1=[[UIView alloc] initWithFrame:CGRectMake(0, itemView.frame.origin.y+itemView.frame.size.height+1, BackView_paixu.frame.size.width, 30)];
        itemView1.backgroundColor=[UIColor whiteColor];
        UIImageView * icon2=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
        icon2.image=[UIImage imageNamed:@"like_icon_light.png"];
        [itemView1 addSubview:icon2];
        UILabel * lbl_title2=[[UILabel alloc] initWithFrame:CGRectMake(icon2.frame.origin.x+icon2.frame.size.width+10, 10, 250, 15)];
        lbl_title2.text=@"点赞对多";
        lbl_title2.font=[UIFont systemFontOfSize:14];
        [itemView1 addSubview:lbl_title2];
        UIButton * btn_dianzanPaixu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemView1.frame.size.width, 30)];
        btn_dianzanPaixu.tag=1;
        [btn_dianzanPaixu addTarget:self action:@selector(GetListForOrder:) forControlEvents:UIControlEventTouchUpInside];
        [itemView1 addSubview:btn_dianzanPaixu];
        [BackView_paixu addSubview:itemView1];
        
        
        UIView * itemView2=[[UIView alloc] initWithFrame:CGRectMake(0, itemView1.frame.origin.y+itemView1.frame.size.height+1, BackView_paixu.frame.size.width, 30)];
        itemView2.backgroundColor=[UIColor whiteColor];
        UIImageView * icon3=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
        icon3.image=[UIImage imageNamed:@"Star_light.png"];
        [itemView2 addSubview:icon3];
        UILabel * lbl_title3=[[UILabel alloc] initWithFrame:CGRectMake(icon3.frame.origin.x+icon3.frame.size.width+10, 10, 250, 15)];
        lbl_title3.text=@"评分最高";
        lbl_title3.font=[UIFont systemFontOfSize:14];
        [itemView2 addSubview:lbl_title3];
        UIButton * btn_pingfenPaixu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemView2.frame.size.width, 30)];
        btn_pingfenPaixu.tag=2;
        [btn_pingfenPaixu addTarget:self action:@selector(GetListForOrder:) forControlEvents:UIControlEventTouchUpInside];
        [itemView2 addSubview:btn_pingfenPaixu];
        [BackView_paixu addSubview:itemView2];
        
        UIView * itemView3=[[UIView alloc] initWithFrame:CGRectMake(0, itemView2.frame.origin.y+itemView2.frame.size.height+1, BackView_paixu.frame.size.width, 30)];
        itemView3.backgroundColor=[UIColor whiteColor];
        UIImageView * icon4=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
        icon4.image=[UIImage imageNamed:@"zheng.png"];
        [itemView3 addSubview:icon4];
        UILabel * lbl_title4=[[UILabel alloc] initWithFrame:CGRectMake(icon4.frame.origin.x+icon4.frame.size.width+10, 10, 250, 15)];
        lbl_title4.text=@"认证最高";
        lbl_title4.font=[UIFont systemFontOfSize:14];
        [itemView3 addSubview:lbl_title4];
        UIButton * btn_renzhengPaixu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemView3.frame.size.width, 30)];
        btn_renzhengPaixu.tag=3;
        [btn_renzhengPaixu addTarget:self action:@selector(GetListForOrder:) forControlEvents:UIControlEventTouchUpInside];
        [itemView3 addSubview:btn_renzhengPaixu];
        [BackView_paixu addSubview:itemView3];
        
        [_Page addSubview:BackView_paixu];
        isShow=YES;
    }
    else
    {
        [BackView_paixu removeFromSuperview];
        isShow=NO;
    }
    
}

-(void)btn_tuijianClick
{
    NSLog(@"我要推荐");
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary* userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userinfoWithFile){
        WantRecommendViewController* wantRecommendVC=[[WantRecommendViewController alloc] init];
        [self.navigationController pushViewController:wantRecommendVC animated:YES];
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
        LoginViewController* loginVC=        [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}
-(void)categaryFirstBackCall:(id)dict
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"categaryFirstBackCall:"];
    if ([dict[@"status"] intValue]==1) {
        NSArray *itemarray=dict[@"data"];
        if (itemarray[0][@"oneid"]) {
            categary1=dict[@"data"];
        }
        if (itemarray[0][@"upid"]) {
            categary2 =dict[@"data"];
        }
        if (itemarray[0][@"upid"]) {
            categary3 =dict[@"data"];
        }
    }
}
-(void)Getthirdcategray:(UIButton *)sender
{
    NSLog(@"获取第三级列表");
    for (UIView * items in firstScrollView.subviews) {
        if ([items isKindOfClass:[UIButton class]]) {
            UIButton * item=(UIButton *)items;
            item.titleLabel.textColor=[UIColor blackColor];
        }
    }
    sender.titleLabel.textColor=[UIColor redColor];
    _twoid=categary2[sender.tag][@"twoid"];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetthirdTypeBackCall:"];
    [dataprovider GetBGBangTypewithtype:@"2" andupid:categary2[sender.tag][@"upid"] ];
    
}

-(void)finishChoosefenlei:(UIButton *)sender
{
    _threeid=categary3[sender.tag][@"threeid"];
    [menutableView removeFromSuperview];
    [firstScrollView removeFromSuperview];
    [thirdScrollView removeFromSuperview];
    [self MakePramAndGetData:@"1" andNum:_num andSort:_sort andOneid:_oneid andTwoid:_twoid andThreeid:_threeid anduserid:dictionary[@"userid"] andlat:_lat andlong:_longprm];
}

-(void)GetListForOrder:(UIButton * )sender
{
    isShow=NO;
    [BackView_paixu removeFromSuperview];
    [self MakePramAndGetData:@"1" andNum:_num andSort:[NSString stringWithFormat:@"%ld",(long)sender.tag] andOneid:_oneid andTwoid:_twoid andThreeid:_threeid anduserid:dictionary[@"userid"] andlat:_lat andlong:_longprm];
}

@end
