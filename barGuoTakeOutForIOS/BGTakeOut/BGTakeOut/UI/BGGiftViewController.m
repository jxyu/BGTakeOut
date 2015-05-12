//
//  BGGiftViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/25.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BGGiftViewController.h"
#import "DataProvider.h"
#import "BGGiftTableViewCell.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

@interface BGGiftViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;

@end

@implementation BGGiftViewController
{
    NSArray * GiftListData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Do any additional setup after loading the view from its nib.
    //添加导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, KWidth, 64)];
    navigationBar.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    navigationBar.translucent=YES;
    _mynavigationItem = [[UINavigationItem alloc] initWithTitle:@"`自动定位"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Image-2"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc] initWithTitle:@"兑换纪录"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(clickRightButton)];
    [navigationBar pushNavigationItem:_mynavigationItem animated:NO];
    [_mynavigationItem setLeftBarButtonItem:leftButton];
    [_mynavigationItem setRightBarButtonItem:rightButton];
    [self.view addSubview:navigationBar];
    
    
    
    UIView * lastView=[self.view.subviews lastObject];
    CGFloat y=lastView.frame.size.height;
    UIView * myBGMoney =[[UIView alloc] initWithFrame:CGRectMake(0, y, KWidth, 35)];
    UILabel * moneyLable=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 78, 25)];
    moneyLable.text=[NSString stringWithFormat:@"我的巴国币："];
    moneyLable.font = [UIFont systemFontOfSize:13];
    [myBGMoney addSubview:moneyLable];
    lastView=[myBGMoney.subviews lastObject];
    CGFloat x=lastView.frame.origin.x+lastView.frame.size.width;
    UILabel * moneyNum=[[UILabel alloc] initWithFrame:CGRectMake(x, 5, 60, 25)];
    moneyNum.text=[NSString stringWithFormat:@"1000000"];
    moneyNum.textColor=[UIColor redColor];
    moneyNum.font = [UIFont systemFontOfSize:13];
    [myBGMoney addSubview:moneyNum];
    lastView=[myBGMoney.subviews lastObject];
    x=lastView.frame.origin.x+lastView.frame.size.width;
    UILabel * mylable =[[UILabel alloc] initWithFrame:CGRectMake(x, 5, 40, 25)];
    mylable.text=[NSString stringWithFormat:@"个"];
    mylable.font = [UIFont systemFontOfSize:13];
    [myBGMoney addSubview:mylable];
    [self.view addSubview:myBGMoney];
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetGiftList:"];
    [dataprovider GetGiftList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)clickLeftButton
{
    [self.view removeFromSuperview];
}

-(void)clickRightButton
{
    NSLog(@"click right button");
}
-(void)GetGiftList:(id)dict
{
    NSLog(@"%@",dict);
    if (dict) {
        GiftListData=dict[@"data"];
        UIView * lastView=[self.view.subviews lastObject];
        CGFloat y=lastView.frame.origin.y+lastView.frame.size.height+1;
        UITableView * GiftTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, y, KWidth, KHeight-y)];
        GiftTableView.delegate=self;
        GiftTableView.dataSource=self;
        [self.view addSubview:GiftTableView];
    }
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return GiftListData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"GiftCellIdentifier";
    BGGiftTableViewCell *cell = (BGGiftTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"BGGiftTableViewCell" owner:self options:nil] lastObject];
        cell.GiftImage.image=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:GiftListData[indexPath.row][@"logo"]]]];
        cell.GiftName.text=GiftListData[indexPath.row][@"NAME"];
        cell.Giftmoney.text=GiftListData[indexPath.row][@"price"];
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
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0;
}
@end
