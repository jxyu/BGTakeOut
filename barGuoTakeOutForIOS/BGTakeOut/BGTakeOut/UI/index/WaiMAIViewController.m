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


#define KCantingNum 5
#define KURL @"http://121.42.139.60/baguo/"

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
    
    NSArray * Canting;
    
    NSArray * activearray;
    
    NSArray * imagearray1;
    NSArray * imagearray2;
    NSArray * imagearray3;
    BOOL isAgain;
    
    NSInteger table_page;
    NSMutableArray * tabledata;
    BOOL iscategaryShow;
    BOOL isSortShow;
    BOOL isActiveShow;
    UIView * BackView_paixu;
    
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
    _order=@"1";
    _category=@"1";
    _activity=@"1";
    isActiveShow=NO;
    iscategaryShow=NO;
    isSortShow=NO;
    
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    tabledata=[[NSMutableArray alloc] init];
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        _lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude] ;
        _long=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        _page=[NSString stringWithFormat:@"%d",1];
        _num =[NSString stringWithFormat:@"%d",KCantingNum];
        _order=[NSString stringWithFormat:@"%d",1];
        _activity=[NSString stringWithFormat:@"%d",1];
        _category=[NSString stringWithFormat:@"%d",1];
        [self GetrestaurantListPage:@"1" andNum:[NSString stringWithFormat:@"%d",KCantingNum] andOrder:@"1" andActivity:@"1" andCategory:@"1" andlat:_lat andlong:_long];
    }];
    
    
    //添加导航栏
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self setBarTitle:@"自动定位"] ;
    UIImageView * image_left=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-45, _lblTitle.frame.origin.y+13, 14, 15)];
    image_left.tag=1111;
    image_left.image=[UIImage imageNamed:@"index_location"];
    [self.view addSubview:image_left];
    UIImageView * image_right=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2+35, _lblTitle.frame.origin.y+18, 12, 9)];
    image_right.tag=1112;
    image_right.image=[UIImage imageNamed:@"index_down"];
    [self.view addSubview:image_right];
    [[CCLocationManager shareLocation] getAddress:^(NSString *addressString) {
        NSLog(@"%@",addressString);
        NSArray *array = [addressString componentsSeparatedByString:@"省"]; //从字符A中分隔成2个元素的数组
        [self setBarTitle:[array[1] stringByReplacingOccurrencesOfString:@"(null)" withString:@""]] ;
        image_left.frame=CGRectMake(_lblTitle.frame.origin.x-12, image_left.frame.origin.y, 14, 15);
        image_right.frame=CGRectMake(image_left.frame.origin.x+130, image_right.frame.origin.y, 12, 9);
        
        
        //        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        //            _lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude] ;
        //            _long=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        //            _page=[NSString stringWithFormat:@"%d",1];
        //            _num =[NSString stringWithFormat:@"%d",KCantingNum];
        //            _order=[NSString stringWithFormat:@"%d",1];
        //            _activity=[NSString stringWithFormat:@"%d",1];
        //            _category=[NSString stringWithFormat:@"%d",1];
        //            [self GetrestaurantListPage:@"1" andNum:[NSString stringWithFormat:@"%d",KCantingNum] andOrder:@"1" andActivity:@"1" andCategory:@"1" andlat:_lat andlong:_long];
        //        }];
        
        
    }];
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
    self.areas = @[@"全部",@"巴国推荐",@"超市",@"汉餐",@"清真",@"早餐",@"午餐",@"其他"];
    self.classifys = @[@"默认排序",@"已通过认证",@"距离最近",@"销量最大",@"评价最高",@"价位高到低",@"价位低到高"];
    imagearray1=@[@"zong.png",@"jian.png",@"dian.png",@"han.png",@"qing.png",@"zao.png",@"wu.png",@"ling.png"];
    imagearray2=@[@"xu.png",@"zheng.png",@"langWay@2x.png",@"xiaoliang.png",@"timer.png",@"jiawei.png",@"jiawei.png"];
    //    imagearray3=@[@""]
    
    // 添加下拉菜单
    
    //    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    ////    menu.im
    //    menu.delegate = self;
    //    menu.dataSource = self;
    //    [_Page addSubview:menu];
    
    
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
    [btn_paixu setTitle:@"默认排序" forState:UIControlStateNormal];
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
    
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-y-49)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_Page addSubview:_tableView];
    __weak typeof(self) weakself=self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    
    [self loadNewData];
    
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
        [self GetrestaurantListPage:@"1" andNum:_num andOrder:_order andActivity:_activity andCategory:@"8" andlat:_lat andlong:_long];
        [_tableView reloadData];
    }
    else
    {
        //        _Page.hidden=NO;
        isAgain=YES;
        [self GetrestaurantListPage:@"1" andNum:_num andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
        [_tableView reloadData];
    }
}



-(void)GetActivityes
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetActivityData:"];
    [dataprovider GetActivityList];
}

-(void)GetrestaurantListPage:(NSString *)page andNum:(NSString*)num andOrder:(NSString*)order andActivity:(NSString*)activity andCategory:(NSString *)category andlat:(NSString*)alat andlong:(NSString *)along
{
    NSDictionary * prm;
    DataProvider * dataprovider=[[DataProvider alloc] init];
    //    获取当前的经纬度
    if (page && num && order && activity && category) {
        prm =[NSDictionary dictionaryWithObjectsAndKeys:
              page,@"page",
              num,@"num",
              order,@"order",
              activity,@"activity",
              category,@"category",
              alat,@"lat",
              along,@"long", nil];
    }
    [dataprovider setDelegateObject:self setBackFunctionName:@"bulidrestaurantList:"];
    [dataprovider GetrestaurantList:prm];
    table_page++;
}



-(void)GetActivityData:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        self.sorts=dict[@"data"];
    }
}
-(void)bulidrestaurantList:(id)dict
{
    [SVProgressHUD dismiss];
    if ([dict[@"status"]intValue]==1) {
        NSLog(@"餐厅数据%@",dict);
        if (!isAgain) {
            Canting=[NSArray arrayWithArray:dict[@"data"]];
            for (int i=0; i<Canting.count; i++) {
                [tabledata addObject:Canting[i]];
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
            
        }else
        {
            tabledata=dict[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        }
    }else{
        
        [SVProgressHUD showErrorWithStatus:@"没有更多数据" maskType:SVProgressHUDMaskTypeBlack];
    }
//    [_tableView reloadData];
    [_tableView.footer endRefreshing];
    
    
}



// tableView分区数量，默认为1，可为其设置为多个列
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// tableView每个列的行数，可以为各个列设置不同的行数，根据section的值判断即可
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tabledata.count;
}

// 实现每一行Cell的内容，tableView重用机制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        activearray=[[NSArray alloc] initWithArray:tabledata[indexPath.row][@"activities"]];
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
        [cell initLayout];
        [cell.Canting_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,tabledata[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.Canting_icon.layer.masksToBounds=YES;
        cell.Canting_icon.layer.cornerRadius=4;
        cell.layer.borderWidth=1;
        cell.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]);
        if ([tabledata[indexPath.row][@"isauthentic"] boolValue]) {
            cell.Renzheng.image=[UIImage imageNamed:@"renzheng.png"];
        }
        cell.CantingName.text=tabledata[indexPath.row][@"name"];
        cell.Adress.text=tabledata[indexPath.row][@"addressname"];
        cell.starRatingView.rating=[tabledata[indexPath.row][@"totalcredit"] intValue];
        //        cell.starRatingView =[[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0 , cell.PingjiaView.frame.size.width, cell.PingjiaView.frame.size.height) numberOfStar:5 andlightstarnum:[tabledata[indexPath.row][@"totalcredit"] intValue]];
        //        [cell.PingjiaView addSubview:cell.starRatingView];
        //        UIButton * zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0,0 , cell.PingjiaView.frame.size.width, cell.PingjiaView.frame.size.height)];
        //        [cell.PingjiaView addSubview:zhezhao];
        //        for (int i=0; i<activearray.count; i++) {//此处，鲁森说cell的下边不要active了，所以注释掉
        //            UIImageView * img_icon;
        //            switch ([activearray[i][@"actid"] intValue]) {
        //                case 1:
        //
        //                    break;
        //                case 2:
        //                    img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, i*20+5, 15, 15)];
        //                    img_icon.image=[UIImage imageNamed:@"fu.png"];
        //                    break;
        //                case 3:
        //                    img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, i*20+5, 15, 15)];
        //                    img_icon.image=[UIImage imageNamed:@"15.png"];
        //                    break;
        ////                case 4:
        ////                    <#statements#>
        ////                    break;
        ////                case 5:
        ////                    <#statements#>
        ////                    break;
        ////                case 6:
        ////                    <#statements#>
        ////                    break;
        //                case 7:
        //                    img_icon=[[UIImageView alloc] initWithFrame:CGRectMake(10, i*20+5, 15, 15)];
        //                    img_icon.image=[UIImage imageNamed:@"xun.png"];
        //                    break;
        ////                case 8:
        ////                    <#statements#>
        ////                    break;
        //
        //                default:
        //                    break;
        //            }
        //
        //            UILabel * lbl_active=[[UILabel alloc] initWithFrame:CGRectMake(40, i*20+5, 200, 18)];
        //            lbl_active.text=activearray[i][@"name"];
        //            lbl_active.font=[UIFont systemFontOfSize:13];
        //            lbl_active.textColor=[UIColor grayColor];
        //            cell.CantingActive.frame=CGRectMake(cell.CantingActive.frame.origin.x, cell.CantingActive.frame.origin.y, cell.CantingActive.frame.size.width, cell.CantingActive.frame.size.height+20*(i-1));
        //            [cell.CantingActive addSubview:img_icon];
        //            [cell.CantingActive addSubview:lbl_active];
        //        }
        
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=110.0;
    //    CGFloat height=180.0+(activearray.count-1)*30;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    if ([@"1" isEqual:tabledata[indexPath.row][@"isopen"]])//&&[self isBetweenFromHour:tabledata[indexPath.row][@"start"] toHour:tabledata[indexPath.row][@"end"]]
    {
        NSString * restid=tabledata[indexPath.row][@"resid"];
        _myCantingView=[[CantingInfoViewController alloc] initWithNibName:@"CantingInfoViewController" bundle:[NSBundle mainBundle]];
        _myCantingView.beginprice=tabledata[indexPath.row][@"begindeliveryprice"];
        _myCantingView.resid=restid;
        _myCantingView.peisongData=tabledata[indexPath.row][@"deliveryprice"];
        _myCantingView.name=tabledata[indexPath.row][@"name"];
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

-(void)loadNewData{
    [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
        _lat=[NSString stringWithFormat:@"%f",locationCorrrdinate.latitude] ;
        _long=[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude];
        _page=[NSString stringWithFormat:@"%d",1];
        _num =[NSString stringWithFormat:@"%d",KCantingNum];
        _order=[NSString stringWithFormat:@"%d",1];
        _activity=[NSString stringWithFormat:@"%d",1];
        _category=[NSString stringWithFormat:@"%d",1];
        [self GetrestaurantListPage:[NSString stringWithFormat:@"%ld",(long)table_page] andNum:[NSString stringWithFormat:@"%d",KCantingNum] andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
    }];
    
    
}

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
            btn_defaultPaixu.tag=0;
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
            btn_defaultPaixu.tag=0;
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
            btn_defaultPaixu.tag=[_sorts[i][@"actid"]intValue];
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
    [self GetrestaurantListPage:@"1" andNum:[NSString stringWithFormat:@"%d",KCantingNum] andOrder:_order andActivity:_activity andCategory:[NSString stringWithFormat:@"%ld",(long)sender.tag] andlat:_lat andlong:_long];
    [BackView_paixu removeFromSuperview];
    iscategaryShow=NO;
    isAgain=YES;
}
-(void)getOrderListData:(UIButton *)sender
{
    [self GetrestaurantListPage:@"1" andNum:[NSString stringWithFormat:@"%d",KCantingNum] andOrder:[NSString stringWithFormat:@"%ld",(long)sender.tag] andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
    [BackView_paixu removeFromSuperview];
    isSortShow=NO;
    isAgain=YES;
}

-(void)GetActiveResList:(UIButton * )sender
{
    [self GetrestaurantListPage:@"1" andNum:[NSString stringWithFormat:@"%d",KCantingNum] andOrder:_order andActivity:[NSString stringWithFormat:@"%ld",(long)sender.tag] andCategory:_category andlat:_lat andlong:_long];
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

