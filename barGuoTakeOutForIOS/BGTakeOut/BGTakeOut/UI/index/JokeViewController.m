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
#import "MJRefresh.h"

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height

@interface JokeViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property(nonatomic,strong)UIScrollView * scrollviewForJoke;

@end

@implementation JokeViewController
{
    NSInteger table_page;
    NSMutableArray * JokeArray;
    UITableView * mytableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarTitle:@"每日一乐呵"];
    [self addLeftButton:@"ic_actionbar_back.png"];
    JokeArray=[[NSMutableArray alloc] init];
    table_page=1;
    mytableView=[[UITableView alloc] initWithFrame:CGRectMake(5, NavigationBar_HEIGHT+20+5, SCREEN_WIDTH-10, SCREEN_HEIGHT-NavigationBar_HEIGHT-25)];
    mytableView.delegate=self;
    mytableView.dataSource=self;
    mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mytableView.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:mytableView];
    __weak typeof(self) weakself=self;
    [mytableView addLegendFooterWithRefreshingBlock:^{
        [weakself loadNewData];
    }];
    [self loadNewData];
    
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
    if ([dict[@"status"] intValue]==1) {
        NSArray * itemarray=dict[@"data"];
        for (int i=0; i<itemarray.count; i++) {
            [JokeArray addObject:itemarray[i]];
        }
        [mytableView reloadData];
    }
    [mytableView footerEndRefreshing];
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
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell=[[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0,tableView.frame.size.width , [self heightForString:JokeArray[indexPath.row][@"content"] andWidth:SCREEN_WIDTH-30])];
    cell.layer.masksToBounds=YES;
    cell.bounds=CGRectMake(0, 0, tableView.frame.size.width, cell.frame.size.height);
    UIView * jianju=[[UIView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 5)];
    jianju.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [cell addSubview:jianju];
    UILabel * lbl_title=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
    lbl_title.text=JokeArray[indexPath.row][@"title"]!=[NSNull null]?JokeArray[indexPath.row][@"title"]:@"";
    [cell addSubview:lbl_title];
    UILabel * lbl_updatatime=[[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 10, 100, 20)];
    lbl_updatatime.text=JokeArray[indexPath.row][@"updatetime"]!=[NSNull null]?[self GetDateWithnsstring:JokeArray[indexPath.row][@"updatetime"]]:@"";
    lbl_updatatime.textColor=[UIColor grayColor];
    lbl_updatatime.font=[UIFont systemFontOfSize:14];
    [cell addSubview:lbl_updatatime];
    UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, lbl_updatatime.frame.origin.y+lbl_updatatime.frame.size.height+5, cell.frame.size.width-20, 1)];
    fenge.backgroundColor=[UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1.0];
    [cell addSubview:fenge];
    UITextView * txt_content=[[UITextView alloc] initWithFrame:CGRectMake(0, fenge.frame.origin.y+2, cell.frame.size.width, [self heightForString:JokeArray[indexPath.row][@"content"] andWidth:SCREEN_WIDTH-30]+40)];
    txt_content.font=[UIFont systemFontOfSize:15];
    txt_content.editable=NO;
    txt_content.text=JokeArray[indexPath.row][@"content"]!=[NSNull null]?JokeArray[indexPath.row][@"content"]:@"";
    [cell addSubview:txt_content];
    cell.frame=CGRectMake(0, 0, tableView.frame.size.width, txt_content.frame.origin.y+txt_content.frame.size.height+1);
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=[self heightForString:JokeArray[indexPath.row][@"content"] andWidth:SCREEN_WIDTH-30];
    return height+78;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

-(void)loadNewData
{
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    DataProvider * dataProvider =[[DataProvider alloc] init];
    [dataProvider setDelegateObject:self setBackFunctionName:@"BuildJokeView:"];
    [dataProvider GetJoke:[NSString stringWithFormat:@"%ld",(long)table_page] andnum:@"6"];
    table_page++;
}

- (float) heightForString:(NSString *)value andWidth:(float)width{
    //获取当前文本的属性
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:value];
    NSRange range = NSMakeRange(0, attrStr.length);
    // 获取该段attributedString的属性字典
    NSDictionary *dic = [attrStr attributesAtIndex:0 effectiveRange:&range];
    // 计算文本的大小
    CGSize sizeToFit = [value boundingRectWithSize:CGSizeMake(width - 16.0, MAXFLOAT) // 用于计算文本绘制时占据的矩形块
                                           options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading // 文本绘制时的附加选项
                                        attributes:dic        // 文字的属性
                                           context:nil].size; // context上下文。包括一些信息，例如如何调整字间距以及缩放。该对象包含的信息将用于文本绘制。该参数可为nil
    return sizeToFit.height + 16.0;
}

-(NSString *)GetDateWithnsstring:(NSString *)dateprm
{
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyyMMddHHMMss"];
//    NSDate *date = [formatter dateFromString:dateprm];
//    NSLog(@"date1:%@",date);
//    return date;
    double unixTimeStamp = [dateprm doubleValue];
    NSTimeInterval _interval=unixTimeStamp;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setLocale:[NSLocale currentLocale]];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *_date=[_formatter stringFromDate:date];
    return _date;
}

@end
