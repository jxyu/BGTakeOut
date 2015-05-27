//
//  OrderListViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/14.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "OrderListViewController.h"
#import "CommenDef.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#import "OrderListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#define KURL @"http://121.42.139.60/baguo/"

@interface OrderListViewController ()

@end

@implementation OrderListViewController
{
    NSMutableArray * orderListdata;
    UITableView * TableView_orderList;
    int page;
    int num;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加导航栏
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self setBarTitle:@"我的订单"];
    orderListdata=[[NSMutableArray alloc] init];
    page=1;
    num=8;
    
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
-(void)GetOrderListBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    if (1==[dict[@"status"] intValue]) {
        NSLog(@"order列表%@",dict);
        NSArray * array=dict[@"data"];
        for (int i=0; i<array.count; i++) {
            [orderListdata addObject:array[i]];
        }
        [TableView_orderList reloadData];
        [TableView_orderList.footer endRefreshing];
    }else
    {
        [TableView_orderList.footer endRefreshing];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return orderListdata.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"OrderListCellIdentifier";
    OrderListTableViewCell *cell = (OrderListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"OrderListTableViewCell" owner:self options:nil] lastObject];
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        cell.time.text=orderListdata[indexPath.section][@"updatetime"];
        switch ([orderListdata[indexPath.section][@"status"] intValue]) {
            case 0:
                cell.status.text=@"提交订单，等待付款";
                [cell.status setTextColor:[UIColor redColor]];
                break;
            case 1:
                cell.status.text=@"付款完成，等待餐厅接单";
                [cell.status setTextColor:[UIColor redColor]];
                break;
            case 2:
                cell.status.text=@"餐厅接单完成，正在配送";
                [cell.status setTextColor:[UIColor redColor]];
                break;
            case 3:
                cell.status.text=@"买家确认收货,交易成功";
                break;
            case 4:
                cell.status.text=@"卖家已接单，正在配送";
                break;
            case 5:
                cell.status.text=@"未付款，待付款";
                break;
            case 7:
                cell.status.text=@"未付款,订单取消，交易关闭";
                break;
            case 8:
                cell.status.text=@"已付款，订单取消，等待退款";
                break;
            case 9:
                cell.status.text=@"退款成功，交易关闭";
                break;
            default:
                break;
        }
        [cell.logo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,orderListdata[indexPath.row][@"reslogo"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.resname.text=orderListdata[indexPath.section][@"resname"];
        cell.price.text=[NSString stringWithFormat:@"¥%@",orderListdata[indexPath.section][@"orderprice"]];
        
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.orderInfoVC=[[OrderInfoViewController alloc] init];
    _orderInfoVC.orderInfoDetial=orderListdata[indexPath.section];
    [self.navigationController pushViewController:_orderInfoVC animated:YES];
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
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetOrderListBackCall:"];
    NSDictionary * prm=@{@"page":[NSString stringWithFormat:@"%d",page],@"num":[NSString stringWithFormat:@"%d",num],@"userid":_userid};
    [dataprovider GetOrdersList:prm];
    page++;
}

@end
