//
//  ClictionViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "ClictionViewController.h"
#import "CommenDef.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "TableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#define KURL @"http://112.74.76.91/baguo/"

@interface ClictionViewController ()

@end

@implementation ClictionViewController
{
    UITableView * TableView_orderList;
    NSMutableArray *Canting;
    NSArray *activearray;
    int page;
    int num;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加导航栏
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self setBarTitle:@"我的收藏"];
    page=1;
    num=8;
    Canting=[[NSMutableArray alloc] init];
    UIView*view =[ [UIView alloc]init];
    view.backgroundColor= [UIColor clearColor];
    [TableView_orderList setTableFooterView:view];
    TableView_orderList=[[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20,SCREEN_WIDTH , SCREEN_HEIGHT-NavigationBar_HEIGHT-20)];
    TableView_orderList.delegate=self;
    TableView_orderList.dataSource=self;
    [self.view addSubview:TableView_orderList];
    __weak typeof(self) weakself=self;
    [TableView_orderList addLegendFooterWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    [self loadNewData];
    
    
}
-(void)GetClictionBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"获取我的收藏%@",dict);
    if ([dict[@"status"] intValue]==1&&![dict[@"data"] isEqual:@""]) {
        NSArray * itemarray=dict[@"data"];
        for (int i=0; i<itemarray.count; i++) {
            [Canting addObject:itemarray[i]];
        }
        [TableView_orderList reloadData];
        [TableView_orderList.footer endRefreshing];
    }
    else
    {
        [TableView_orderList.footer endRefreshing];
        [SVProgressHUD showErrorWithStatus:@"您还未收藏任何信息" maskType:SVProgressHUDMaskTypeBlack];
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  Canting.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomCellIdentifier";
    TableViewCell *cell = (TableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.layer.masksToBounds=YES;
    cell.bounds=CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
    if (cell == nil) {
        activearray=[[NSArray alloc] initWithArray:Canting[indexPath.row][@"activities"]];
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
        [cell initLayout];
        [cell.Canting_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,Canting[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.Canting_icon.layer.masksToBounds=YES;
        cell.Canting_icon.layer.cornerRadius=4;
        cell.layer.borderWidth=1;
        cell.layer.borderColor=(__bridge CGColorRef)([UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0]);
        cell.CantingName.text=Canting[indexPath.row][@"name"];
        cell.Adress.text=Canting[indexPath.row][@"addressname"];
        cell.starRatingView.rating=[Canting[indexPath.row][@"totalcredit"] intValue];
        //UIButton * zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0,0 , cell.PingjiaView.frame.size.width, cell.PingjiaView.frame.size.height)];
        //[cell.PingjiaView addSubview:zhezhao];
        
//        for (int i=0; i<activearray.count; i++) {
//            UILabel * lbl_active=[[UILabel alloc] initWithFrame:CGRectMake(30, i*20+5, 200, 18)];
//            lbl_active.text=activearray[i][@"name"];
//            cell.CantingActive.frame=CGRectMake(cell.CantingActive.frame.origin.x, cell.CantingActive.frame.origin.y, cell.CantingActive.frame.size.width, cell.CantingActive.frame.size.height+20*(i-1));
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
    return 110;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",indexPath);
        NSString * restid=Canting[indexPath.row][@"resid"];
        _myCantingView=[[CantingInfoViewController alloc] initWithNibName:@"CantingInfoViewController" bundle:[NSBundle mainBundle]];
        _myCantingView.resid=restid;
        _myCantingView.peisongData=Canting[indexPath.row][@"deliveryprice"];
        _myCantingView.name=Canting[indexPath.row][@"name"];
        [self.navigationController pushViewController:_myCantingView animated:YES];
     [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)loadNewData
{
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetClictionBackCall:"];
    NSDictionary * dictionary=@{@"userid":_userid,@"page":[NSString stringWithFormat:@"%d",page],@"num":@"8"};
    [dataprovider GetAllCollection:dictionary];
    page++;
}

@end
