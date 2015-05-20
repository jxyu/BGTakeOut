//
//  JokeViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/24.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "JokeViewController.h"
#import "DataProvider.h"
#import "JokeTableViewCell.h"
#import "CommenDef.h"
#import "AppDelegate.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

@interface JokeViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property(nonatomic,strong)UIScrollView * scrollviewForJoke;

@end

@implementation JokeViewController
{
    NSArray * JokeArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"每日一乐呵"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    

    
//    _scrollviewForJoke=[[UIScrollView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height, KWidth, KHeight-lastView.frame.size.height)];
//    _scrollviewForJoke.scrollEnabled=YES;
//    _scrollviewForJoke.contentSize=CGSizeMake(0, KHeight-lastView.frame.size.height);
    
    DataProvider * dataProvider =[[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"BuildJokeView:"];
    [dataProvider GetJoke];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

-(void)BuildJokeView:(id)dict
{
    NSLog(@"%@",dict);
    JokeArray=dict[@"data"];
    UITableView * mytableView=[[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-NavigationBar_HEIGHT-20)];
    mytableView.delegate=self;
    mytableView.dataSource=self;
    [self.view addSubview:mytableView];
    [SVProgressHUD dismiss];
}

-(void)clickLeftButton
{
    [self.view removeFromSuperview];
}

// tableView分区数量，默认为1，可为其设置为多个列
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
// tableView每个列的行数，可以为各个列设置不同的行数，根据section的值判断即可
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return JokeArray.count;
}

// 实现每一行Cell的内容，tableView重用机制
-(JokeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"JokeCellIdentifier";
    JokeTableViewCell *cell = (JokeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"JokeTableViewCell" owner:self options:nil] lastObject];
        cell.jokecontent.text=[NSString stringWithFormat:@"%@",JokeArray[indexPath.row][@"content"]];
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
    CGFloat height=220.0;
    return height;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
