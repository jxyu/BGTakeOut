//
//  WaiMAIViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/18.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "WaiMAIViewController.h"
#import "NYSegmentedControl.h"
#import "DataProvider.h"
#import "DOPDropDownMenu.h"
#import "CCLocationManager.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "MJRefresh.h"
#import "CWStarRateView.h"


#define KCantingNum 6
#define KURL @"http://112.74.76.91/baguo/"

@interface WaiMAIViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property NYSegmentedControl *segmentedControl;
@property UIView *visibleExampleView;
@property NSArray *exampleViews;
@property(nonatomic ,strong)UIView * Page;
@property(nonatomic,strong)UITableView * tableView;


@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;


@end

@implementation WaiMAIViewController
{
    NSString * _page;
    NSString* _num ;
    NSString* _order;
    NSString* _lat ;
    NSString* _long ;
    NSString* _activity;
    NSString* _category;
    NSString* _provinceid;
    NSString* _cityid;
    NSString* _districtid;
    
    NSArray * Canting;
    
    NSArray * activearray;
    
    NSArray * imagearray1;
    NSArray * imagearray2;
    NSArray * imagearray3;
    BOOL isAgain;
    
    NSInteger table_page;
//    NSMutableArray * tabledata;
    BOOL iscategaryShow;
    BOOL isSortShow;
    BOOL isActiveShow;
    UIView * BackView_paixu;
    NSDictionary *AreaInfo;
    BOOL isfooterRequest;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
    //        _lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude] ;
    //        _long=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
    //    }];
    isAgain=NO;
    table_page=1;
    _page=@"1";
    _num=@"10";
    _order=@"0";
    _category=@"1";
    _activity=@"0";
    _lat=@"0.0";
    _long=@"0.0";
    Canting=[[NSArray alloc] init];
    isActiveShow=NO;
    iscategaryShow=NO;
    isSortShow=NO;
    isfooterRequest=NO;
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
//    tabledata=[[NSMutableArray alloc] init];
    
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AreaInfo.plist"];
    AreaInfo =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        _lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude];
        _long=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
    }];
    
    
    
    //添加导航栏
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self setBarTitle:@"自动定位"] ;
    UIImageView * image_left=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, _lblTitle.frame.origin.y+13, 13, 15)];
    image_left.tag=1111;
    image_left.image=[UIImage imageNamed:@"index_location"];
//    [self.view addSubview:image_left];
    UIImageView * image_right=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+35, _lblTitle.frame.origin.y+18, 12, 7)];
    image_right.tag=1112;
    image_right.image=[UIImage imageNamed:@"index_down"];
    [self.view addSubview:image_right];
    if (AreaInfo.count==0) {
        [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
            NSLog(@"%@",addressString);
            [self setBarTitle:[addressString stringByReplacingOccurrencesOfString:@"(null)" withString:@""]] ;
            image_left.frame=CGRectMake(_lblTitle.frame.origin.x-12, image_left.frame.origin.y, 13, 15);
            image_right.frame=CGRectMake(image_left.frame.origin.x+130, image_right.frame.origin.y, 12, 7);
            
        }];
    }
    else
    {
        if (AreaInfo.count==2) {
            _lblTitle.text=AreaInfo[@"provinceTitle"];
            _provinceid=[NSString stringWithFormat:@"%@",AreaInfo[@"provinceid"]];
        }
        else if (AreaInfo.count==4)
        {
            _lblTitle.text=[NSString stringWithFormat:@"%@%@",AreaInfo[@"provinceTitle"],AreaInfo[@"cityTitle"]];
            _cityid=[NSString stringWithFormat:@"%@",AreaInfo[@"cityid"]];
        }
        else
        {
            _lblTitle.text=[NSString stringWithFormat:@"%@%@%@",AreaInfo[@"provinceTitle"],AreaInfo[@"cityTitle"],AreaInfo[@"districtTitle"]];
            _districtid=[NSString stringWithFormat:@"%@",AreaInfo[@"districtid"]];
        }
    }
    
    //添加Segmented Control
    UIView * lastView=[self.view.subviews lastObject];
    UIView * segmentView=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 50)];
    segmentView.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    self.segmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"附近餐厅", @"其他订购"]];
    [_segmentedControl addTarget:self action:@selector(SegMentControlClick) forControlEvents:UIControlEventValueChanged];
    self.segmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
    self.segmentedControl.titleTextColor = [UIColor whiteColor];
    self.segmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
    self.segmentedControl.selectedTitleTextColor = [UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    self.segmentedControl.borderWidth = 1.0f;
    self.segmentedControl.borderColor = [UIColor whiteColor];
    self.segmentedControl.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    //self.segmentedControl.segmentIndicatorInset = 2.0f;
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
    [self GetActivityes];
    
    lastView=[self.view.subviews lastObject];
    CGFloat ViewHeight=lastView.frame.origin.y+lastView.frame.size.height;
    _Page=[[UIView alloc] initWithFrame:CGRectMake(0,ViewHeight , SCREEN_WIDTH, SCREEN_HEIGHT-ViewHeight)];
    [self.view addSubview:_Page];
    // 数据
    self.sorts=@[@"促销活动"];
    self.areas = @[@"全部",@"糕点",@"超市",@"小吃",@"清真",@"早餐",@"正餐"];
    self.classifys = @[@"距离最近",@"销量最大",@"评价最高"];
    imagearray1=@[@"zong.png",@"jian.png",@"dian.png",@"han.png",@"qing.png",@"zao.png",@"wu.png"];
    imagearray2=@[@"langWay@2x.png",@"xiaoliang.png",@"timer.png"];
    //    imagearray3=@[@""]
    
    
    UIView * BackView_menu=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    BackView_menu.backgroundColor=[UIColor whiteColor];
    UIButton * btn_categray=[[UIButton alloc] initWithFrame:CGRectMake(10, 5, SCREEN_WIDTH/3-30, 30)];
    [btn_categray setTitle:@"默认分类" forState:UIControlStateNormal];
    [btn_categray setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_categray addTarget:self action:@selector(btn_categrayClick) forControlEvents:UIControlEventTouchUpInside];
    btn_categray.titleLabel.font=[UIFont systemFontOfSize:14];
    [BackView_menu addSubview:btn_categray];
    UIImageView * image1=[[UIImageView alloc] initWithFrame:CGRectMake(btn_categray.frame.origin.x+btn_categray.frame.size.width, 15, 13, 8)];
    image1.image=[UIImage imageNamed:@"down"];
    [BackView_menu addSubview:image1];
    UIView * fenge1=[[UIView alloc] initWithFrame:CGRectMake(image1.frame.origin.x+image1.frame.size.width+7, 5, 1, 30)];
    fenge1.backgroundColor=[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
    [BackView_menu addSubview:fenge1];
    UIButton * btn_paixu=[[UIButton alloc] initWithFrame:CGRectMake(fenge1.frame.origin.x+fenge1.frame.size.width+10, 5, SCREEN_WIDTH/3-30, 30)];
    [btn_paixu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn_paixu setTitle:@"排序方式" forState:UIControlStateNormal];
    btn_paixu.titleLabel.font=[UIFont systemFontOfSize:14];
    [btn_paixu addTarget:self action:@selector(btn_paixuClick) forControlEvents:UIControlEventTouchUpInside];
    [BackView_menu addSubview:btn_paixu];
    UIImageView * image2=[[UIImageView alloc] initWithFrame:CGRectMake(btn_paixu.frame.origin.x+btn_paixu.frame.size.width, 15, 13, 8)];
    image2.image=[UIImage imageNamed:@"down"];
    [BackView_menu addSubview:image2];
    UIView * fenge2=[[UIView alloc] initWithFrame:CGRectMake(image2.frame.origin.x+image2.frame.size.width+7, 5, 1, 30)];
    fenge2.backgroundColor=[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1.0];
    [BackView_menu addSubview:fenge2];
    UIButton * btn_myTuijian=[[UIButton alloc] initWithFrame:CGRectMake(fenge2.frame.origin.x+fenge2.frame.size.width+10, 5, SCREEN_WIDTH/3-30, 30)];
    [btn_myTuijian addTarget:self action:@selector(btn_activeClick) forControlEvents:UIControlEventTouchUpInside];
    btn_myTuijian.layer.masksToBounds=YES;
    btn_myTuijian.layer.cornerRadius=6;
    [btn_myTuijian setTitle:@"促销活动" forState:UIControlStateNormal];
    [btn_myTuijian setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn_myTuijian.titleLabel.font=[UIFont systemFontOfSize:14];
    [BackView_menu addSubview:btn_myTuijian];
    UIImageView * image3=[[UIImageView alloc] initWithFrame:CGRectMake(btn_myTuijian.frame.origin.x+btn_myTuijian.frame.size.width, 15, 13, 8)];
    image3.image=[UIImage imageNamed:@"down"];
    [BackView_menu addSubview:image3];
    [_Page addSubview:BackView_menu];
    
    //    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
    //        _lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude] ;
    //        _long=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
    //        _page=[NSString stringWithFormat:@"%d",1];
    //        _num =[NSString stringWithFormat:@"%d",KCantingNum];
    //        _order=[NSString stringWithFormat:@"%d",1];
    //        _activity=[NSString stringWithFormat:@"%d",1];
    //        _category=[NSString stringWithFormat:@"%d",1];
    //        [self GetrestaurantListPage:@"1" andNum:[NSString stringWithFormat:@"%d",KCantingNum] andOrder:@"1" andActivity:@"1" andCategory:@"1" andlat:_lat andlong:_long];
    //    }];
    
    lastView=[_Page.subviews lastObject];
    CGFloat y=lastView.frame.origin.y+lastView.frame.size.height;
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-y-63)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_Page addSubview:_tableView];
    // 下拉刷新
    __weak typeof(self) weakself=self;
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        [weakself StoreTopRefresh];
        [_tableView.header endRefreshing];
    }];
    [_tableView.header beginRefreshing];
    
    // 上拉刷新
    [_tableView addLegendFooterWithRefreshingBlock:^{
        if (!isfooterRequest) {
            isfooterRequest=YES;
            [weakself StoreFootRefresh];
        }
        [_tableView.footer endRefreshing];
    }];
    // 默认先隐藏footer
    _tableView.footer.hidden = NO;
//    __weak typeof(self) weakself=self;
//    [_tableView addLegendFooterWithRefreshingBlock:^{
//        if (!isfooterRequest) {
//            isfooterRequest=YES;
//            [weakself loadNewData];
//        }
//        
//        [_tableView.footer endRefreshing];
//    }];
    
//    [self loadNewData];
    
}


#pragma mark 数据请求
-(void)StoreTopRefresh
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetStoreListBackCall:"];
    //    获取当前的经纬度
    _page=@"1";
    if (_page && _num && _order && _activity && _category) {
        NSDictionary * prm =[NSDictionary dictionaryWithObjectsAndKeys:
              _page,@"page",
              _num,@"num",
              _order,@"order",
              _activity,@"activity",
              _category,@"category",
              _lat,@"lat",
              _long,@"long",
              _provinceid,@"provinceid",
              _cityid,@"cityid",
              _districtid,@"districtid", nil];
        [dataprovider GetrestaurantList:prm];
    }
    
}

-(void)StoreFootRefresh
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"FootRefireshBackCall:"];
    //    获取当前的经纬度
    if (_page && _num && _order && _activity && _category) {
        _page=[NSString stringWithFormat:@"%d",[_page intValue]+1];
        NSDictionary * prm =[NSDictionary dictionaryWithObjectsAndKeys:
                             _page,@"page",
                             _num,@"num",
                             _order,@"order",
                             _activity,@"activity",
                             _category,@"category",
                             _lat,@"lat",
                             _long,@"long",
                             _provinceid,@"provinceid",
                             _cityid,@"cityid",
                             _districtid,@"districtid", nil];
        [dataprovider GetrestaurantList:prm];
    }
}

-(void)FootRefireshBackCall:(id)dict
{
    
    NSLog(@"上拉刷新");
    // 结束刷新
    [_tableView.footer endRefreshing];
    isfooterRequest=NO;
    NSMutableArray *itemarray=[[NSMutableArray alloc] initWithArray:Canting];
    if ([dict[@"status"]intValue]==1) {
        NSArray * arrayitem=dict[@"data"];
        for (id item in arrayitem) {
            [itemarray addObject:item];
        }
        Canting=[[NSArray alloc] initWithArray:itemarray];
    }
    [_tableView reloadData];
}

-(void)GetStoreListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"店铺列表%@",dict);
    
    if ([dict[@"status"]intValue]==1) {
        NSLog(@"餐厅数据%@",dict);
        Canting=[[NSArray alloc] initWithArray:dict[@"data"]];
        [_tableView reloadData];
    }else{
        
    }

    [_tableView.header endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 点击segmeng control触发事件
-(void)SegMentControlClick
{
    NSLog(@"dsfsadfa%ld",(long)self.segmentedControl.selectedSegmentIndex);
    if (1==self.segmentedControl.selectedSegmentIndex) {
        //        _Page.hidden=YES;
        NSLog(@"other");
        isAgain=YES;
        _category=@"8";
        [_tableView.header beginRefreshing];
    }
    else
    {
        //        _Page.hidden=NO;
        isAgain=YES;
        _category=@"0";
        [_tableView.header beginRefreshing];
    }
}



-(void)GetActivityes
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetActivityData:"];
    [dataprovider GetActivityList];
}

//-(void)GetrestaurantListPage:(NSString *)page andNum:(NSString*)num andOrder:(NSString*)order andActivity:(NSString*)activity andCategory:(NSString *)category andlat:(NSString*)alat andlong:(NSString *)along andprovinceid:(NSString *)provinceid andcityid:(NSString *)cityid anddistrictid:(NSString *)districtid
//{
//    NSDictionary * prm;
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    _page=page;
//    _num=num;
//    _order=order;
//    _activity=activity;
//    _lat=alat;
//    _long=along;
//    _provinceid=provinceid;
//    _cityid=cityid;
//    _districtid=districtid;
//    //    获取当前的经纬度
//    if (page && num && order && activity && category) {
//        prm =[NSDictionary dictionaryWithObjectsAndKeys:
//              page,@"page",
//              num,@"num",
//              order,@"order",
//              activity,@"activity",
//              category,@"category",
//              alat,@"lat",
//              along,@"long",
//              provinceid,@"provinceid",
//              cityid,@"cityid",
//              districtid,@"districtid", nil];
//    }
//    [dataprovider setDelegateObject:self setBackFunctionName:@"bulidrestaurantList:"];
//    [dataprovider GetrestaurantList:prm];
//}



-(void)GetActivityData:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        self.sorts=dict[@"data"];
    }
}
//-(void)bulidrestaurantList:(id)dict
//{
//    [SVProgressHUD dismiss];
//    if ([dict[@"status"]intValue]==1) {
//        NSLog(@"餐厅数据%@",dict);
//        if (!isAgain) {
//            Canting=[NSArray arrayWithArray:dict[@"data"]];
//            for (int i=0; i<Canting.count; i++) {
//                [tabledata addObject:Canting[i]];
//                
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_tableView reloadData];
//            });
//            
//        }else
//        {
//            tabledata=dict[@"data"];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_tableView reloadData];
//            });
//        }
//    }else{
//        if (!isfooterRequest) {
//            tabledata=[[NSMutableArray alloc] init];
//        }
//        isfooterRequest=NO;
////        [SVProgressHUD showErrorWithStatus:dict[@"msg"] maskType:SVProgressHUDMaskTypeBlack];
////        [SVProgressHUD showErrorWithStatus:@"没有更多数据" maskType:SVProgressHUDMaskTypeBlack];
////        [_tableView reloadData];
//    }
////    [_tableView reloadData];
//    
//    [_tableView.footer endRefreshing];
//    
//    
//}




// tableView分区数量，默认为1，可为其设置为多个列
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// tableView每个列的行数，可以为各个列设置不同的行数，根据section的值判断即可
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return Canting.count;
}

// 实现每一行Cell的内容，tableView重用机制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    @try {
        if (cell == nil&&Canting.count>0) {
            activearray=[[NSArray alloc] initWithArray:Canting[indexPath.row][@"activities"]];
            cell  = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
            [cell initLayout];
            [cell.Canting_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,Canting[indexPath.row][@"logo"]==[NSNull null]?@"":Canting[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.Canting_icon.layer.masksToBounds=YES;
            cell.Canting_icon.layer.cornerRadius=4;
            cell.layer.borderWidth=1;
            cell.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]);
            if ([Canting[indexPath.row][@"isauthentic"] boolValue]) {
                cell.Renzheng.image=[UIImage imageNamed:@"renzheng.png"];
            }
            cell.CantingName.text=Canting[indexPath.row][@"name"]==[NSNull null]?@"":Canting[indexPath.row][@"name"];
            cell.Adress.text=Canting[indexPath.row][@"addressname"]==[NSNull null]?@"":Canting[indexPath.row][@"addressname"];
            //        cell.starRateView.scorePercent=[tabledata[indexPath.row][@"totalcredit"] floatValue]/5;
            cell.starRatingView.rating=[Canting[indexPath.row][@"starnum"]==[NSNull null]?@"0":Canting[indexPath.row][@"starnum"] intValue];
            cell.starRatingView.FoutSize=17;
            cell.Qisongjia.text=[NSString stringWithFormat:@"¥%@",Canting[indexPath.row][@"begindeliveryprice"]==[NSNull null]?@"":Canting[indexPath.row][@"begindeliveryprice"]];
            cell.yisong.text=[NSString stringWithFormat:@"已售%@单",Canting[indexPath.row][@"soldcount"]==[NSNull null]?@"":Canting[indexPath.row][@"soldcount"]];
            float howlong=[Canting[indexPath.row][@"distance"] floatValue]/1000;
            cell.Howlong.text=[NSString stringWithFormat:@"%.1fkm",howlong];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=110.0;
    //    CGFloat height=180.0+(activearray.count-1)*30;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    if ([@"1" isEqual:Canting[indexPath.row][@"isopen"]])//&&[self isBetweenFromHour:tabledata[indexPath.row][@"start"] toHour:tabledata[indexPath.row][@"end"]]
    {
        NSString * restid=Canting[indexPath.row][@"resid"];
        _myCantingView=[[CantingInfoViewController alloc] initWithNibName:@"CantingInfoViewController" bundle:[NSBundle mainBundle]];
        _myCantingView.beginprice=Canting[indexPath.row][@"begindeliveryprice"];
        _myCantingView.resid=restid;
        _myCantingView.peisongData=Canting[indexPath.row][@"deliveryprice"];
        _myCantingView.name=Canting[indexPath.row][@"name"];
        [self.navigationController pushViewController:_myCantingView animated:YES];
        
    }
    else{
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:@"提示" message:@"商家正在休息" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

//-(void)loadNewData{
//    isfooterRequest=YES;
//    table_page++;
//    [self GetrestaurantListPage:[NSString stringWithFormat:@"%ld",(long)table_page] andNum:[NSString stringWithFormat:@"%d",KCantingNum] andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long andprovinceid:AreaInfo[@"provinceid"] andcityid:AreaInfo[@"cityid"] anddistrictid:AreaInfo[@"districtid"]];
//    
//    
//}

-(void)btn_categrayClick
{
    NSLog(@"热门分类");
    if (!iscategaryShow) {
        [BackView_paixu removeFromSuperview];
        BackView_paixu=[[UIView alloc] initWithFrame:CGRectMake(0, 40, _Page.frame.size.width, 35*self.areas.count+self.areas.count)];
        BackView_paixu.backgroundColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        for (int i=0; i<self.areas.count; i++) {
            UIView * lastView=[BackView_paixu.subviews lastObject];
            UIView * itemView=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, BackView_paixu.frame.size.width, 35)];
            itemView.backgroundColor=[UIColor whiteColor];
            UIImageView * icon1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
            icon1.image=[UIImage imageNamed:imagearray1[i]];
            [itemView addSubview:icon1];
            UILabel * lbl_title1=[[UILabel alloc] initWithFrame:CGRectMake(icon1.frame.origin.x+icon1.frame.size.width+10, 10, 250, 15)];
            lbl_title1.font=[UIFont systemFontOfSize:14];
            lbl_title1.text=_areas[i];
            [itemView addSubview:lbl_title1];
            UIButton * btn_defaultPaixu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemView.frame.size.width, 30)];
            btn_defaultPaixu.tag=i+1;
            [btn_defaultPaixu addTarget:self action:@selector(GetcateGrayList:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:btn_defaultPaixu];
            [BackView_paixu addSubview:itemView];
            
        }
        [_Page addSubview:BackView_paixu];
        iscategaryShow=YES;
    }else
    {
        iscategaryShow=NO;
        [BackView_paixu removeFromSuperview];
    }
    
    
}

-(void)btn_paixuClick
{
    NSLog(@"排序");
    if (!isSortShow) {
        [BackView_paixu removeFromSuperview];
        BackView_paixu=[[UIView alloc] initWithFrame:CGRectMake(0, 40, _Page.frame.size.width, 35*self.classifys.count+self.classifys.count)];
        BackView_paixu.backgroundColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        for (int i=0; i<self.classifys.count; i++) {
            UIView * lastview=[BackView_paixu.subviews lastObject];
            UIView * itemView=[[UIView alloc] initWithFrame:CGRectMake(0, lastview.frame.origin.y+lastview.frame.size.height+1, BackView_paixu.frame.size.width, 35)];
            itemView.backgroundColor=[UIColor whiteColor];
            UIImageView * icon1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
            icon1.image=[UIImage imageNamed:imagearray2[i]];
            [itemView addSubview:icon1];
            UILabel * lbl_title1=[[UILabel alloc] initWithFrame:CGRectMake(icon1.frame.origin.x+icon1.frame.size.width+10, 10, 250, 15)];
            lbl_title1.font=[UIFont systemFontOfSize:14];
            lbl_title1.text=_classifys[i];
            [itemView addSubview:lbl_title1];
            UIButton * btn_defaultPaixu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemView.frame.size.width, 30)];
            btn_defaultPaixu.tag=i;
            [btn_defaultPaixu addTarget:self action:@selector(getOrderListData:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:btn_defaultPaixu];
            [BackView_paixu addSubview:itemView];
            
        }
        [_Page addSubview:BackView_paixu];
        isSortShow=YES;
    }else
    {
        isSortShow=NO;
        [BackView_paixu removeFromSuperview];
    }
}

-(void)btn_activeClick
{
    NSLog(@"促销活动");
    
    if (!isSortShow) {
        [BackView_paixu removeFromSuperview];
        BackView_paixu=[[UIView alloc] initWithFrame:CGRectMake(0, 40, _Page.frame.size.width, 35*self.sorts.count+self.sorts.count)];
        BackView_paixu.backgroundColor=[UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1.0];
        for (int i=0; i<self.sorts.count; i++) {
            UIView * lastView=[BackView_paixu.subviews lastObject];
            UIView * itemView=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, BackView_paixu.frame.size.width, 35)];
            itemView.backgroundColor=[UIColor whiteColor];
            UIImageView * icon1=[[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 15)];
            switch ([_sorts[i][@"actid"] intValue]) {
                case 2:
                    icon1.image=[UIImage imageNamed:@"fu"];
                    break;
                case 3:
                    icon1.image=[UIImage imageNamed:@"15"];
                    break;
                case 4:
                    icon1.image=[UIImage imageNamed:@"bi"];
                    break;
                case 5:
                    icon1.image=[UIImage imageNamed:@"jiang"];
                    break;
                case 6:
                    icon1.image=[UIImage imageNamed:@"zhi"];
                    break;
                case 7:
                    icon1.image=[UIImage imageNamed:@"xun"];
                    break;
                case 8:
                    icon1.image=[UIImage imageNamed:@"zheng"];
                    break;
                    
                default:
                    break;
            }
            
            [itemView addSubview:icon1];
            UILabel * lbl_title1=[[UILabel alloc] initWithFrame:CGRectMake(icon1.frame.origin.x+icon1.frame.size.width+10, 10, 250, 15)];
            lbl_title1.font=[UIFont systemFontOfSize:14];
            lbl_title1.text=_sorts[i][@"name"];
            [itemView addSubview:lbl_title1];
            UIButton * btn_defaultPaixu=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, itemView.frame.size.width, 30)];
            btn_defaultPaixu.tag=i;
            [btn_defaultPaixu addTarget:self action:@selector(GetActiveResList:) forControlEvents:UIControlEventTouchUpInside];
            [itemView addSubview:btn_defaultPaixu];
            [BackView_paixu addSubview:itemView];
        }
        [_Page addSubview:BackView_paixu];
        isSortShow=YES;
    }else
    {
        isSortShow=NO;
        [BackView_paixu removeFromSuperview];
    }
}

-(void)GetcateGrayList:(UIButton *)sender
{
    _category=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    [_tableView.header beginRefreshing];
    [BackView_paixu removeFromSuperview];
    iscategaryShow=NO;
    isAgain=YES;
}
-(void)getOrderListData:(UIButton *)sender
{
    
    if (sender.tag!=0) {
        _order=[NSString stringWithFormat:@"%ld",(long)sender.tag+1];
    }
    [_tableView.header beginRefreshing];
    [BackView_paixu removeFromSuperview];
    isSortShow=NO;
    isAgain=YES;
}

-(void)GetActiveResList:(UIButton * )sender
{
    
    _activity=[NSString stringWithFormat:@"%ld",(long)sender.tag];
    [_tableView.header beginRefreshing];
    
    [BackView_paixu removeFromSuperview];
    isActiveShow=NO;
    isAgain=YES;
}

/**
 *  判断当前时间是否在店铺营业时间段内
 *
 *  @param fromHour 开始营业时间
 *  @param toHour   结束营业时间
 *
 *  @return 返回bool
 */
- (BOOL)isBetweenFromHour:(id)fromHour toHour:(id)toHour
{
    if (fromHour!=[NSNull null]&&toHour!=[NSNull null]) {
        NSString * strFromhour=(NSString * )fromHour;
        NSArray * fromtimeArray=[strFromhour componentsSeparatedByString:@":"];
        NSString * strTohour=(NSString *)toHour;
        NSArray * totimeArray=[strTohour componentsSeparatedByString:@":"];
        NSDate *date8 = [self getCustomDateWithHour:[fromtimeArray[0] integerValue] andMinute:[fromtimeArray[1] integerValue]];
        NSDate *date23 = [self getCustomDateWithHour:[totimeArray[0] integerValue] andMinute:[totimeArray[1] integerValue]];
        NSDate *currentDate = [NSDate date];
        
        if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
        {
            NSLog(@"该时间在 %@-%@ 之间！", fromHour, toHour);
            return YES;
        }
        
    }
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour andMinute:(NSInteger)minute
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    [resultComps setMinute:minute];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}


@end

