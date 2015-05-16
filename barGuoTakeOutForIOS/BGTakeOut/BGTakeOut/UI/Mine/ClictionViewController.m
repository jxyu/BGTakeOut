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

#define KURL @"http://121.42.139.60/baguo/"

@interface ClictionViewController ()

@end

@implementation ClictionViewController
{
    NSArray *Canting;
    NSArray *activearray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //添加导航栏
    [self addLeftButton:@"ic_actionbar_back.png"];
    [self setBarTitle:@"我的收藏"];
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetClictionBackCall:"];
    NSDictionary * dictionary=@{@"userid":_userid,@"page":@"1",@"num":@"8"};
    [dataprovider GetAllCollection:dictionary];
}
-(void)GetClictionBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"获取我的收藏%@",dict);
    if ([dict[@"status"] intValue]==1&&![dict[@"data"] isEqual:@""]) {
        Canting=[[NSArray alloc] initWithArray:dict[@"data"]];
        UITableView * TableView_orderList=[[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20,SCREEN_WIDTH , SCREEN_HEIGHT-NavigationBar_HEIGHT-20)];
        TableView_orderList.delegate=self;
        TableView_orderList.dataSource=self;
        [self.view addSubview:TableView_orderList];
    }
    else
    {
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
    if (cell == nil) {
        activearray=[[NSArray alloc] initWithArray:Canting[indexPath.row][@"activities"]];
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"TableViewCell" owner:self options:nil] lastObject];
        [cell.Canting_icon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,Canting[indexPath.row][@"logo"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        cell.CantingName.text=Canting[indexPath.row][@"name"];
        cell.Adress.text=Canting[indexPath.row][@"addressname"];
        cell.starRatingView =[[TQStarRatingView alloc] initWithFrame:CGRectMake(0,0 , cell.PingjiaView.frame.size.width, cell.PingjiaView.frame.size.height) numberOfStar:[Canting[indexPath.row][@"totalcredit"] intValue]];
        [cell.PingjiaView addSubview:cell.starRatingView];
        UIButton * zhezhao=[[UIButton alloc] initWithFrame:CGRectMake(0,0 , cell.PingjiaView.frame.size.width, cell.PingjiaView.frame.size.height)];
        [cell.PingjiaView addSubview:zhezhao];
        for (int i=0; i<activearray.count; i++) {
            UILabel * lbl_active=[[UILabel alloc] initWithFrame:CGRectMake(30, i*20+5, 200, 18)];
            lbl_active.text=activearray[i][@"name"];
            cell.CantingActive.frame=CGRectMake(cell.CantingActive.frame.origin.x, cell.CantingActive.frame.origin.y, cell.CantingActive.frame.size.width, cell.CantingActive.frame.size.height+20*(i-1));
            [cell.CantingActive addSubview:lbl_active];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

@end
