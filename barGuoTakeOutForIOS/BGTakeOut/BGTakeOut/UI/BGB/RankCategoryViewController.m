//
//  RankCategoryViewController.m
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/21.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "RankCategoryViewController.h"
#import "DataProvider.h"
#import "WantRecommendViewController.h"
@interface RankCategoryViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSMutableArray* tableData;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation RankCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)initView{
    _tableView.delegate=self;
    _tableView.dataSource=self;
    UIView*view =[ [UIView alloc]init];
    view.backgroundColor= [UIColor clearColor];
    [_tableView setTableFooterView:view];
    _topView.backgroundColor=[UIColor orangeColor];
    [self addLeftButton:@"ic_actionbar_back.png"];
    
}
-(void)loadData{
    NSString* upid=@"0";
    switch ([_rank integerValue]) {
        case 0:
            upid=@"0";
            _lblTitle.text=@"";
            break;
        case 1:
            upid=_oneid;
            _lblTitle.text=_onetitle;
            break;
        case 2:
            _lblTitle.text=_twotitle;
            upid=_twoid;
            break;
        default:
            break;
    }
    DataProvider* dataprovide=[[DataProvider alloc] init];
    
    [dataprovide setDelegateObject:self setBackFunctionName:@"getRankCategorySuccess:"];
    [dataprovide getBaguoRankCateWithType:[_rank stringValue] upid:upid];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getRankCategorySuccess:(NSDictionary*)dict{
    if ([[dict objectForKey:@"status"] isEqualToString:@"1"]) {
        tableData=[[dict objectForKey:@"data"] mutableCopy];
        [_tableView reloadData];
    }
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    RankCategoryViewController* pushVC;
    switch ([_rank integerValue]) {
        case 0:
            pushVC=[[RankCategoryViewController alloc] init];
            pushVC.rank=[NSNumber numberWithInteger:[_rank integerValue]+1 ];
            
            pushVC.oneid=[[tableData objectAtIndex:indexPath.row] objectForKey:@"oneid"];
            pushVC.onetitle=[[tableData objectAtIndex:indexPath.row] objectForKey:@"name"];
            [self.navigationController pushViewController:pushVC animated:YES];
            break;
        case 1:
            pushVC=[[RankCategoryViewController alloc] init];
            pushVC.rank=[NSNumber numberWithInteger:[_rank integerValue]+1 ];
            pushVC.oneid=_oneid;
            pushVC.onetitle=_onetitle;
            pushVC.twoid=[[tableData objectAtIndex:indexPath.row] objectForKey:@"twoid"];
                        pushVC.twotitle=[[tableData objectAtIndex:indexPath.row] objectForKey:@"name"];
            [self.navigationController pushViewController:pushVC animated:YES];
            break;
        case 2:
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[WantRecommendViewController class]]) {
                    WantRecommendViewController*want=(WantRecommendViewController*)temp;
                    want.oneid=_oneid;
                    want.onetitle=_onetitle;
                    want.twoid=_twoid;
                    want.twotitle=_twotitle;
                    want.threeid=[[tableData objectAtIndex:indexPath.row] objectForKey:@"threeid"];
                    want.threetitle=[[tableData objectAtIndex:indexPath.row] objectForKey:@"name"];
                    [self.navigationController popToViewController:want animated:YES];
                }
            }
            
            break;
        default:
            break;
    }
    
    [_tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}
#pragma mark - tableview datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *TableIdentifier = @"SectionsTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableIdentifier ];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier: TableIdentifier ];
        
    }
    cell.textLabel.text=[[tableData objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  tableData.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

@end
