//
//  CantingInfoViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/4/27.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "CantingInfoViewController.h"
#import "DataProvider.h"
#import "GoodsTableViewCell.h"
#import "ShoppingCarTableViewCell.h"
#import "ShoppingCarModel.h"
#import "JSBadgeView.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "AMRatingControl.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "ShopAlbumViewController.h"
#import "PingjiaViewController.h"
#import "UMSocial.h"
#import "CWStarRateView.h"
#import "LoginViewController.h"
#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define KAreaListHeight 60 //scollview中的button的高度
#define KURL @"http://112.74.76.91/baguo/"

@interface CantingInfoViewController ()

@property(nonatomic,strong) NYSegmentedControl *CantingsegmentedControl;
@property(nonatomic,strong)UIView * CantingPage;
@property(nonatomic,strong)UIView * CantingOtherPage;
@property(nonatomic,strong)UIScrollView * areaScroll;
@property(nonatomic,strong)UITableView * GoodsList;
@property(nonatomic,strong)UIView * ShoppingListView;
@property(nonatomic,strong)UILabel * lableinShoppingList;
@property(nonatomic,strong)JSBadgeView *badgeView;
@property(nonatomic,strong)UIView * shoppingListPage;
@property(nonatomic,strong)UILabel * locationForbadge;
@end

@implementation CantingInfoViewController
{
    NSArray * GoodsListArray;
    NSMutableArray * ShoppingCar;
    BOOL isClick;
    BOOL isgouwucheShow;
    UIButton *  choseDone;
    UIView * CantingsegmentView;//放segmentcontrol的view
    NSDictionary * dictionary;
    NSMutableArray * lbl_array;
    UIView * BackView_gouwuche_icon;
    UITableView * tableView_gouwuche;
    NSDictionary * cantingxiangqingData;
    BOOL isShouCang;
    
    UIView * Backview;
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    @try {
        ShoppingCar=[[NSMutableArray alloc] init];
        cantingxiangqingData=[[NSDictionary alloc] init];
        isClick=NO;
        isgouwucheShow=NO;
        [self setBarTitle:_name];
        [self addLeftButton:@"ic_actionbar_back.png"];
        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
        NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                  NSUserDomainMask, YES) objectAtIndex:0];
        NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
        dictionary =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
        
        //添加Segmented Control
        UIView * lastView=[self.view.subviews lastObject];
        CantingsegmentView=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 50)];
        CantingsegmentView.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
        self.CantingsegmentedControl = [[NYSegmentedControl alloc] initWithItems:@[@"餐厅菜单", @"店铺详情"]];
        [self.CantingsegmentedControl addTarget:self action:@selector(CantingSegMentControlClick) forControlEvents:UIControlEventValueChanged];
        self.CantingsegmentedControl.titleFont = [UIFont fontWithName:@"AvenirNext-Medium" size:14.0f];
        self.CantingsegmentedControl.titleTextColor = [UIColor whiteColor];
        self.CantingsegmentedControl.selectedTitleFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0f];
        self.CantingsegmentedControl.selectedTitleTextColor = [UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
        self.CantingsegmentedControl.borderWidth = 1.0f;
        self.CantingsegmentedControl.borderColor = [UIColor whiteColor];
        self.CantingsegmentedControl.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
        //self.segmentedControl.segmentIndicatorInset = 2.0f;
        self.CantingsegmentedControl.cornerRadius=16.0f;
        self.CantingsegmentedControl.segmentIndicatorGradientTopColor = [UIColor whiteColor];
        self.CantingsegmentedControl.segmentIndicatorGradientBottomColor = [UIColor whiteColor];
        self.CantingsegmentedControl.drawsSegmentIndicatorGradientBackground = YES;
        self.CantingsegmentedControl.segmentIndicatorBorderWidth = 0.0f;
        self.CantingsegmentedControl.selectedSegmentIndex = 0;
        [self.CantingsegmentedControl sizeToFit];
        self.CantingsegmentedControl.frame=CGRectMake(22, 2, SCREEN_WIDTH-44, 36);
        [CantingsegmentView addSubview:_CantingsegmentedControl];
        [self.view addSubview:CantingsegmentView];
        
        lastView=[self.view.subviews lastObject];
        CGFloat ViewHeight=lastView.frame.origin.y+lastView.frame.size.height;
        _CantingPage=[[UIView alloc] initWithFrame:CGRectMake(0,ViewHeight , SCREEN_WIDTH, SCREEN_HEIGHT-ViewHeight-50)];
        [self.view addSubview:_CantingPage];
        
        
        _shoppingListPage=[[UIView alloc] initWithFrame:CGRectMake(0, KHeight-50, KWidth, 250)];
        [self.view addSubview:_ShoppingListView];
        
        
        _ShoppingListView =[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-50, SCREEN_WIDTH, 50)];
        _ShoppingListView.backgroundColor=[UIColor whiteColor];
        choseDone=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 0, 90, 50)];
        choseDone.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
        [choseDone setTitle:[NSString stringWithFormat:@"%@元起送",_beginprice] forState:UIControlStateNormal];
        [choseDone addTarget:self action:@selector(payForShoppingCar) forControlEvents:UIControlEventTouchUpInside];
        [choseDone setEnabled:NO];
        [_ShoppingListView addSubview:choseDone];
        _lableinShoppingList=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, SCREEN_WIDTH-100, 30)];
        [_lableinShoppingList setTextAlignment:NSTextAlignmentCenter];
        _lableinShoppingList.text=@"购物车内没有物品";
        _lableinShoppingList.textColor=[UIColor grayColor];
        [_ShoppingListView addSubview:_lableinShoppingList];
        [self.view addSubview:_ShoppingListView];
        
        _shoppingListPage=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 50)];
        [self.view addSubview:_shoppingListPage];
        
        
        BackView_gouwuche_icon=[[UIView alloc] initWithFrame:CGRectMake(10,SCREEN_HEIGHT-85, 60, 60)];
        BackView_gouwuche_icon.layer.masksToBounds=YES;
        BackView_gouwuche_icon.layer.cornerRadius=30;
        BackView_gouwuche_icon.backgroundColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1.0];
        
        UIImageView * img_gouwuche_icon=[[UIImageView alloc] initWithFrame:CGRectMake(16.0,16.5, 27, 27)];
        img_gouwuche_icon.image=[UIImage imageNamed:@"gouwuche_icon"];
        img_gouwuche_icon.backgroundColor=[UIColor clearColor];
        [BackView_gouwuche_icon addSubview:img_gouwuche_icon];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ShowGouWuChe)];
        
        [BackView_gouwuche_icon addGestureRecognizer:tapGesture];
        
//        UIButton * gouwuche_icon=[[UIButton alloc] initWithFrame:CGRectMake(0,0,60,60)];
//        gouwuche_icon.layer.masksToBounds=YES;
//        [gouwuche_icon setShowsTouchWhenHighlighted:NO];
//        gouwuche_icon.layer.cornerRadius=30;
//        gouwuche_icon.adjustsImageWhenHighlighted = NO;
//        [gouwuche_icon setBackgroundColor:[UIColor clearColor]];
//        [gouwuche_icon addTarget:self action:@selector(ShowGouWuChe) forControlEvents:UIControlEventTouchUpInside];
//        [BackView_gouwuche_icon addSubview:gouwuche_icon];
        [self.view addSubview:BackView_gouwuche_icon];
        
        _locationForbadge=[[UILabel alloc] initWithFrame:CGRectMake(BackView_gouwuche_icon.frame.origin.x+BackView_gouwuche_icon.frame.size.width-10, BackView_gouwuche_icon.frame.origin.y+10, 5, 5)];
        [self.view addSubview:_locationForbadge];
        
        DataProvider * cantingdataprovider =[[DataProvider alloc] init];
        [cantingdataprovider setDelegateObject:self setBackFunctionName:@"BuildCategray:"];
        [cantingdataprovider GetCantingCategory:_resid];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    @finally {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 创建左侧的分类栏
-(void)BuildCategray:(id)dict
{
    [SVProgressHUD dismiss];
    NSLog(@"%@",dict);
    if (1==[dict[@"status"] integerValue]) {
        tableView_gouwuche=[[UITableView alloc] init];
        _areaScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth/3, _CantingPage.frame.size.height)];
        _areaScroll.scrollEnabled=YES;
        _areaScroll.backgroundColor=[UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1.0];
        id result =dict;
        NSString *catid=@"";
        if (result) {
            NSArray * areaArray =[[NSArray alloc ] initWithArray:result[@"data"]];
            for (int i=0; i<areaArray.count; i++) {
                UIView * lastview=[_areaScroll.subviews lastObject];
                UIButton * areaitem=[[UIButton alloc] initWithFrame:CGRectMake(0, lastview.frame.origin.y+lastview.frame.size.height, KWidth/3, KAreaListHeight)];
                
                [areaitem setTag:[areaArray[i][@"catid"] intValue]];
                if (i==0) {
                    [areaitem setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    areaitem.backgroundColor=[UIColor whiteColor];
                    catid=areaArray[i][@"catid"];
                }
                else
                {
                    [areaitem setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                    areaitem.backgroundColor=[UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1.0];
                }
                areaitem.titleLabel.font=[UIFont systemFontOfSize:14];
                [areaitem setTitle:[NSString stringWithFormat:@"%@",areaArray[i][@"name"]] forState:UIControlStateNormal];
                [areaitem addTarget:self action:@selector(CantingItemClick:) forControlEvents:UIControlEventTouchUpInside];
                UIView * isred=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 3, areaitem.frame.size.height)];
                if (i==0) {
                    isred.backgroundColor=[UIColor redColor];
                }
                isred.tag=1111;
                [areaitem addSubview:isred];
                [_areaScroll addSubview:areaitem];
                UIView * Backview=[[UIView alloc] initWithFrame:CGRectMake(0, areaitem.frame.origin.y+areaitem.frame.size.height, _areaScroll.frame.size.width, 1)];
                Backview.backgroundColor=[UIColor colorWithRed:218/255.0 green:218/255.0 blue:228/255.0 alpha:1.0];
                [_areaScroll addSubview:Backview];
            }
            _areaScroll.contentSize=CGSizeMake(0, areaArray.count*(KAreaListHeight+1));
        }
        [_CantingPage addSubview:_areaScroll];
        DataProvider * dataprovider =[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"BuildGoodsList:"];
        [dataprovider GetGoodsinCategory:catid];
    }
    
    
    
}

-(void)CantingSegMentControlClick
{
    @try {
        if (1==self.CantingsegmentedControl.selectedSegmentIndex) {
            _CantingPage.hidden=YES;
            NSLog(@"other");
            _ShoppingListView.hidden=YES;
            BackView_gouwuche_icon.hidden=YES;
            if (_badgeView) {
                _badgeView.hidden=YES;
            }
            
            if (dictionary) {
                
                DataProvider *dataprovider=[[DataProvider alloc] init];
                [dataprovider setDelegateObject:self setBackFunctionName:@"CanTingXiangqingBackCall:"];
                [dataprovider GetCantingXiangqing:_resid anduserid:dictionary[@"userid"]];
            }
        }
        else
        {
            _CantingPage.hidden=NO;
            _ShoppingListView.hidden=NO;
            BackView_gouwuche_icon.hidden=NO;
            if (_badgeView) {
                _badgeView.hidden=NO;
            }
            _CantingOtherPage.hidden=YES;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"CantingInfoViewController%@",exception);
    }
    @finally {
        
    }
    
}
-(void)CantingItemClick:(UIButton *)sender
{
    for (UIView * item in _areaScroll.subviews) {
        if ([item isKindOfClass:[UIButton class]]) {
            UIButton * itemBtn =(UIButton *)item;
            for (UIView *itemview in itemBtn.subviews) {
                if (itemview.tag==1111) {
                    itemview.backgroundColor=[UIColor clearColor];
                }
            }
            item.backgroundColor=[UIColor colorWithRed:236/255.0 green:237/255.0 blue:241/255.0 alpha:1.0];
            [itemBtn setTitleColor:[UIColor blackColor]  forState:UIControlStateNormal];
        }
    }
    sender.backgroundColor=[UIColor whiteColor];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    for (UIView *itemview in sender.subviews) {
        if (itemview.tag==1111) {
            itemview.backgroundColor=[UIColor redColor];
        }
    }
    DataProvider * dataprovider =[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"BuildGoodsList:"];
    [dataprovider GetGoodsinCategory:[NSString stringWithFormat:@"%d",(int)sender.tag]];
}

-(void)BuildGoodsList:(id)dict
{
    NSLog(@"%@",dict);
    GoodsListArray=dict[@"data"];
    if (_GoodsList) {
        [_GoodsList removeFromSuperview];
    }
    if (![GoodsListArray isEqual:@""]) {
        _GoodsList=[[UITableView alloc] initWithFrame:CGRectMake(KWidth/3, 0, KWidth-KWidth/3, _CantingPage.frame.size.height)];
        _GoodsList.delegate=self;
        _GoodsList.dataSource=self;
        _GoodsList.tag=1;
        [_CantingPage addSubview:_GoodsList];
    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return GoodsListArray.count;
    }
    else
    {
        return ShoppingCar.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        static NSString *CellIdentifier = @"GoodsTableViewCell";
        GoodsTableViewCell *cell = (GoodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell  = [[[NSBundle mainBundle] loadNibNamed:@"GoodsTableViewCell" owner:self options:nil] lastObject];
            cell.goodimg.layer.masksToBounds=YES;
            cell.goodimg.layer.cornerRadius=4;
            [cell.goodimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,GoodsListArray[indexPath.row][@"pic"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
            cell.goodName.text=GoodsListArray[indexPath.row][@"name"];
            cell.goodPrice.text=[NSString stringWithFormat:@"¥%@",GoodsListArray[indexPath.row][@"price"]];
            cell.goodSell.text=[[NSString stringWithFormat:@"已售%@份",GoodsListArray[indexPath.row][@"soldnum"] ]stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
            cell.personPush.text=[[NSString stringWithFormat:@"推荐%@",GoodsListArray[indexPath.row][@"recommendnum"] ]stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
//            UIButton * image_add=[[UIButton alloc] initWithFrame:CGRectMake(187, 57, 20, 20)];
//            image_add.layer.masksToBounds=YES;
//            image_add.layer.cornerRadius=12.5;
//            [image_add setImage:[UIImage imageNamed:@"jia_quan.png"] forState:UIControlStateNormal];
//            [image_add addTarget:self action:@selector(GoodsAddClick:) forControlEvents:UIControlEventTouchUpInside];
//            [image_add setTag:indexPath.row];
//            [cell addSubview:image_add];
//            
//            UIButton * image_jian=[[UIButton alloc] initWithFrame:CGRectMake(131, 57, 20, 20)];
//            image_jian.layer.masksToBounds=YES;
//            image_jian.layer.cornerRadius=12.5;
//            [image_jian setImage:[UIImage imageNamed:@"jian_quan.png"] forState:UIControlStateNormal];
//            [image_jian setTag:indexPath.row];
//            [cell addSubview:image_jian];
//            UILabel * lbl_cellNum=[[UILabel alloc] initWithFrame:CGRectMake(150, 57, 37, 20)];
//            [lbl_cellNum setTextAlignment:NSTextAlignmentCenter];
//            lbl_cellNum.tag=indexPath.row;
//            lbl_cellNum.font=[UIFont systemFontOfSize:13];
//            [cell addSubview:lbl_cellNum];
//            [lbl_array addObject:lbl_cellNum];
            BOOL isExit=false;
            ShoppingCarModel * mydata;
            for (ShoppingCarModel * item in ShoppingCar) {
                //            NSLog(@"分类：要添加的：%@,要比较的%@",GoodsListArray[sender.tag][@"category"],item.Goods[@"category"]);
                //            NSLog(@"id：要添加的：%@,要比较的%@",GoodsListArray[sender.tag][@"goodsid"],item.Goods[@"goodsid"]);
                if ([GoodsListArray[indexPath.row][@"category"] isEqual:item.Goods[@"category"]]&&[GoodsListArray[indexPath.row][@"goodsid"]isEqual:item.Goods[@"goodsid"]]) {
                    isExit=YES;
                    mydata= ShoppingCar[[ShoppingCar indexOfObject:item]];
                    break;
                }
            }
            [cell.goodAdd addTarget:self action:@selector(GoodsAddClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.goodAdd.tag=indexPath.row;
            [cell.goodjian addTarget:self action:@selector(goodsJianClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.goodjian.tag=indexPath.row;
            cell.goodnum.text=[NSString stringWithFormat:@"%d",isExit?mydata.Num:0];
            
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
    else
    {
        static NSString *CellIdentifier = @"shopcarTableViewCell";
        ShoppingCarTableViewCell *cell = (ShoppingCarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell  = [[[NSBundle mainBundle] loadNibNamed:@"ShoppingCarTableViewCell" owner:self options:nil] lastObject];
            ShoppingCarModel * item=ShoppingCar[indexPath.row];
            cell.lbl_title.text=item.Goods[@"name"];
            cell.lbl_num.text=[NSString stringWithFormat:@"%d",item.Num];
            [cell.btn_jian addTarget:self action:@selector(jian_btnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_jian.tag=indexPath.row;
            [cell.btn_jia addTarget:self action:@selector(jia_btnClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.btn_jia.tag=indexPath.row;
            cell.lbl_price.text=[NSString stringWithFormat:@"¥%@",item.Goods[@"price"]];
        }
        return cell;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return 100;
    }
    else
    {
        return 50;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark 点餐，点击后添加到购物车
-(void)GoodsAddClick:(UIButton *)sender
{
    NSLog(@"添加一份");
    isClick=NO;
    int goodsCount=0;
    int SumPrice=0;
    for (UILabel *item in lbl_array) {
        if (item.tag==sender.tag) {
            item.text=[NSString stringWithFormat:@"%d",[item.text intValue]+1];
        }
    }
    BackView_gouwuche_icon.backgroundColor=[UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
    ShoppingCarModel * shopModel=[[ShoppingCarModel alloc] init];
    if (ShoppingCar.count>0) {
        int i=0;
        BOOL isExit=false;
        
        ShoppingCarModel * mydata;
        for (ShoppingCarModel * item in ShoppingCar) {
//            NSLog(@"分类：要添加的：%@,要比较的%@",GoodsListArray[sender.tag][@"category"],item.Goods[@"category"]);
//            NSLog(@"id：要添加的：%@,要比较的%@",GoodsListArray[sender.tag][@"goodsid"],item.Goods[@"goodsid"]);
            i++;
            if ([GoodsListArray[sender.tag][@"category"] isEqual:item.Goods[@"category"]]&&[GoodsListArray[sender.tag][@"goodsid"]isEqual:item.Goods[@"goodsid"]]) {
                isExit=YES;
                mydata= ShoppingCar[[ShoppingCar indexOfObject:item]];
                break;
            }
        }
        if (!isExit) {
            shopModel.Num=1;
            shopModel.Goods=GoodsListArray[sender.tag];
            [ShoppingCar addObject:shopModel];
        }
        else
        {
            mydata.Num+=1;
        }
    }else{
        shopModel.Num=1;
        shopModel.Goods=GoodsListArray[sender.tag];
        [ShoppingCar addObject:shopModel];
    }
    for (ShoppingCarModel * item in ShoppingCar) {
        goodsCount+=item.Num;
    }
    if (_badgeView) {
         _badgeView.badgeText = [NSString stringWithFormat:@"%d",goodsCount];
    }
    else
    {
        _badgeView = [[JSBadgeView alloc] initWithParentView:_locationForbadge alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.layer.masksToBounds=YES;
        _badgeView.layer.cornerRadius=8;
        _badgeView.badgeText = [NSString stringWithFormat:@"%d",goodsCount];
        _badgeView.backgroundColor=[UIColor redColor];
    }
    for (int i=0; i<ShoppingCar.count; i++) {
        ShoppingCarModel * item=ShoppingCar[i];
        NSString * price=item.Goods[@"price"];
        SumPrice+=item.Num*[price intValue];
    }
    _lableinShoppingList.text=[NSString stringWithFormat:@"共¥%d",SumPrice];
    
    if (SumPrice>=[_beginprice floatValue]) {
        [choseDone setEnabled:YES];
        [choseDone setTitle:@"选好了"  forState:UIControlStateNormal];
        [choseDone setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];
    }
    else
    {
        int lastprice=[_beginprice intValue]-SumPrice;
        [choseDone setTitle:[NSString stringWithFormat:@"还差%d元",lastprice]  forState:UIControlStateNormal];
        choseDone.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    }
    [tableView_gouwuche reloadData];
    [_GoodsList reloadData];
}

-(void)goodsJianClick:(UIButton *)sender
{
    NSLog(@"减少一份");
    
    isClick=NO;
    int goodsCount=0;
    int SumPrice =0;
    if (ShoppingCar.count>0) {
        int i=0;
        BOOL isExit=false;
        
        ShoppingCarModel * mydata;
        for (ShoppingCarModel * item in ShoppingCar) {
//            NSLog(@"分类：要添加的：%@,要比较的%@",GoodsListArray[sender.tag][@"category"],item.Goods[@"category"]);
//            NSLog(@"id：要添加的：%@,要比较的%@",GoodsListArray[sender.tag][@"goodsid"],item.Goods[@"goodsid"]);
            i++;
            if ([GoodsListArray[sender.tag][@"category"] isEqual:item.Goods[@"category"]]&&[GoodsListArray[sender.tag][@"goodsid"]isEqual:item.Goods[@"goodsid"]]) {
                isExit=YES;
                mydata= ShoppingCar[[ShoppingCar indexOfObject:item]];
                break;
            }
        }
        if (isExit&&mydata.Num>0) {
            mydata.Num-=1;
        }
        for (ShoppingCarModel * item in ShoppingCar) {
            goodsCount+=item.Num;
        }
        
    }
    if (_badgeView) {
        _badgeView.badgeText = [NSString stringWithFormat:@"%d",goodsCount];
    }
    else
    {
        _badgeView = [[JSBadgeView alloc] initWithParentView:_locationForbadge alignment:JSBadgeViewAlignmentTopRight];
        _badgeView.badgeText = [NSString stringWithFormat:@"%d",goodsCount];
        _badgeView.backgroundColor=[UIColor redColor];
    }
    
    for (int i=0; i<ShoppingCar.count; i++) {
        ShoppingCarModel * item=ShoppingCar[i];
        NSString * price=item.Goods[@"price"];
        SumPrice+=item.Num*[price intValue];
    }
    _lableinShoppingList.text=[NSString stringWithFormat:@"共¥%d",SumPrice];
    if (SumPrice<[_beginprice floatValue]) {
        [choseDone setEnabled:NO];
        int lastprice=[_beginprice intValue]-SumPrice;
        [choseDone setTitle:[NSString stringWithFormat:@"还差%d元",lastprice]  forState:UIControlStateNormal];
        choseDone.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    }
    else
    {
        BackView_gouwuche_icon.backgroundColor=[UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
        [choseDone setTitle:@"选好了"  forState:UIControlStateNormal];
        choseDone.backgroundColor=[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1.0];
    }
    [tableView_gouwuche reloadData];
    [_GoodsList reloadData];
}

/**
 *  点击购物车按钮弹出购物车
 */
-(void)ShowGouWuChe
{
    float SumPrice=0;
    [choseDone setEnabled:YES];
    [choseDone setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];

    int viewheight=ShoppingCar.count<4?(ShoppingCar.count*50):200;
    for (int i=0; i<ShoppingCar.count; i++) {
        ShoppingCarModel * item=ShoppingCar[i];
        NSString * price=item.Goods[@"price"];
        SumPrice+=item.Num*[price floatValue];
    }
    tableView_gouwuche.frame=CGRectMake(0, 0, SCREEN_WIDTH, viewheight);
    tableView_gouwuche.delegate=self;
    tableView_gouwuche.dataSource=self;
    
    if (!isgouwucheShow ){
        
        Backview=[[UIView alloc] initWithFrame:_ShoppingListView.frame];
        Backview.backgroundColor=[UIColor colorWithRed:235/255.0 green:235/255.0 blue:237/255.0 alpha:1.0];
        UILabel * lbl_gouwuche_Title=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 60, 20)];
        lbl_gouwuche_Title.text=@"购物车";
        lbl_gouwuche_Title.textColor=[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0];
        [Backview addSubview:lbl_gouwuche_Title];
        
        UIImageView  * img_del=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-120, 10, 18, 20)];
        img_del.image=[UIImage imageNamed:@"ic_clear_search_history"];
        [Backview addSubview:img_del];
        
        UILabel * lbl_clearTitle=[[UILabel alloc] initWithFrame:CGRectMake(img_del.frame.origin.x+img_del.frame.size.width+10, 10, 80, 20)];
        lbl_clearTitle.text=@"清空全部";
        lbl_clearTitle.textColor=[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0];
        [Backview addSubview:lbl_clearTitle];
        UIButton * btn_clearAll=[[UIButton alloc] initWithFrame:CGRectMake(img_del.frame.origin.x, 5, 110, 30)];
        [btn_clearAll addTarget:self action:@selector(clearnAll) forControlEvents:UIControlEventTouchUpInside];
        [Backview addSubview:btn_clearAll];
        
        
        //购物车列表出现
        [_shoppingListPage addSubview:tableView_gouwuche];
        _shoppingListPage.frame=CGRectMake(0, SCREEN_HEIGHT-viewheight-50, SCREEN_WIDTH, viewheight);
        [self.view addSubview:_ShoppingListView];
        BackView_gouwuche_icon.frame=CGRectMake(BackView_gouwuche_icon.frame.origin.x, BackView_gouwuche_icon.frame.origin.y-viewheight-50, BackView_gouwuche_icon.frame.size.width, BackView_gouwuche_icon.frame.size.height);
        Backview.frame=CGRectMake(0, BackView_gouwuche_icon.frame.origin.y+50, SCREEN_WIDTH, 40);
        [self.view addSubview:Backview];
        BackView_gouwuche_icon.backgroundColor=[UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
        [self.view addSubview:BackView_gouwuche_icon];
        _ShoppingListView.backgroundColor=[UIColor whiteColor];
        _lableinShoppingList.text=[NSString stringWithFormat:@"共¥%.2f",SumPrice];
        [_lableinShoppingList setTextColor:[UIColor redColor]];
        _locationForbadge.frame=CGRectMake(_locationForbadge.frame.origin.x, _locationForbadge.frame.origin.y-viewheight-50, 5, 5);
        [self.view addSubview:_locationForbadge];
        isgouwucheShow=YES;
    }else
    {
        [Backview removeFromSuperview];
        _shoppingListPage.frame=CGRectMake(0, SCREEN_HEIGHT+viewheight+50, KWidth, viewheight);
        [self.view addSubview:_ShoppingListView];
        BackView_gouwuche_icon.frame=CGRectMake(BackView_gouwuche_icon.frame.origin.x, BackView_gouwuche_icon.frame.origin.y+viewheight+50, BackView_gouwuche_icon.frame.size.width, BackView_gouwuche_icon.frame.size.height);
        BackView_gouwuche_icon.backgroundColor=[UIColor colorWithRed:255/255.0 green:180/255.0 blue:0/255.0 alpha:1.0];
        [self.view addSubview:BackView_gouwuche_icon];
        _ShoppingListView.backgroundColor=[UIColor whiteColor];
        _lableinShoppingList.text=[NSString stringWithFormat:@"共¥%.2f",SumPrice];
        _locationForbadge.frame=CGRectMake(_locationForbadge.frame.origin.x, _locationForbadge.frame.origin.y+viewheight+50, 5, 5);
        [self.view addSubview:_locationForbadge];
        isgouwucheShow=NO;
    }
}

-(void)clearnAll
{
    
}

- (UIColor *) stringTOColor:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}

-(void)jian_btnClick:(UIButton *)sender
{
    [sender.superview removeFromSuperview];
    UILabel * mylable;
    NSArray * superarray=[[sender superview] subviews];
    for (int i=0; i<superarray.count; i++) {
        if ([superarray[i] isKindOfClass:[UILabel class]]) {
            mylable=superarray[i];
            if (110!=mylable.tag) {
                mylable=nil;
                continue;
            }
            break;
        }
    }
    ShoppingCarModel * item=ShoppingCar[sender.tag];
    if (0==item.Num-1) {
        
        [ShoppingCar removeObjectAtIndex:sender.tag];
        _badgeView.badgeText = [NSString stringWithFormat:@"%lu",(unsigned long)ShoppingCar.count];
        tableView_gouwuche.frame=CGRectMake(tableView_gouwuche.frame.origin.x, tableView_gouwuche.frame.origin.y+50, tableView_gouwuche.frame.size.width, tableView_gouwuche.frame.size.height);
        BackView_gouwuche_icon.frame=CGRectMake(BackView_gouwuche_icon.frame.origin.x, BackView_gouwuche_icon.frame.origin.y+50, BackView_gouwuche_icon.frame.size.width, BackView_gouwuche_icon.frame.size.height);
        _locationForbadge.frame=CGRectMake(_locationForbadge.frame.origin.x, _locationForbadge.frame.origin.y+50, 5, 5);
        Backview.frame=CGRectMake(Backview.frame.origin.x, Backview.frame.origin.y+50, Backview.frame.size.width, Backview.frame.size.height);
    }
    else
    {
        mylable.text=[NSString stringWithFormat:@"%d",[mylable.text intValue]-1];
        ShoppingCarModel * modelofshoppingcar= ShoppingCar[sender.tag];
        modelofshoppingcar.Num-=1;
        _lableinShoppingList.text=[NSString stringWithFormat:@"共¥%.2f",[_lableinShoppingList.text floatValue]-[modelofshoppingcar.Goods[@"price"] floatValue]] ;
    }
    [tableView_gouwuche reloadData];
    [_GoodsList reloadData];
}

-(void)jia_btnClick:(UIButton *)sender
{
    UILabel * mylable;
    NSArray * superarray=[[sender superview] subviews];
    for (int i=0; i<superarray.count; i++) {
        if ([superarray[i] isKindOfClass:[UILabel class]]) {
            mylable=superarray[i];
            if (110!=mylable.tag) {
                mylable=nil;
                continue;
            }
            break;
        }
    }
    int shengxia=[mylable.text intValue]+1;
    if (0==shengxia) {
        [sender.superview removeFromSuperview];
        [ShoppingCar removeObjectAtIndex:sender.tag];
        [self ShowGouWuChe];
    }
    else
    {
        mylable.text=[NSString stringWithFormat:@"%d",[mylable.text intValue]+1];
        ShoppingCarModel * modelofshoppingcar= ShoppingCar[sender.tag];
        modelofshoppingcar.Num+=1;
        _lableinShoppingList.text=[NSString stringWithFormat:@"共¥%.2f",[_lableinShoppingList.text floatValue]+[modelofshoppingcar.Goods[@"price"] floatValue]] ;
    }
    [tableView_gouwuche reloadData];
    [_GoodsList reloadData];
    
}

-(void)payForShoppingCar
{
    if (dictionary[@"userid"]) {
        NSMutableArray * orderdataArray=[[NSMutableArray alloc] init];
        
        for (int i=0; i<ShoppingCar.count; i++) {
            NSMutableDictionary * dict=[[NSMutableDictionary alloc] init];
            ShoppingCarModel *item=ShoppingCar[i];
            [dict setObject:item.Goods[@"goodsid"] forKey:@"goodsid"];
            [dict setObject:item.Goods[@"name"] forKey:@"goodsname"];
            [dict setObject:item.Goods[@"activity"] forKey:@"activity"];
            [dict setObject:[NSString stringWithFormat:@"%d",item.Num] forKey:@"count"];
            [dict setObject:item.Goods[@"price"] forKey:@"price"];
            
            [orderdataArray addObject:dict];
        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:orderdataArray
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        NSDictionary * prm=@{@"goodsdetail":jsonString,@"deliveryprice":_beginprice};
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"GetorderPriceBackCall:"];
        [dataprovider GetOrderPrice:prm];
    }
    else
    {
        LoginViewController * _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        [_myLogin setDelegateObject:self setBackFunctionName:@"CantingLoginBackCall:"];
        [self.navigationController pushViewController:_myLogin animated:YES];
    }
}
-(void)CantingLoginBackCall:(id)dict
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    dictionary =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
}
-(void)GetorderPriceBackCall:(id)dict
{
    if ([dict[@"status"] intValue]==1) {
        _myOrderView=[[OrderForSureViewController alloc] initWithNibName:@"OrderForSureViewController" bundle:[NSBundle mainBundle]];
        _myOrderView.orderData=ShoppingCar;
        _myOrderView.resid=_resid;
        _myOrderView.peiSongFeiData=_peisongData;
        _myOrderView.orderSumPrice=dict[@"data"][@"totalprice"];
        [self.navigationController pushViewController:_myOrderView animated:YES];

    }
}

-(void)CanTingXiangqingBackCall:(id)dict
{
    NSLog(@"%@",dict);
    if (dict[@"data"]) {
        cantingxiangqingData=dict[@"data"];
        if ([dict[@"data"][@"iscollected"] integerValue]==0) {
            [self addRightButton:@"shoucang@2x.png"];
            isShouCang=NO;
        }
        else
        {
            isShouCang=YES;
            [self addRightButton:@"shoucang-@2x.png"];
        }
        _imgRight.bounds=CGRectMake(0, 0, 20, 20);
        CGFloat y=CantingsegmentView.frame.origin.y+CantingsegmentView.frame.size.height;
        _CantingOtherPage=[[UIView alloc] initWithFrame:CGRectMake(0, y, KWidth, KHeight-y)];
        _CantingOtherPage.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        UIScrollView * otherViewScroll=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight-y)];
        otherViewScroll.scrollEnabled=YES;
        otherViewScroll.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
        
        
        UIView * CantingHeadView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, _CantingOtherPage.frame.size.width,80)];
        CantingHeadView.backgroundColor=[UIColor whiteColor];
        UIImageView * cantingLogo=[[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 50, 50)];
        cantingLogo.layer.masksToBounds=YES;
        cantingLogo.layer.cornerRadius=5;
        [cantingLogo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"logo"]]] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        [CantingHeadView addSubview:cantingLogo];
        UILabel * lbl_cantingName=[[UILabel alloc] initWithFrame:CGRectMake(cantingLogo.frame.origin.x+cantingLogo.frame.size.width+20, 15, 150, 20)];
        lbl_cantingName.text=dict[@"data"][@"name"];
        [CantingHeadView addSubview:lbl_cantingName];
        
        UIButton * btn_share=[[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-50, lbl_cantingName.frame.origin.y, 40, 20)];
        [btn_share setImage:[UIImage imageNamed:@"canting_share_icom"] forState:UIControlStateNormal];
        [btn_share addTarget:self action:@selector(Btn_shareClick) forControlEvents:UIControlEventTouchUpInside];
        [CantingHeadView addSubview:btn_share];
        
        AMRatingControl * amratingcontrol= [[AMRatingControl alloc] initWithLocation:CGPointMake(lbl_cantingName.frame.origin.x,lbl_cantingName.frame.origin.y+lbl_cantingName.frame.size.height+8 )
                                       emptyColor:[UIColor lightGrayColor]
                                       solidColor:[UIColor redColor]
                                     andMaxRating:5];
        [amratingcontrol setUserInteractionEnabled:NO];
        amratingcontrol.backgroundColor=[UIColor clearColor];
        amratingcontrol.rating=[dict[@"data"][@"totalcredit"] intValue];
        
//        CWStarRateView * cwstarrateView=[[CWStarRateView alloc] initWithFrame:CGRectMake(lbl_cantingName.frame.origin.x,lbl_cantingName.frame.origin.y+lbl_cantingName.frame.size.height+10,lbl_cantingName.frame.origin.x,lbl_cantingName.frame.origin.y+lbl_cantingName.frame.size.height-10 ) numberOfStars:5];
//        cwstarrateView.scorePercent = [dict[@"data"][@"totalcredit"] floatValue]/5;
//        cwstarrateView.allowIncompleteStar = NO;
//        cwstarrateView.hasAnimation = YES;
        [CantingHeadView addSubview:amratingcontrol];
        
        
        
        UIView * lastView=CantingHeadView;
        UIView * BackView_time=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.origin.y+lastView.frame.size.height+1, (KWidth-2)/3, 60)];
        BackView_time.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_qisongjia=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 40, 30)];
        lbl_qisongjia.text=[NSString stringWithFormat:@"¥%@",dict[@"data"][@"begindeliveryprice"]];
        [lbl_qisongjia setTextAlignment:NSTextAlignmentCenter];
        [BackView_time addSubview:lbl_qisongjia];
        UILabel * lbl_qisongjianame=[[UILabel alloc] initWithFrame:CGRectMake(lbl_qisongjia.frame.origin.x, lbl_qisongjia.frame.origin.y+lbl_qisongjia.frame.size.height+5, 40, 15)];
        lbl_qisongjianame.text=@"起送价";
        lbl_qisongjianame.font=[UIFont fontWithName:@"Helvetica" size:12];
        lbl_qisongjianame.textColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
        [lbl_qisongjianame setTextAlignment:NSTextAlignmentCenter];
        [BackView_time addSubview:lbl_qisongjianame];
        [otherViewScroll addSubview:BackView_time];
        
        UIView * BackView_WaiSongFei=[[UIView alloc] initWithFrame:CGRectMake(BackView_time.frame.origin.x+BackView_time.frame.size.width+1, lastView.frame.origin.y+lastView.frame.size.height+1, (KWidth-2)/3, 60)];
        BackView_WaiSongFei.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_waisongfei=[[UILabel alloc] initWithFrame:CGRectMake(30, 10, 40, 30)];
        lbl_waisongfei.text=[NSString stringWithFormat:@"¥%@",dict[@"data"][@"deliveryprice"]];
        [lbl_waisongfei setTextAlignment:NSTextAlignmentCenter];
        [BackView_WaiSongFei addSubview:lbl_waisongfei];
        UILabel * lbl_waisongfeiname=[[UILabel alloc] initWithFrame:CGRectMake(lbl_qisongjia.frame.origin.x, lbl_qisongjia.frame.origin.y+lbl_qisongjia.frame.size.height+5, 40, 15)];
        lbl_waisongfeiname.text=@"外送费";
        lbl_waisongfeiname.textColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
        lbl_waisongfeiname.font=[UIFont fontWithName:@"Helvetica" size:12];
        [lbl_waisongfeiname setTextAlignment:NSTextAlignmentCenter];
        [BackView_WaiSongFei addSubview:lbl_waisongfeiname];
        [otherViewScroll addSubview:BackView_WaiSongFei];
        
        UIView * BackView_WaiSongTime=[[UIView alloc] initWithFrame:CGRectMake(BackView_WaiSongFei.frame.origin.x+BackView_WaiSongFei.frame.size.width+1, lastView.frame.origin.y+lastView.frame.size.height+1, (KWidth-2)/3, 60)];
        BackView_WaiSongTime.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_waisongtime=[[UILabel alloc] initWithFrame:CGRectMake(5, 10, 100, 30)];
        lbl_waisongtime.text=[NSString stringWithFormat:@"%@分钟",dict[@"data"][@"deliverytime"]];
        [lbl_waisongtime setTextAlignment:NSTextAlignmentCenter];
        [BackView_WaiSongTime addSubview:lbl_waisongtime];
        UILabel * lbl_waisongtimename=[[UILabel alloc] initWithFrame:CGRectMake(lbl_qisongjia.frame.origin.x, lbl_qisongjia.frame.origin.y+lbl_qisongjia.frame.size.height+5, 60, 15)];
        lbl_waisongtimename.text=@"外送时间";
        lbl_waisongtimename.textColor=[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0];
        lbl_waisongtimename.font=[UIFont fontWithName:@"Helvetica" size:12];
        [lbl_waisongtimename setTextAlignment:NSTextAlignmentCenter];
        [BackView_WaiSongTime addSubview:lbl_waisongtimename];
        [otherViewScroll addSubview:BackView_WaiSongTime];
        
        lastView=BackView_WaiSongTime;
        UIView * BackView_userPingjia=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 40)];
        BackView_userPingjia.backgroundColor=[UIColor whiteColor];
        UILabel * viewTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        viewTitle.text=@"用户评论";
        [BackView_userPingjia addSubview:viewTitle];
        UILabel * commentcount=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 60, 20)];
        commentcount.text=[NSString stringWithFormat:@"(%@条)",dict[@"data"][@"commentCount"]];
        commentcount.textColor=[UIColor redColor];
        [BackView_userPingjia addSubview:commentcount];
        UIImageView * goImg=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-25, 10, 14, 20)];
        goImg.image=[UIImage imageNamed:@"go.png"];
        [BackView_userPingjia addSubview:goImg];
        [otherViewScroll addSubview:BackView_userPingjia];
        UIButton * btn_pingjia=[[UIButton alloc] initWithFrame:BackView_userPingjia.frame];
        [btn_pingjia addTarget:self action:@selector(GetPinglun) forControlEvents:UIControlEventTouchUpInside];
        [otherViewScroll addSubview:btn_pingjia];
        
        lastView=BackView_userPingjia;
//        UIView * BackView_youhuiquan=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 40)];
//        BackView_youhuiquan.backgroundColor=[UIColor whiteColor];
//        UIImageView * imgView=[[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 15, 15)];
//        imgView.image=[UIImage imageNamed:@"quan"];
//        [BackView_youhuiquan addSubview:imgView];
//        UILabel * lbl_Viewtitle=[[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+8, 10, 200, 20)];
//        lbl_Viewtitle.text=[NSString stringWithFormat:@"餐厅可使用优惠券"];
//        [BackView_youhuiquan addSubview:lbl_Viewtitle];
//        [otherViewScroll addSubview:BackView_youhuiquan];
//        
//        lastView=BackView_youhuiquan;
//        UIView * BackView_che=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+1 , KWidth, 40)];
//        BackView_che.backgroundColor=[UIColor whiteColor];
//        UIImageView * imgView_che=[[UIImageView alloc] initWithFrame:CGRectMake(20, 12.5, 15, 15)];
//        imgView_che.image=[UIImage imageNamed:@"che"];
//        [BackView_che addSubview:imgView_che];
//        UILabel * lbl_cheViewtitle=[[UILabel alloc] initWithFrame:CGRectMake(imgView.frame.origin.x+imgView.frame.size.width+8, 10, 200, 20)];
//        lbl_cheViewtitle.text=[NSString stringWithFormat:@"新用户可获Uber 5-50元券"];
//        [BackView_che addSubview:lbl_cheViewtitle];
//        [otherViewScroll addSubview:BackView_che];
//        
//        
//        lastView=BackView_che;
        UIView * BackView_pic=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 40)];
        BackView_pic.backgroundColor=[UIColor whiteColor];
        UILabel * picviewTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        picviewTitle.text=[NSString stringWithFormat:@"店铺相册"];
        [BackView_pic addSubview:picviewTitle];
        UILabel * piccount=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 60, 20)];
        piccount.text=[NSString stringWithFormat:@"(%@条)",dict[@"data"][@"albumcount"]];
        piccount.textColor=[UIColor redColor];
        [BackView_pic addSubview:piccount];
        goImg=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-25, 10, 14, 20)];
        goImg.image=[UIImage imageNamed:@"go.png"];
        [BackView_pic addSubview:goImg];
        [otherViewScroll addSubview:BackView_pic];
        UIButton * btn_pic=[[UIButton alloc] initWithFrame:BackView_pic.frame];
        [btn_pic addTarget:self action:@selector(gotoShopAlbum) forControlEvents:UIControlEventTouchUpInside];
        [otherViewScroll addSubview:btn_pic];
        
        lastView=BackView_pic;
        UIView * yingyeTime=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+1 , KWidth, 40)];
        yingyeTime.backgroundColor=[UIColor whiteColor];
        UILabel * yingyeviewTitle=[[UILabel alloc] initWithFrame:CGRectMake(13, 10, 100, 20)];
        [yingyeviewTitle setTextAlignment:NSTextAlignmentCenter];
        yingyeviewTitle.text=[NSString stringWithFormat:@"营业时间："];
        [yingyeTime addSubview:yingyeviewTitle];
        UILabel * lbl_time=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 200, 20)];
        lbl_time.text=[NSString stringWithFormat:@"%@~%@",dict[@"data"][@"start"],dict[@"data"][@"end"]];
        [yingyeTime addSubview:lbl_time];
        [otherViewScroll addSubview:yingyeTime];
        
        lastView=yingyeTime;
        UIView * BackView_Tel=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+1 , KWidth, 40)];
        BackView_Tel.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_TelTitle=[[UILabel alloc] initWithFrame:CGRectMake(13, 10, 100, 20)];
        [lbl_TelTitle setTextAlignment:NSTextAlignmentCenter];
        lbl_TelTitle.text=[NSString stringWithFormat:@"联系电话："];
        [BackView_Tel addSubview:lbl_TelTitle];
        UILabel * lbl_Tel=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 200, 20)];
        lbl_Tel.text=[NSString stringWithFormat:@"%@",dict[@"data"][@"contactnum"]];
        [BackView_Tel addSubview:lbl_Tel];
        [otherViewScroll addSubview:BackView_Tel];
        
        
        lastView=[otherViewScroll.subviews lastObject];
        UIView * BackView_address=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 40)];
        BackView_address.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_addressTitle=[[UILabel alloc] initWithFrame:CGRectMake(13, 10, 100, 20)];
        [lbl_addressTitle setTextAlignment:NSTextAlignmentCenter];
        lbl_addressTitle.text=[NSString stringWithFormat:@"店铺地址："];
        [BackView_address addSubview:lbl_addressTitle];
        UILabel * lbl_address=[[UILabel alloc] initWithFrame:CGRectMake(viewTitle.frame.origin.x+viewTitle.frame.size.width+1, 10, 200, 20)];
        lbl_address.text=[NSString stringWithFormat:@"%@",dict[@"data"][@"addressname"]];
        [BackView_address addSubview:lbl_address];
        [otherViewScroll addSubview:BackView_address];
        
        
        lastView=[otherViewScroll.subviews lastObject];
        UIView * BackView_Show=[[UIView alloc] initWithFrame:CGRectMake(0,lastView.frame.origin.y+lastView.frame.size.height+5 , KWidth, 140)];
        BackView_Show.backgroundColor=[UIColor whiteColor];
        UILabel * lbl_ShowTitle=[[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
        lbl_ShowTitle.text=[NSString stringWithFormat:@"简介："];
        [BackView_Show addSubview:lbl_ShowTitle];
        UILabel * lbl_Show=[[UILabel alloc] initWithFrame:CGRectMake(5, lbl_ShowTitle.frame.origin.y+lbl_ShowTitle.frame.size.height+2, BackView_Show.frame.size.width-10, 100)];
        lbl_Show.text=[NSString stringWithFormat:@"%@",dict[@"data"][@"introduction"]];
        [lbl_Show setLineBreakMode:NSLineBreakByWordWrapping];
        lbl_Show.numberOfLines=0;
        lbl_Show.font=[UIFont fontWithName:@"Helvetica" size:14];
        [BackView_Show addSubview:lbl_Show];
        [otherViewScroll addSubview:BackView_Show];
        
        
        otherViewScroll.contentSize=CGSizeMake(KWidth, BackView_Show.frame.origin.y+BackView_Show.frame.size.height);
        [otherViewScroll addSubview:CantingHeadView];
        [_CantingOtherPage addSubview:otherViewScroll];
        [self.view addSubview:_CantingOtherPage];
    }
    
}

-(void)GetPinglun
{
//    DataProvider * dataprovider=[[DataProvider alloc] init];
//    [dataprovider setDelegateObject:self setBackFunctionName:@"getPinglunBackCall:"];
//    [dataprovider GetPinglun:_resid andpage:@"1" andnumInPage:@"6" andiscontaintext:@"1"];
    
    PingjiaViewController * pingjia =[[PingjiaViewController alloc] init];
    pingjia.resid=_resid;
    [self.navigationController pushViewController:pingjia animated:YES];
    
}
-(void)gotoShopAlbum{
    ShopAlbumViewController* album=[[ShopAlbumViewController alloc] init];
    album.resid=_resid;
//    [self.navigationController pushViewController:album animated:YES];
    [self presentViewController:album animated:YES completion:nil];
}
//-(void)getPinglunBackCall:(id)dict
//{
//    NSLog(@"评论%@",dict);
//}

-(void)clickRightButton:(UIButton *)sender
{
    
    if (dictionary) {
        if (!isShouCang) {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"AddColctionBackCall:"];
            NSDictionary * prm=@{@"resid":_resid,@"userid":dictionary[@"userid"],@"type":@"1"};
            [dataprovider AddOrDelcollection:prm];
            isShouCang=YES;
            [self addRightButton:@"shoucang-@2x.png"];
        }
        else
        {
            DataProvider * dataprovider=[[DataProvider alloc] init];
            [dataprovider setDelegateObject:self setBackFunctionName:@"AddColctionBackCall:"];
            NSDictionary * prm=@{@"resid":_resid,@"userid":dictionary[@"userid"],@"type":@"0"};
            [dataprovider AddOrDelcollection:prm];
            isShouCang=NO;
            [self addRightButton:@"shoucang@2x.png"];
        }
        
    }else
    {
        UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:@"请先登录" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
        [alert show];
    }
    
}
-(void)AddColctionBackCall:(id)dict
{
    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"通知" message:dict[@"msg"] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    [alert show];
}
-(void)Btn_shareClick
{
    NSLog(@"分享餐厅");
    //分享巴国榜
    NSString *shareText = @"快来加入掌尚街，享受生活的乐趣吧！";             //分享内嵌文字
    UIImage *shareImage = [UIImage imageNamed:@"1136-1"];          //分享内嵌图片
    NSArray* snsList=    [NSArray arrayWithObjects:UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSms,nil];
    //调用快速分享接口
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:umeng_app_key
                                      shareText:shareText
                                     shareImage:shareImage
                                shareToSnsNames:snsList
                                       delegate:nil];
}

@end
