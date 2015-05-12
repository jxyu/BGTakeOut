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
    // Do any additional setup after loading the view from its nib.
//    self.view.backgroundColor=[UIColor colorWithRed:245/255 green:245/255 blue:245/255 alpha:1.0];
    //添加导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 64)];
    navigationBar.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    navigationBar.translucent=YES;
    _mynavigationItem = [[UINavigationItem alloc] initWithTitle:@"每日一乐呵"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Image-2"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(clickLeftButton)];
    [navigationBar pushNavigationItem:_mynavigationItem animated:NO];
    [_mynavigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    
    

    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)BuildJokeView:(id)dict
{
    NSLog(@"%@",dict);
    JokeArray=dict[@"data"];
    UIView * lastView=[self.view.subviews lastObject];
    UITableView * mytableView=[[UITableView alloc] initWithFrame:CGRectMake(10, lastView.frame.size.height, KWidth-20, KHeight-lastView.frame.size.height)];
    mytableView.delegate=self;
    mytableView.dataSource=self;
    [self.view addSubview:mytableView];
    
}
//-(UIView *)GetJokeView:(NSString *)joke andJokeName:(NSString *)jokeName
//{
//    UIView * result =[[UIView alloc] init];
//    UIView * top =[[UIView alloc] initWithFrame:CGRectMake(0, 10, KWidth-20, 45)];
//    [result addSubview:top];
//    UILabel * name=[[UILabel alloc] initWithFrame:CGRectMake(10, 12, 90, 45-24)];
//    name.text=jokeName;
//    [top addSubview:name];
//    return result;
//}
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

@end
