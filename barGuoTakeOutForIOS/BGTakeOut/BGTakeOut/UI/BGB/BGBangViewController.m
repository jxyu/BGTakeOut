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

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define KtextNum 6
#define KURL @"http://121.42.139.60/baguo/"


@interface BGBangViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property(nonatomic,strong)NYSegmentedControl *segmentedControl;
@property(nonatomic,strong)UIView * Page;

@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;

@property (nonatomic, strong) NSArray *cates;
@property (nonatomic, strong) NSArray *movices;
@property (nonatomic, strong) NSArray *hostels;

@end

@implementation BGBangViewController
{
    UITableView * mytableView;
    NSString * _page;
    NSString * _num;
    NSString * _sort;
    NSString * _oneid;
    NSString * _twoid;
    NSString * _threeid;
    NSString * _lat;
    NSString * _longprm;
    NSArray * _TextArray;
    NSDictionary *dictionary;
    
    NSMutableArray *MenuFirstTypeArray;
    NSMutableArray * MenuSencondTypeArrau;
    BOOL isAgain;//标记是否为第二次请求列表数据
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    // 数据
    self.classifys = @[@"美食",@"今日新单",@"电影",@"酒店"];
    self.cates = @[@"自助餐",@"快餐",@"火锅",@"日韩料理",@"西餐",@"烧烤小吃"];
    self.movices = @[@"内地剧",@"港台剧",@"英美剧"];
    self.hostels = @[@"经济酒店",@"商务酒店",@"连锁酒店",@"度假酒店",@"公寓酒店"];
    self.areas = @[@"全城",@"芙蓉区",@"雨花区",@"天心区",@"开福区",@"岳麓区"];
    self.sorts = @[@"默认排序",@"离我最近",@"好评优先",@"人气优先",@"最新发布"];
    isAgain=NO;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    dictionary =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
   
    
    if (dictionary[@"userid"]) {
        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
        //添加Segmented Control
        UIView * lastView=[self.view.subviews lastObject];
        UIView * segmentView=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, KWidth, 40)];
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
        //self.segmentedControl.segmentIndicatorInset = 2.0f;
        self.segmentedControl.cornerRadius=16.0f;
        self.segmentedControl.segmentIndicatorGradientTopColor = [UIColor whiteColor];
        self.segmentedControl.segmentIndicatorGradientBottomColor = [UIColor whiteColor];
        self.segmentedControl.drawsSegmentIndicatorGradientBackground = YES;
        self.segmentedControl.segmentIndicatorBorderWidth = 0.0f;
        self.segmentedControl.selectedSegmentIndex = 0;
        [self.segmentedControl sizeToFit];
        self.segmentedControl.frame=CGRectMake(22, 2, KWidth-44, 36);
        [segmentView addSubview:_segmentedControl];
        [self.view addSubview:segmentView];
        
        lastView=[self.view.subviews lastObject];
        CGFloat ViewHeight=lastView.frame.origin.y+lastView.frame.size.height;
        _Page=[[UIView alloc] initWithFrame:CGRectMake(0,ViewHeight , KWidth, KHeight-ViewHeight-49)];
        [self.view addSubview:_Page];
        
        
        
        // 数据
        self.sorts=@[@"我要推荐"];
        self.areas = @[@"排序方式"];
        self.classifys = @[@"热门分类"];
        NSDictionary * dict=@{@"name":@"热门分类"};
        MenuFirstTypeArray=[[NSMutableArray alloc] initWithObjects:dict, nil];
        
        // 添加下拉菜单
        DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
        
        menu.delegate = self;
        menu.dataSource = self;
        [_Page addSubview:menu];
        
        [[CCLocationManager shareLocation] getLocationCoordinate:^(CLLocationCoordinate2D locationCorrrdinate) {
            [self MakePramAndGetData:@"1" andNum:@"8" andSort:@"1" andOneid:@"1" andTwoid:@"2" andThreeid:@"9" anduserid:dictionary[@"userid"] andlat:[NSString  stringWithFormat:@"%f",locationCorrrdinate.latitude] andlong:[NSString stringWithFormat:@"%f",locationCorrrdinate.longitude]];
        }];
        
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


#pragma mark 返回菜单数量
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetFirstTypeBackCall:"];
    [dataprovider GetBGBangTypewithtype:@"0" andupid:@"0"];
    return 3;
}

#pragma mark 返回每个菜单下油多少行
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    
    if (column == 0) {
        return MenuFirstTypeArray.count;
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
        return MenuFirstTypeArray[indexPath.row][@"name"];
    } else if (indexPath.column == 1){
        return self.areas[indexPath.row];
    } else {
        return self.sorts[indexPath.row];
    }
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    if (column == 0) {
        if (row == 0) {
            NSArray * arrayitem=[[NSArray alloc] initWithArray:MenuSencondTypeArrau[row][@"data"]];
            return arrayitem.count;
        }
        else if (row == 2){
            return self.movices.count;
        } else if (row == 3){
            return self.hostels.count;
        }
    }
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        if (indexPath.row == 0) {
            NSArray * arraytofirst=[[NSArray alloc] initWithArray:MenuSencondTypeArrau[indexPath.row][@"data"]];
            return arraytofirst[indexPath.item][@"name"];
        }
        else if (indexPath.row == 2){
            return self.movices[indexPath.item];
        } else if (indexPath.row == 3){
            return self.hostels[indexPath.item];
        }
    }
    return nil;
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.item >= 0) {
        //        NSLog(@"点击了 %ld - %ld - %ld 项目",indexPath.column,indexPath.row,indexPath.item);
    }else {
        NSLog(@"点击了 %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row);
        //!!!: 跳转我要推荐页面
        if(indexPath.column==2&&indexPath.row==0){
            WantRecommendViewController* wantRecommendVC=[[WantRecommendViewController alloc] init];
            [self.navigationController pushViewController:wantRecommendVC animated:YES];
        }
    }
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
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        [SVProgressHUD dismiss];
        _TextArray =dict[@"data"];
        if (!isAgain) {
            UIView * lastView =[_Page.subviews lastObject];
            mytableView =[[UITableView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height, _Page.frame.size.width, _Page.frame.size.height-lastView.frame.size.height)];
            
            mytableView.delegate=self;
            mytableView.dataSource=self;
            [_Page addSubview:mytableView];
        }
        else
        {
            [mytableView reloadData];
        }
        
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
    return _TextArray.count;
}

// 实现每一行Cell的内容，tableView重用机制
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=100.0;
    return height;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.BGBangDetialVC=[[BGBangDetialViewController alloc] init];
    _BGBangDetialVC.articleid=_TextArray[indexPath.row][@"articleid"];
    _BGBangDetialVC.userid=dictionary[@"userid"];
    [self.navigationController pushViewController:_BGBangDetialVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)SegMentControlClick
{
    NSLog(@"dsfsadfa%ld",(long)self.segmentedControl.selectedSegmentIndex);
    if (1==self.segmentedControl.selectedSegmentIndex) {
//        _Page.hidden=YES;
        NSLog(@"other");
        NSDictionary * prm=@{@"userid":dictionary[@"userid"],@"page":@"1",@"num":@"8"};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"OtherClickBackCall:"];
        [dataprovider BGBangXintuijian:prm];
    }
    else
    {
//        _Page.hidden=NO;
        [self MakePramAndGetData:_page andNum:_num andSort:_sort andOneid:_oneid andTwoid:_twoid andThreeid:_threeid anduserid:dictionary[@"userid"] andlat:_lat andlong:_longprm];
        isAgain=YES;
    }
}

-(void)BGBangShare:(UIButton *)sender
{
    //分享巴国榜
}

-(void)GetFirstTypeBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
       NSArray * MenuArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        for (int i=0; i<MenuArray.count; i++) {
            [MenuFirstTypeArray addObject:MenuArray[i]];
                DataProvider * dataprovider=[[DataProvider alloc] init];
                [dataprovider setDelegateObject:self setBackFunctionName:@"GetSecondTypeBackCall:"];
                [dataprovider GetBGBangTypewithtype:@"1" andupid:MenuFirstTypeArray[i][@"oneid"]];
        }
    }
}
-(void)GetSecondTypeBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        NSArray * MenuArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        
        [MenuSencondTypeArrau addObject:MenuArray];
//        for (int i=0;MenuSencondTypeArrau.count ; i++) {
//            DataProvider * dataprovider=[[DataProvider alloc] init];
//            [dataprovider setDelegateObject:self setBackFunctionName:@"GetthirdTypeBackCall:"];
//            [dataprovider GetBGBangTypewithtype:@"1" andupid:MenuSencondTypeArrau[i][@"oneid"]];
//        }
    }
}
-(void)GetthirdTypeBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        NSArray * MenuArray=[[NSArray alloc] initWithArray:dict[@"data"]];
        [MenuSencondTypeArrau addObject:MenuArray];
        [SVProgressHUD dismiss];
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
    }
}

-(void)OtherClickBackCall:(id)dict
{
    NSLog(@"%@",dict);
    _TextArray=dict[@"data"];
    [mytableView reloadData];
}

@end
