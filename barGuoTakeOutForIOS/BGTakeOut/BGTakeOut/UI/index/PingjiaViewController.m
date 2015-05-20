//
//  PingjiaViewController.m
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/16.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "PingjiaViewController.h"
#import "HMSegmentedControl.h"
#import "ShopPingjia.h"
#import "PingjiaTableViewCell.h"
#import "DataProvider.h"
#import "MJRefresh.h"
#define per_page 1

@interface PingjiaViewController ()
{NSMutableArray *tableData;  //tableView数据存放数组
    NSMutableArray* alltableData;
    //    DataProvider* dataProvider;
    //    DataProvider* allDataProvider;
    NSInteger table_page;
    NSInteger all_table_page;
    
}

@end

@implementation PingjiaViewController
#pragma mark - vc-lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    table_page=1;
    all_table_page=1;
    tableData=[[NSMutableArray alloc] init];
    alltableData=[[NSMutableArray alloc] init ];
    [self initView];
    [self loadAllNewData];
    [self loadNewData];
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeBlack];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)initView{
    _allTableview=[[UITableView alloc] initWithFrame:CGRectMake(0, 104, SCREEN_WIDTH, SCREEN_HEIGHT-104) style:UITableViewStyleGrouped];
    _allTableview.hidden=YES;
    _tableView.hidden=NO;
    _allTableview.tag=1111;
    _tableView.tag=1000;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _allTableview.delegate=self;
    _allTableview.dataSource=self;
    [self.view addSubview:_allTableview];
    
    __weak typeof(self) weakself=self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    [_allTableview addLegendFooterWithRefreshingBlock:^{
        [weakself loadAllNewData];
    }];
    [_tableView.legendHeader beginRefreshing];
    [_allTableview.legendHeader beginRefreshing];
    
    
    _lblTitle.text=@"用户评价";
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    
    
    // Segmented control with scrolling
    HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"有内容的评价", @"全部评价"]];
    segmentedControl1.frame = CGRectMake(0, 60, SCREEN_WIDTH, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.selectionIndicatorColor=navi_bg_color;
    segmentedControl1.verticalDividerEnabled = YES;
    segmentedControl1.verticalDividerColor = [UIColor groupTableViewBackgroundColor];
    segmentedControl1.verticalDividerWidth = 0.8f;
    
    [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        return attString;
    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl1];
    
    
}
-(void)loadNewData{
    DataProvider* dataProvider=[[DataProvider alloc]init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"getCommentsSuccess:"];
    [dataProvider getCommentsWihtPage:table_page num:per_page resid:[_resid integerValue] iscontaintext
                                     :1];
    
    table_page++;
    
}
-(void)loadAllNewData{
    DataProvider* allDataProvider=[[DataProvider alloc] init];
    [allDataProvider setDelegateObject:self setBackFunctionName:@"getAllCommentsSuccess:"];
    [allDataProvider getCommentsWihtPage:all_table_page num:per_page resid:[_resid integerValue] iscontaintext:0];
    all_table_page++;
    
}
#pragma mark - dataprovider-delegate

-(void)getOrderDetail:(UIButton*)sender{
    UITableView*tableview=(UITableView*)  [[sender superview] superview] ;
    NSInteger section = sender.tag;
    DataProvider* orderDetailDP=[[DataProvider alloc] init];
    [orderDetailDP setDelegateObject:self setBackFunctionName:@"getOrderDetailSuccess:"];
    if (tableview.tag==1000) {
        NSString* ordernum=[[tableData objectAtIndex:section] objectForKey:@"ordernum"];
        
        
        [orderDetailDP getOrderDetailWithOrdernum:ordernum];
    }else if(tableview.tag==1111){
        
        NSString* ordernum=[[alltableData objectAtIndex:section] objectForKey:@"ordernum"];
        [orderDetailDP getOrderDetailWithOrdernum:ordernum];
    }
    
}
-(void)getOrderDetailSuccess:(NSDictionary*)dict{
    if ([[dict objectForKey:@""] isEqualToString:@"1"]) {
        NSString* content=[[dict objectForKey:@"data"] objectForKey:@"goodsdetail"];
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"订单内容" message:content delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)getAllCommentsSuccess:(NSDictionary*)dict{
    [SVProgressHUD dismiss];
    
    if(![[dict objectForKey:@"data"]  isKindOfClass:[NSString class]]){
        NSArray* comments=    (NSArray*)[[dict objectForKey:@"data"] objectForKey:@"data"];
        
        for (int i=0; i<comments.count; i++) {
            [alltableData addObject:comments[i]];
        }
        [_allTableview reloadData];
        [_allTableview.footer endRefreshing];
    }else{
                    [_allTableview.footer endRefreshing];
    }
    
}
-(void)getCommentsSuccess:(NSDictionary*)dict{
    [SVProgressHUD dismiss];
    if(![[dict objectForKey:@"data"]  isKindOfClass:[NSString class]]){
        NSArray* comments=    (NSArray*)[[dict objectForKey:@"data"] objectForKey:@"data"];
        for (int i=0; i<comments.count; i++) {
            [tableData addObject:comments[i]];
        }
        [_tableView reloadData];
        [_tableView.footer endRefreshing];
        
    }else{
                [_tableView.footer endRefreshing];
        
    }
}

#pragma mark - segment-method
-(void)segmentedControlChangedValue:(id)sender{
    HMSegmentedControl*h=(HMSegmentedControl*)sender;
    NSInteger i=    h.selectedSegmentIndex;
    DLog(@"index:%ld",i);
    if (i==0) {
        _tableView.hidden=NO;
        _allTableview.hidden=YES;
    }else if(i==1){
        _tableView.hidden=YES;
        _allTableview.hidden=NO;
    }
}

#pragma mark - tableview-delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]animated:YES];
}

#pragma mark - tableview-datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==1000) {
        static NSString *TableIdentifier = @"pingjiaTableIdentifier";
        
        PingjiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                      TableIdentifier ];
        if (cell == nil) {
            cell  = [[PingjiaTableViewCell alloc] initWithReuseIdentifier:TableIdentifier];
        }
        
        cell.starRatingView.rating=[[[tableData objectAtIndex:indexPath.section] objectForKey:@"starnum"] integerValue];
NSString* phone=        [self phoneNumToSecret:[[tableData objectAtIndex:indexPath.section] objectForKey:@"username"]];
        cell.usernameLbl.text=phone;
        
        
        [cell setPingjiaText:[[tableData objectAtIndex:indexPath.section] objectForKey:@"content"]];
        return cell;
    }else if(tableView.tag==1111){
        static NSString *TableIdentifier = @"pingjiaallTableIdentifier";
        
        PingjiaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                      TableIdentifier ];
        if (cell == nil) {
            cell  = [[PingjiaTableViewCell alloc] initWithReuseIdentifier:TableIdentifier];
        }
        
        cell.starRatingView.rating=[[[alltableData objectAtIndex:indexPath.section] objectForKey:@"starnum"] integerValue];
        NSString* phone=        [self phoneNumToSecret:(NSString*)[[alltableData objectAtIndex:indexPath.section] objectForKey:@"username"]];
        cell.usernameLbl.text=phone;
        NSString* content=(NSString*)[[alltableData objectAtIndex:indexPath.section] objectForKey:@"content"];
        if ([content isEqualToString:@""]) {
            [cell setPingjiaText:
             @"无评论内容"];
        }else{
            [cell setPingjiaText:
             [NSString stringWithFormat:@"%@",[[alltableData objectAtIndex:indexPath.section] objectForKey:@"content"]]];}
        return cell;
    }
    
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger num;
    if (tableView.tag==1111) {
        num =alltableData.count;
        DLog(@"section-num:%ld",num);
    }else if(tableView.tag==1000){
        num=tableData.count;
    }
    return num;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PingjiaTableViewCell* pingjiaCell=    (PingjiaTableViewCell*)    [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return pingjiaCell.frame.size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 40.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view=[[UIView alloc] init];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    return view;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    UIView* view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UILabel* dateLbl=[[UILabel alloc] init];
    dateLbl.font=[UIFont systemFontOfSize:15.0];
    dateLbl.textColor=[UIColor lightGrayColor];
    dateLbl.frame=CGRectMake(8, 8, 200, 22);
    if (tableView.tag==1000) {
        dateLbl.text=[[tableData objectAtIndex:section] objectForKey:@"updatetime"];;
    }else if(tableView.tag==1111) {
        dateLbl.text=[[alltableData objectAtIndex:section] objectForKey:@"updatetime"];
    }
    
    [view addSubview:dateLbl];
    
    UIView* divider=[[UIView alloc] init];
    divider.frame=CGRectMake(SCREEN_WIDTH*2/3, 0, 1, 40);
    divider.backgroundColor=tableView.separatorColor;
    [view addSubview:divider];
    
    UIView* topDivider=[[UIView alloc] init];
    topDivider.frame=CGRectMake(0, 0, SCREEN_WIDTH, 1);
    topDivider.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [view addSubview:topDivider];
    
    UIView* downDivider=[[UIView alloc] init];
    downDivider.frame=CGRectMake(0, 39, SCREEN_WIDTH, 1);
    downDivider.backgroundColor=tableView.separatorColor;
    [view addSubview:downDivider];
    
    UIButton* detailBtn=[[UIButton alloc] init];
    detailBtn.tag=section;
    detailBtn.frame=CGRectMake(SCREEN_WIDTH*2/3+8, 8, SCREEN_WIDTH/3-16, 25);
    [detailBtn setImage:[UIImage imageNamed:@"pingjia_orderdetail"] forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(getOrderDetail:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:detailBtn];
    
    view.backgroundColor=[UIColor whiteColor];
    return view;
    
}
-(NSString*)phoneNumToSecret:(NSString*)phoneNum{
NSString*       phone=[phoneNum stringByReplacingCharactersInRange:NSMakeRange(3, 6) withString:@"****"];
    return phone;
}
@end
