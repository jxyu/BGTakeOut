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
@interface RankCategoryViewController (){
    
    UIScrollView * menuScrollView;
    UIScrollView * firstScrollView;
    NSMutableArray * categary1;
    NSMutableArray * categary2;
    NSMutableArray * categary3;
    NSMutableArray * colorArray;
}

@end

@implementation RankCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self loadData];
    // Do any additional setup after loading the view from its nib.
}
-(void)initView{
    categary1=[[NSMutableArray alloc] init];
    categary2=[[NSMutableArray alloc] init];
    categary3=[[NSMutableArray alloc] init];
    colorArray=[[NSMutableArray alloc] init];
    _lblTitle.text=@"选择分类";
    [self addLeftButton:@"ic_actionbar_back.png"];
    
    menuScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, SCREEN_WIDTH/3, SCREEN_HEIGHT-64)];
    menuScrollView.scrollEnabled=YES;
    menuScrollView.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    
    [self.view addSubview:menuScrollView];
    
    
    firstScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/3, menuScrollView.frame.origin.y, SCREEN_WIDTH/3*2, menuScrollView.frame.size.height)];
    firstScrollView.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
    firstScrollView.scrollEnabled=YES;
    
}
-(void)loadData{
    [self buildColorArray];
    NSString* upid=@"0";
    DataProvider* dataprovide=[[DataProvider alloc] init];
    [dataprovide setDelegateObject:self setBackFunctionName:@"getRankCategorySuccess:"];
    [dataprovide getBaguoRankCateWithType:[_rank stringValue] upid:upid];
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getRankCategorySuccess:(NSDictionary*)dict{
    if ([dict[@"status"] intValue]==1) {
        NSArray *itemarray=dict[@"data"];
        if (itemarray[0][@"oneid"]) {
            categary1=dict[@"data"];
        }
    }
    for (int i=0; i<categary1.count; i++) {
        UIButton * item=[[UIButton alloc] initWithFrame:CGRectMake(0, 70*i+1, menuScrollView.frame.size.width, 70)];
        item.backgroundColor=[UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
        item.tag=i;
        UIImageView * img_icom=[[UIImageView alloc] initWithFrame:CGRectMake(36, 5, 28, 28)];
        switch ([categary1[i][@"oneid"] intValue]) {
            case 1:
                img_icom.image=[UIImage imageNamed:@"res_hui"];
                break;
            case 2:
                img_icom.image=[UIImage imageNamed:@"food_hui"];
                break;
            case 3:
                img_icom.image=[UIImage imageNamed:@"music_hui"];
                break;
            case 4:
                img_icom.image=[UIImage imageNamed:@"jiazheng_hui"];
                break;
            case 5:
                img_icom.image=[UIImage imageNamed:@"wedding_hui"];
                break;
            case 6:
                img_icom.image=[UIImage imageNamed:@"peixun_hui"];
                break;
            case 7:
                img_icom.image=[UIImage imageNamed:@"zhuangxiu_hui"];
                break;
            case 8:
                img_icom.image=[UIImage imageNamed:@"truck_hui"];
                break;
                
            default:
                break;
        }
        img_icom.tag=200;
        [item addSubview:img_icom];
        UILabel * lbl_Title=[[UILabel alloc] initWithFrame:CGRectMake(10, img_icom.frame.origin.y+img_icom.frame.size.height+8, 80, 20)];
        lbl_Title.text=categary1[i][@"name"];
        lbl_Title.tag=201;
        lbl_Title.font=[UIFont systemFontOfSize:16];
        lbl_Title.textColor=[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0];
        [lbl_Title setTextAlignment:NSTextAlignmentCenter];
        [item addSubview:lbl_Title];
        UIView * fenge=[[UIView alloc] initWithFrame:CGRectMake(10, 65, 80, 2)];
        fenge.layer.masksToBounds=YES;
        fenge.layer.cornerRadius=1;
        fenge.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
        fenge.tag=202;
        [item addSubview:fenge];
        [item addTarget:self action:@selector(fenleiItemClicktj:) forControlEvents:UIControlEventTouchUpInside];
        [menuScrollView addSubview:item];
    }
    UIView *lastView=[menuScrollView.subviews lastObject];
    menuScrollView.contentSize=CGSizeMake(0, lastView.frame.origin.y+lastView.frame.size.height+1);
}

-(void)fenleiItemClicktj:(UIButton *)sender
{
    _oneid=categary1[sender.tag][@"oneid"];
    _onetitle=categary1[sender.tag][@"name"];
    
    for (UIView * items in menuScrollView.subviews) {
        if ([items isKindOfClass:[UIButton class]]) {
            UIButton *item=(UIButton *)items;
            for (UIView * items1 in item.subviews) {
                if (items1.tag==200) {
                    UIImageView *item1=(UIImageView *)items1;
                    switch (item.tag) {
                        case 1:
                            item1.image=[UIImage imageNamed:@"res_hui"];
                            break;
                        case 2:
                            item1.image=[UIImage imageNamed:@"food_hui"];
                            break;
                        case 3:
                            item1.image=[UIImage imageNamed:@"music_hui"];
                            break;
                        case 4:
                            item1.image=[UIImage imageNamed:@"jiazheng_hui"];
                            break;
                        case 5:
                            item1.image=[UIImage imageNamed:@"wedding_hui"];
                            break;
                        case 6:
                            item1.image=[UIImage imageNamed:@"peixun_hui"];
                            break;
                        case 7:
                            item1.image=[UIImage imageNamed:@"zhuangxiu_hui"];
                            break;
                        case 8:
                            item1.image=[UIImage imageNamed:@"truck_hui"];
                            break;
                            
                        default:
                            break;
                    }
                }
                if (items1.tag==201) {
                    UILabel * lbl_item=(UILabel *)items1;
                    lbl_item.textColor=[UIColor colorWithRed:149/255.0 green:149/255.0 blue:149/255.0 alpha:1.0];
                }
                if (items1.tag==202) {
                    UIView * fenge=items1;
                    fenge.frame=CGRectMake(fenge.frame.origin.x, fenge.frame.origin.y, fenge.frame.size.width, 2);
                    fenge.backgroundColor=[UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1.0];
                }
            }
        }
    }
    
    for (UIView * items1 in sender.subviews) {
        if (items1.tag==200) {
            UIImageView *item1=(UIImageView *)items1;
            switch (sender.tag) {
                case 1:
                    item1.image=[UIImage imageNamed:@"res"];
                    break;
                case 2:
                    item1.image=[UIImage imageNamed:@"food"];
                    break;
                case 3:
                    item1.image=[UIImage imageNamed:@"music"];
                    break;
                case 4:
                    item1.image=[UIImage imageNamed:@"jiazheng"];
                    break;
                case 5:
                    item1.image=[UIImage imageNamed:@"wedding"];
                    break;
                case 6:
                    item1.image=[UIImage imageNamed:@"peixun"];
                    break;
                case 7:
                    item1.image=[UIImage imageNamed:@"zhuangxiu"];
                    break;
                case 8:
                    item1.image=[UIImage imageNamed:@"truck"];
                    break;
                    
                default:
                    break;
            }
        }
        if (items1.tag==201) {
            UILabel * lbl_item=(UILabel *)items1;
            lbl_item.textColor=[UIColor colorWithRed:234/255.0 green:54/255.0 blue:39/255.0 alpha:1.0];
        }
        if (items1.tag==202) {
            UIView * fenge=items1;
            fenge.frame=CGRectMake(fenge.frame.origin.x, fenge.frame.origin.y, fenge.frame.size.width, 5);
            fenge.backgroundColor=[UIColor colorWithRed:234/255.0 green:54/255.0 blue:39/255.0 alpha:1.0];
            fenge.layer.cornerRadius=3;
        }
    }
    
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetSecondTypeBackCall:"];
    [dataprovider GetBGBangTypewithtype:@"1" andupid:categary1[sender.tag][@"oneid"]];
}

-(void)GetSecondTypeBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        categary2=dict[@"data"];
        [self BurildSecondScroll];
    }
}

-(void)BurildSecondScroll
{
    for (UIView * item in firstScrollView.subviews) {
        [item removeFromSuperview];
    }
    UIView * head=[[UIView alloc] initWithFrame:CGRectMake(0, 0, firstScrollView.frame.size.width, 1)];
    [firstScrollView addSubview:head];
    for (int i=0; i<categary2.count; i++) {
        UIView *lasview=[firstScrollView.subviews lastObject];
        UIButton * btn_itemInScroll=[[UIButton alloc] initWithFrame:CGRectMake(0, lasview.frame.origin.y+lasview.frame.size.height+2, firstScrollView.frame.size.width, 40)];
        btn_itemInScroll.titleLabel.font=[UIFont systemFontOfSize:14];
        [btn_itemInScroll.titleLabel setTextAlignment:NSTextAlignmentCenter];
        btn_itemInScroll.backgroundColor=[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1.0];
        [btn_itemInScroll setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn_itemInScroll setTitle:categary2[i][@"name"] forState:UIControlStateNormal];
        [btn_itemInScroll setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn_itemInScroll.tag=i;
        [btn_itemInScroll addTarget:self action:@selector(Getthirdcategray:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView * dian=[[UIView alloc] initWithFrame:CGRectMake(10, 15, 10, 10)];
        dian.backgroundColor=colorArray[arc4random() % colorArray.count];
        dian.layer.masksToBounds=YES;
        dian.layer.cornerRadius=5;
        [btn_itemInScroll addSubview:dian];
        [firstScrollView addSubview:btn_itemInScroll];
        if (categary3.count>0&&[categary3[0][@"upid"]intValue]==[categary2[i][@"twoid"]intValue]) {
            UIView *backview=[[UIView alloc] init];
            backview.backgroundColor=[UIColor whiteColor];
            for (int i=0; i<categary3.count; i++) {
                UIButton * btnitem=[[UIButton alloc] initWithFrame:CGRectMake((i%3)*(firstScrollView.frame.size.width/3), (i/3)*30, firstScrollView.frame.size.width/3, 30)];
                [btnitem setTitle:categary3[i][@"name"] forState:UIControlStateNormal];
                [btnitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                btnitem.titleLabel.font=[UIFont systemFontOfSize:13];
                [btnitem addTarget:self action:@selector(finishChoosefenlei:) forControlEvents:UIControlEventTouchUpInside];
                [backview addSubview:btnitem];
            }
            UIView *lastview1=[backview.subviews lastObject];
            backview.frame=CGRectMake(0, btn_itemInScroll.frame.origin.y+btn_itemInScroll.frame.size.height+1, firstScrollView.frame.size.width, lastview1.frame.origin.y+lastview1.frame.size.height+1);
            [firstScrollView addSubview:backview];
        }
    }
    UIView * lastView=[firstScrollView.subviews lastObject];
    firstScrollView.contentSize=CGSizeMake(0, lastView.frame.origin.y+lastView.frame.size.height);
    [self.view addSubview:firstScrollView];
}

-(void)Getthirdcategray:(UIButton *)sender
{
    NSLog(@"获取第三级列表");
    for (UIView * items in firstScrollView.subviews) {
        if ([items isKindOfClass:[UIButton class]]) {
            UIButton * item=(UIButton *)items;
            item.titleLabel.textColor=[UIColor blackColor];
        }
    }
    sender.titleLabel.textColor=[UIColor redColor];
    _twoid=categary2[sender.tag][@"twoid"];
    _twotitle=categary2[sender.tag][@"name"];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetthirdTypeBackCall:"];
    [dataprovider GetBGBangTypewithtype:@"2" andupid:categary2[sender.tag][@"twoid"] ];
    
}

-(void)GetthirdTypeBackCall:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if ([dict[@"status"] intValue]==1) {
        categary3=dict[@"data"];
        
        [self BurildSecondScroll];
    }
}

-(void)finishChoosefenlei:(UIButton *)sender
{
    _threeid=categary3[sender.tag][@"threeid"];
    _threetitle=categary3[sender.tag][@"name"];
    [menuScrollView removeFromSuperview];
    [firstScrollView removeFromSuperview];
    
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[WantRecommendViewController class]]) {
            WantRecommendViewController*want=(WantRecommendViewController*)temp;
            want.oneid=_oneid;
            want.onetitle=_onetitle;
            want.twoid=_twoid;
            want.twotitle=_twotitle;
            want.threeid=_threeid;
            want.threetitle=_threetitle;
            [self.navigationController popToViewController:want animated:YES];
        }
    }
//    [self MakePramAndGetData:@"1" andNum:8 andSort:sort andOneid:_oneid andTwoid:_twoid andThreeid:_threeid anduserid:dictionary[@"userid"] andlat:_lat andlong:_longprm];
}


-(void)buildColorArray
{
    UIColor * col1=[UIColor colorWithRed:231/255.0 green:0 blue:18/255.0 alpha:1.0];
    [colorArray addObject:col1];
    UIColor * col2=[UIColor colorWithRed:196/255.0 green:144/255.0 blue:192/255.0 alpha:1.0];
    [colorArray addObject:col2];
    UIColor * col3=[UIColor colorWithRed:250/255.0 green:205/255.0 blue:138/255.0 alpha:1.0];
    [colorArray addObject:col3];
    UIColor * col4=[UIColor colorWithRed:128/255.0 green:203/255.0 blue:242/255.0 alpha:1.0];
    [colorArray addObject:col4];
    UIColor * col5=[UIColor colorWithRed:128/255.0 green:194 blue:106/255.0 alpha:1.0];
    [colorArray addObject:col5];
    UIColor * col6=[UIColor colorWithRed:286/255.0 green:11/255.0 blue:182/255.0 alpha:1.0];
    [colorArray addObject:col6];
}

@end
