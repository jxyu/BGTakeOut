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
    
    //添加导航栏
    [self addLeftButton:@"ic_actionbar_back.png"];
    tabledata=[[NSMutableArray alloc] init];
//    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    
    //添加Segmented Control
    UIView * lastView=[self.view.subviews lastObject];
    UIView * segmentView=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 40)];
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
    self.areas = @[@"热门分类",@"全部",@"巴国推荐",@"超市",@"汉餐",@"清真",@"早餐",@"午餐"];
    self.classifys = @[@"排序方式",@"已通过认证",@"销量最大",@"评价最高",@"价位高到低",@"价位低到高"];
    imagearray1=@[@"zong.png",@"jian.png",@"dian.png",@"han.png",@"qing.png",@"zao.png",@"wu.png"];
    imagearray2=@[@"xu.png",@"zheng.png",@"xiaoliang.png",@"timer.png",@"jiawei.png"];
//    imagearray3=@[@""]
    
    // 添加下拉菜单
    
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
//    menu.im
    menu.delegate = self;
    menu.dataSource = self;
    [_Page addSubview:menu];
    
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
    _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-y)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
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
        [self GetrestaurantListPage:@"1" andNum:_num andOrder:_order andActivity:_activity andCategory:@"8" andlat:_lat andlong:_long];
        [_tableView reloadData];
    }
    else
    {
//        _Page.hidden=NO;
        [self GetrestaurantListPage:@"1" andNum:_num andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
        [_tableView reloadData];
    }
}


#pragma mark 返回菜单数量
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return 3;
}

#pragma mark 返回每个菜单下油多少行
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return self.classifys.count;
    }else if (column == 1){
        return self.areas.count;
    }else {
        return self.sorts.count;
    }
}
#pragma mark 给每行设置数据
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return self.classifys[indexPath.row];
    } else if (indexPath.column == 1){
        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
//        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row);
        if (0!=indexPath.row) {
            for (UIView * item in _tableView.subviews) {
                [item removeFromSuperview];
            }
            switch (indexPath.column) {
                case 0:
                    _order= [NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    [self GetrestaurantListPage:_page andNum:_num andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
                    break;
                case 1:
                    _category=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    [self GetrestaurantListPage:_page andNum:_num andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
                    break;
                case 2:
                    _activity=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
                    [self GetrestaurantListPage:_page andNum:_num andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
                    break;
                default:
                    break;
            }
        }
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
    NSArray * activityArray ;
    NSMutableArray * activityData=[[NSMutableArray alloc] init];
    if ([dict[@"status"] intValue]==1) {
        activityArray=dict[@"data"];
        [activityData addObject:[NSString stringWithFormat:@"促销活动"]];
        for (int i=0; i<activityArray.count; i++) {
            [activityData addObject:[NSString stringWithFormat:@"%@",activityArray[i][@"name"]]];
        }
        self.sorts=activityData;
    }
}
-(void)bulidrestaurantList:(id)dict
{
    if ([dict[@"status"]intValue]==1) {
        NSLog(@"餐厅数据%@",dict);
        Canting=[NSArray arrayWithArray:dict[@"data"]];
        for (int i=0; i<Canting.count; i++) {
            [tabledata addObject:Canting[i]];
        }
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
    }else{
        [_tableView.footer endRefreshing];
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"请检查网络" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];
    }

        if (!isAgain) {
//            UIView * lastView=[_Page.subviews lastObject];
//            CGFloat y=lastView.frame.origin.y+lastView.frame.size.height;
//            _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-y)];
//            _tableView.delegate=self;
//            _tableView.dataSource=self;
//            
//            [_Page addSubview:_tableView];
//            __weak typeof(self) weakself=self;
//            [_tableView addLegendFooterWithRefreshingBlock:^{
//                [weakself loadNewData];
//            }];
        }
    
    [SVProgressHUD dismiss];
    
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
        [cell.Canting_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,tabledata[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        if ([tabledata[indexPath.row][@"isauthentic"] boolValue]) {
            cell.Renzheng.image=[UIImage imageNamed:@"renzheng.png"];
        }
        cell.CantingName.text=tabledata[indexPath.row][@"name"];
        cell.Adress.text=tabledata[indexPath.row][@"addressname"];
        cell.starRatingView =[[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0 , cell.PingjiaView.frame.size.width, cell.PingjiaView.frame.size.height) numberOfStar:5 andlightstarnum:[tabledata[indexPath.row][@"totalcredit"] intValue]];
        [cell.PingjiaView addSubview:cell.starRatingView];
        UIButton * zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0,0 , cell.PingjiaView.frame.size.width, cell.PingjiaView.frame.size.height)];
        [cell.PingjiaView addSubview:zhezhao];
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
    CGFloat height=100.0;
//    CGFloat height=180.0+(activearray.count-1)*30;
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
    if ([@"1" isEqual:Canting[indexPath.row][@"isopen"]]) {
        NSString * restid=Canting[indexPath.row][@"resid"];
        _myCantingView=[[CantingInfoViewController alloc] initWithNibName:@"CantingInfoViewController" bundle:[NSBundle mainBundle]];
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

@end

