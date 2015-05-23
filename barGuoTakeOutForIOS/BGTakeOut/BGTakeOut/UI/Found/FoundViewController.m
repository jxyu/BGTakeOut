//
//  FoundViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/5.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "FoundViewController.h"
#import "FoundTableViewCell.h"
#import "DataProvider.h"
#import "AppDelegate.h"
#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define corner_radius 14
@interface FoundViewController ()
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@end

@implementation FoundViewController
{
    UIView * Weather;
    NSArray * LinkArray1;
    NSArray * LinkArray2;
    NSArray * LinkArray3;
    NSArray * LinkArray4;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    LinkArray1=[NSArray arrayWithObjects:@"http://www.baidu.com",@"http://www.sina.com.cn/",@"http://www.sohu.com/"@"http://www.qq.com/",@"http://www.ifeng.com/",nil];
    LinkArray2=[NSArray arrayWithObjects:@"http://www.taobao.com",@"http://www.jd.com/",@"http://www.tmall.com/"@"http://www.yhd.com/",@"http://www.vip.com/",nil];
    LinkArray3=[NSArray arrayWithObjects:@"http://www.ganji.com",@"http://www.youyuan.com/",@"http://tv.sohu.com/"@"http://ios.d.cn/",@"http://www.qidian.com/Default.aspx",nil];
    LinkArray4=[NSArray arrayWithObjects:@"http://www.qunar.com/",@"http://www.12306.cn/mormhweb/",@"http://www.ip138.com/weizhang.htm"@"http://www.kuaidi100.com/",@"http://baidu.lecai.com/",nil];
    
    
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    DataProvider * dataprovider =[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetWeatherCallBack:"];
    [dataprovider GetWeather:@"linyi"];
    
    
    //    Weather =[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+25, KWidth, 60)];
    //    Weather.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];;
    //    [self.view addSubview:Weather];
    
    UITableView *foundTable=[[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, SCREEN_HEIGHT-49)];
    foundTable.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    foundTable.delegate=self;
    foundTable.dataSource=self;
    [self.view addSubview:foundTable];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"foundCellIdentifier";
    FoundTableViewCell *cell = (FoundTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"FoundTableViewCell" owner:self options:nil] lastObject];
        switch (indexPath.section) {
            case 0:
                cell.GroupTitle.text=@"资讯";
                cell.img_1.image=[UIImage imageNamed:@"baidu_icon"];
                cell.img_1.layer.masksToBounds =YES;
                
                cell.img_1.layer.cornerRadius =corner_radius;
                
                
                cell.lbl_1.text=@"百度";
                cell.btn_1.tag=[[NSString stringWithFormat:@"1%ld",(long)indexPath.section] integerValue];
                [cell.btn_1 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_2.image=[UIImage imageNamed:@"Image-5"];
                cell.img_2.layer.masksToBounds =YES;
                cell.img_2.layer.cornerRadius =corner_radius;

                cell.lbl_2.text=@"新浪";
                cell.btn_2.tag=[[NSString stringWithFormat:@"2%ld",(long)indexPath.section] integerValue];
                [cell.btn_2 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.image=[UIImage imageNamed:@"Image-6"];
                cell.lbl_3.text=@"搜狐";
                cell.btn_3.tag=[[NSString stringWithFormat:@"3%ld",(long)indexPath.section] integerValue];
                [cell.btn_3 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_4.image=[UIImage imageNamed:@"Image-7"];
                cell.lbl_4.text=@"腾讯";
                cell.btn_4.tag=[[NSString stringWithFormat:@"4%ld",(long)indexPath.section] integerValue];
                [cell.btn_4 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_5.image=[UIImage imageNamed:@"Image-8"];
                cell.lbl_5.text=@"凤凰";
                cell.btn_5.tag=[[NSString stringWithFormat:@"5%ld",(long)indexPath.section] integerValue];
                [cell.btn_5 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.layer.masksToBounds =YES;
                cell.img_3.layer.cornerRadius =corner_radius;

                cell.img_4.layer.masksToBounds =YES;
                cell.img_4.layer.cornerRadius =corner_radius;
                cell.img_5.layer.masksToBounds =YES;
                cell.img_5.layer.cornerRadius =corner_radius;

                break;
            case 1:
                cell.GroupTitle.text=@"购物";
                cell.img_1.image=[UIImage imageNamed:@"taobao.png"];
                cell.img_1.layer.masksToBounds =YES;
                cell.img_1.layer.cornerRadius =corner_radius;
                cell.lbl_1.text=@"淘宝";
                cell.img_2.image=[UIImage imageNamed:@"jingdong.png"];
                cell.img_2.layer.masksToBounds =YES;
                cell.img_2.layer.cornerRadius =corner_radius;

                cell.lbl_2.text=@"京东";
                cell.img_3.image=[UIImage imageNamed:@"tianmao.png"];
                cell.lbl_3.text=@"天猫";
                cell.img_4.image=[UIImage imageNamed:@"yihaodian.png"];
                cell.lbl_4.text=@"1号店";
                cell.img_5.image=[UIImage imageNamed:@"vip.png"];
                cell.lbl_5.text=@"唯品会";
                
                cell.btn_1.tag=[[NSString stringWithFormat:@"1%ld",(long)indexPath.section] integerValue];
                [cell.btn_1 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_2.tag=[[NSString stringWithFormat:@"2%ld",(long)indexPath.section] integerValue];
                [cell.btn_2 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_3.tag=[[NSString stringWithFormat:@"3%ld",(long)indexPath.section] integerValue];
                [cell.btn_3 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_4.tag=[[NSString stringWithFormat:@"4%ld",(long)indexPath.section] integerValue];
                [cell.btn_4 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_5.tag=[[NSString stringWithFormat:@"5%ld",(long)indexPath.section] integerValue];
                [cell.btn_5 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.layer.masksToBounds =YES;
                cell.img_3.layer.cornerRadius =corner_radius;
                
                cell.img_4.layer.masksToBounds =YES;
                cell.img_4.layer.cornerRadius =corner_radius;
                cell.img_5.layer.masksToBounds =YES;
                cell.img_5.layer.cornerRadius =corner_radius;
                break;
            case 2:
                cell.GroupTitle.text=@"生活";
                cell.img_1.image=[UIImage imageNamed:@"ganji.png"];
                cell.img_1.layer.masksToBounds =YES;
                cell.img_1.layer.cornerRadius =corner_radius;

                cell.lbl_1.text=@"赶集";
                cell.img_2.image=[UIImage imageNamed:@"youyuan.png"];
                cell.img_2.layer.masksToBounds =YES;
                cell.img_2.layer.cornerRadius =corner_radius;
                cell.lbl_2.text=@"有缘";
                cell.img_3.image=[UIImage imageNamed:@"souhushipin.png"];
                cell.lbl_3.text=@"搜狐";
                cell.img_4.image=[UIImage imageNamed:@"game.png"];
                cell.lbl_4.text=@"游戏";
                cell.img_5.image=[UIImage imageNamed:@"EBook.png"];
                cell.lbl_5.text=@"电子书";
                
                cell.btn_1.tag=[[NSString stringWithFormat:@"1%ld",(long)indexPath.section] integerValue];
                [cell.btn_1 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_2.tag=[[NSString stringWithFormat:@"2%ld",(long)indexPath.section] integerValue];
                [cell.btn_2 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_3.tag=[[NSString stringWithFormat:@"3%ld",(long)indexPath.section] integerValue];
                [cell.btn_3 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_4.tag=[[NSString stringWithFormat:@"4%ld",(long)indexPath.section] integerValue];
                [cell.btn_4 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_5.tag=[[NSString stringWithFormat:@"5%ld",(long)indexPath.section] integerValue];
                [cell.btn_5 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.layer.masksToBounds =YES;
                cell.img_3.layer.cornerRadius =corner_radius;
                
                cell.img_4.layer.masksToBounds =YES;
                cell.img_4.layer.cornerRadius =corner_radius;
                cell.img_5.layer.masksToBounds =YES;
                cell.img_5.layer.cornerRadius =corner_radius;
                break;
            case 3:
                cell.GroupTitle.text=@"查询";
                cell.img_1.image=[UIImage imageNamed:@"baidu_icon"];
                cell.img_1.layer.masksToBounds =YES;
                cell.img_1.layer.cornerRadius =corner_radius;

                cell.lbl_1.text=@"去哪";
                cell.img_2.image=[UIImage imageNamed:@"huochepiao.png"];
                cell.img_2.layer.masksToBounds =YES;
                cell.img_2.layer.cornerRadius =corner_radius;
                cell.lbl_2.text=@"火车票";
                cell.img_3.image=[UIImage imageNamed:@"qicheweizhang.png"];
                cell.lbl_3.text=@"汽车违章";
                cell.img_4.image=[UIImage imageNamed:@"kuaidi.png"];
                cell.lbl_4.text=@"快递";
                cell.img_5.image=[UIImage imageNamed:@"caipiao.png"];
                cell.lbl_5.text=@"彩票";
                
                cell.btn_1.tag=[[NSString stringWithFormat:@"1%ld",(long)indexPath.section] integerValue];
                [cell.btn_1 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_2.tag=[[NSString stringWithFormat:@"2%ld",(long)indexPath.section] integerValue];
                [cell.btn_2 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_3.tag=[[NSString stringWithFormat:@"3%ld",(long)indexPath.section] integerValue];
                [cell.btn_3 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_4.tag=[[NSString stringWithFormat:@"4%ld",(long)indexPath.section] integerValue];
                [cell.btn_4 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.btn_5.tag=[[NSString stringWithFormat:@"5%ld",(long)indexPath.section] integerValue];
                [cell.btn_5 addTarget:self action:@selector(BtnInCellClick:) forControlEvents:UIControlEventTouchUpInside];
                cell.img_3.layer.masksToBounds =YES;
                cell.img_3.layer.cornerRadius =corner_radius;
                
                cell.img_4.layer.masksToBounds =YES;
                cell.img_4.layer.cornerRadius =corner_radius;
                cell.img_5.layer.masksToBounds =YES;
                cell.img_5.layer.cornerRadius =corner_radius;
                break;
            default:
                break;
        }
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
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
    return 102;
}

-(void)BtnInCellClick:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    int temp=sender.tag%10;
    switch (temp) {
        case 0:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LinkArray1[sender.tag/10-1]]];
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LinkArray2[sender.tag/10-1]]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LinkArray3[sender.tag/10-1]]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LinkArray4[sender.tag/10-1]]];
            break;
        default:
            break;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]animated:YES];
}

-(void)GetWeatherCallBack:(id)dict
{
    NSLog(@"%@",dict);
    NSLog(@"%@",dict[@"retdata"][@"city"]);
    NSLog(@"%@",dict[@"retdata"][@"weather"]);
    UIView * v_temp=[[UIView alloc] initWithFrame:CGRectMake(20, 3, 100, Weather.frame.size.height-6)];
    v_temp.backgroundColor=[UIColor whiteColor];
    UILabel * Temp=[[UILabel alloc] initWithFrame:CGRectMake(30, 00, 50, v_temp.frame.size.height)];
    Temp.text=dict[@"retData"][@"temp"];
    [v_temp addSubview:Temp];
    [Weather addSubview:v_temp];
    
    UIView * v_city=[[UIView alloc] initWithFrame:CGRectMake(v_temp.frame.origin.x+v_temp.frame.size.width+1, 3, 180, Weather.frame.size.height-6)];
    v_city.backgroundColor=[UIColor whiteColor];
    UILabel *city=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, v_city.frame.size.height/2)];
    city.text=dict[@"retData"][@"city"];
    [v_city addSubview:city];
    UILabel * weather=[[UILabel alloc] initWithFrame:CGRectMake(0, v_city.frame.size.height/2, 40, v_city.frame.size.height/2)];
    weather.text=dict[@"retData"][@"weather"];
    [v_city addSubview:weather];
    [Weather addSubview:v_city];
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}
@end
