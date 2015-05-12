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
#import "BGBangTableViewCell.h"


#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define KtextNum 6


@interface BGBangViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property(nonatomic,strong)NYSegmentedControl *segmentedControl;
@property(nonatomic,strong)UIView * Page;

@property (nonatomic, strong) NSArray *classifys;
@property (nonatomic, strong) NSArray *areas;
@property (nonatomic, strong) NSArray *sorts;

@end

@implementation BGBangViewController
{
    NSString * _page;
    NSString * _num;
    NSString * _sort;
    NSString * _oneid;
    NSString * _twoid;
    NSString * _threeid;
    NSArray * _TextArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _mytableBar.delegate=self;
    _mytableBar.selectedItem=_BGBang;
    
    //添加导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 64)];
    navigationBar.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    navigationBar.translucent=YES;
    _mynavigationItem = [[UINavigationItem alloc] initWithTitle:@"自动定位"];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Image-2"]
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self
//                                                                  action:@selector(clickLeftButton)];
    [navigationBar pushNavigationItem:_mynavigationItem animated:NO];
//    [_mynavigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    
    //添加Segmented Control
    UIView * lastView=[self.view.subviews lastObject];
    UIView * segmentView=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height, KWidth, 40)];
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
    _Page=[[UIView alloc] initWithFrame:CGRectMake(0,ViewHeight , KWidth, KHeight-ViewHeight-_mytableBar.frame.size.height)];
    [self.view addSubview:_Page];
    
    
    
    // 数据
    self.sorts=@[@"我要推荐"];
    self.areas = @[@"热门分类",@"汉餐",@"清真",@"早餐",@"午餐"];
    self.classifys = @[@"排序方式",@"已通过认证",@"销量最大",@"评价最高",@"价位高到低",@"价位低到高"];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    
    menu.delegate = self;
    menu.dataSource = self;
    [_Page addSubview:menu];
    

    [self MakePramAndGetData:@"1" andNum:@"2" andSort:@"1" andOneid:@"1" andTwoid:@"2" andThreeid:@"9"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    NSLog(@"%ld",item.tag);
    switch (item.tag) {
        case 1:
        {
            [self.view removeFromSuperview];
        }
            break;
        case 2:
        {
            
        }
            break;
            
        default:
            break;
    }
    _mytableBar.selectedItem=_BGBang;
}

-(void)clickLeftButton
{
    [self.view removeFromSuperview];
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
        NSLog(@"点击了 %ld - %ld 项目",indexPath.column,indexPath.row);
//        if (0!=indexPath.row) {
//            for (UIView * item in _tableView.subviews) {
//                [item removeFromSuperview];
//            }
//            switch (indexPath.column) {
//                case 0:
//                    _order= [NSString stringWithFormat:@"%ld",(long)indexPath.row];
//                    [self GetrestaurantListPage:_page andNum:_num andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
//                    break;
//                case 1:
//                    _category=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
//                    [self GetrestaurantListPage:_page andNum:_num andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
//                    break;
//                case 2:
//                    _activity=[NSString stringWithFormat:@"%ld",(long)indexPath.row];
//                    [self GetrestaurantListPage:_page andNum:_num andOrder:_order andActivity:_activity andCategory:_category andlat:_lat andlong:_long];
//                    break;
//                default:
//                    break;
//            }
//        }
    }
}

-(void)MakePramAndGetData:(NSString *)page andNum:(NSString *)num andSort:(NSString *)sort andOneid:(NSString *)oneid andTwoid:(NSString *)twoid andThreeid:(NSString *)threeid
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
              threeid,@"threeid", nil];
    }
    _page=page;
    _num=num;
    _sort=sort;
    _oneid=oneid;
    _twoid=twoid;
    _threeid=threeid;
    [dataprovider setDelegateObject:self setBackFunctionName:@"BuildTextItem:"];
    [dataprovider GetBGBangText:prm];
}

-(void)BuildTextItem:(id)dict
{
    NSLog(@"%@",dict);
    if (dict) {
        _TextArray =dict[@"data"];
        UIView * lastView =[_Page.subviews lastObject];
        UITableView * mytableView =[[UITableView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height, _Page.frame.size.width, _Page.frame.size.height-lastView.frame.size.height)];
        
        mytableView.delegate=self;
        mytableView.dataSource=self;
        [_Page addSubview:mytableView];
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
        cell.logoImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_TextArray[indexPath.row][@"reslogo"]]]];
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

-(void)SegMentControlClick
{
    NSLog(@"dsfsadfa%ld",(long)self.segmentedControl.selectedSegmentIndex);
    if (1==self.segmentedControl.selectedSegmentIndex) {
        _Page.hidden=YES;
        NSLog(@"other");
    }
    else
    {
        _Page.hidden=NO;
    }
}

@end
