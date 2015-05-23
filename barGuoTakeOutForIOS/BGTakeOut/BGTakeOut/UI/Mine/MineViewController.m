//
//  MineViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/4.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "DataProvider.h"
#import "CommenDef.h"
#import "AppDelegate.h"
#import "CreditNavigationController.h"
#import "CreditWebViewController.h"
#define KURL @"http://121.42.139.60/baguo/"

@interface MineViewController ()

@end

@implementation MineViewController
{
    NSArray * imageArray1;
    NSArray * imageArray2;
    NSArray * imageArray3;
    
    NSArray * nameArray1;
    NSArray * nameArray2;
    NSArray * nameArray3;
    
    UIView * BackGroundOfLogin;
    UIImageView * touxiang;
    id UserInfoData;
    NSDictionary * userinfoWithFile;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    imageArray1=[[NSArray alloc]initWithObjects:@"gw.png",@"gsjj.png",@"tscl.png",nil];
    imageArray2=[[NSArray alloc]initWithObjects:@"cp.png", @"zsjm.png",nil];
    imageArray3=[[NSArray alloc]initWithObjects:@"set.png",nil];
    
    nameArray1=[[NSArray alloc]initWithObjects:@"官网",@"公司简介",@"投诉处理",nil];
    nameArray2=[[NSArray alloc]initWithObjects:@"诚聘", @"招商加盟",nil];
    nameArray3=[[NSArray alloc]initWithObjects:@"设置",nil];
    
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    if (!userinfoWithFile[@"userid"]) {
        BackGroundOfLogin=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 80)];
        UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        backImageView.image=[UIImage imageNamed:@"MineBackImage.png"];
        [BackGroundOfLogin addSubview:backImageView];
        UIButton * login_btn=[[UIButton alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-100)/2, (70-30)/2, 100, 30)];
        [login_btn setBackgroundColor:[UIColor whiteColor]];
        [login_btn setTitle:@"登录／注册" forState:UIControlStateNormal];
        [login_btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [login_btn addTarget:self action:@selector(Login) forControlEvents:UIControlEventTouchUpInside];
        login_btn.layer.cornerRadius=12.5;
        [BackGroundOfLogin addSubview:login_btn];
        [self.view addSubview:BackGroundOfLogin];
        
    }
    else
    {
        UserInfoData=userinfoWithFile;
        UIView * UserBackGroundView=[[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_HEIGHT+20, SCREEN_WIDTH, 80)];
        UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        backImageView.image=[UIImage imageNamed:@"MineBackImage.png"];
        [UserBackGroundView addSubview:backImageView];
        touxiang =[[UIImageView alloc] initWithFrame:CGRectMake(10, (UserBackGroundView.frame.size.height-50)/2, 50, 50)];
        [touxiang setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,userinfoWithFile[@"avatar"]]]]]];
        touxiang.layer.masksToBounds=YES;
        touxiang.layer.cornerRadius=25;
        [UserBackGroundView addSubview:touxiang];
        
        UILabel * username=[[UILabel alloc] initWithFrame:CGRectMake(touxiang.frame.size.width+20, touxiang.frame.origin.y, 150, 25)];
        NSMutableString *String1 = [[NSMutableString alloc] initWithString:userinfoWithFile[@"username"]];
        if (String1.length>10) {
            [String1 replaceCharactersInRange:NSMakeRange(3,4) withString:@"****"];
            username.text=String1;
        }
        [username setTextColor:[UIColor whiteColor]];
        [UserBackGroundView addSubview:username];
        
        
        UILabel * tishi=[[UILabel alloc] initWithFrame:CGRectMake(touxiang.frame.size.width+20, touxiang.frame.origin.y+25, 180, 25)];
        tishi.text=@"完成购买才能获得巴国币哦";
        [tishi setTextColor:[UIColor whiteColor]];
        [UserBackGroundView addSubview:tishi];
        
        UIImageView * goImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-20, (UserBackGroundView.frame.size.height-25)/2, 20, 25)];
        goImage.image=[UIImage imageNamed:@"go.png"];
        [UserBackGroundView addSubview:goImage];
        
        
        UIButton * mybtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
        [mybtn addTarget:self action:@selector(myBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [UserBackGroundView addSubview:mybtn];
        [self.view addSubview:UserBackGroundView];
        [BackGroundOfLogin removeFromSuperview];
        [_myLogin.view removeFromSuperview];
}
    UIView * lastview =[[self.view subviews] lastObject];
    CGFloat y=lastview.frame.size.height+lastview.frame.origin.y;
    UIView * BackView_BGB=[[UIButton alloc] initWithFrame:CGRectMake(0,y , SCREEN_WIDTH/3, 80)];
    BackView_BGB.backgroundColor=[UIColor whiteColor];
    UIImageView * image_BGB=[[UIImageView alloc] initWithFrame:CGRectMake((BackView_BGB.frame.size.width-30)/2, 13, 30, 30)];
    image_BGB.image=[UIImage imageNamed:@"baguobi_icon"];
    [BackView_BGB addSubview:image_BGB];
    UILabel * lbl_BGB=[[UILabel alloc] initWithFrame:CGRectMake((BackView_BGB.frame.size.width-60)/2, 50, 60, 20)];
    lbl_BGB.font=[UIFont systemFontOfSize:14];
    lbl_BGB.textColor=[UIColor redColor];
    lbl_BGB.text=@"巴国币";
    [lbl_BGB setTextAlignment:NSTextAlignmentCenter];
    [BackView_BGB addSubview:lbl_BGB];
    UIButton * BGB =[[UIButton alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH/3, 80)];
    [BGB addTarget:self action:@selector(gotoCoinShop) forControlEvents:UIControlEventTouchUpInside];
    [BackView_BGB addSubview:BGB];
    [self.view addSubview:BackView_BGB];
    
    lastview =[[self.view subviews] lastObject];
    CGFloat x=lastview.frame.size.width;
    
    UIView * BackView_DD=[[UIButton alloc] initWithFrame:CGRectMake(x+1,y , SCREEN_WIDTH/3-1, 80)];
    BackView_DD.backgroundColor=[UIColor whiteColor];
    UIImageView * image_DD=[[UIImageView alloc] initWithFrame:CGRectMake((BackView_DD.frame.size.width-30)/2, 13, 30, 30)];
    image_DD.image=[UIImage imageNamed:@"order_icon"];
    [BackView_DD addSubview:image_DD];
    UILabel * lbl_DD=[[UILabel alloc] initWithFrame:CGRectMake((BackView_DD.frame.size.width-60)/2, 50, 60, 20)];
    lbl_DD.font=[UIFont systemFontOfSize:14];
    lbl_DD.textColor=[UIColor redColor];
    lbl_DD.text=@"订单";
    [lbl_DD setTextAlignment:NSTextAlignmentCenter];
    [BackView_DD addSubview:lbl_DD];
    UIButton *  DD_btn=[[UIButton alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH/3, 80)];
    [DD_btn addTarget:self action:@selector(ShowOrderListView) forControlEvents:UIControlEventTouchUpInside];
    [BackView_DD addSubview:DD_btn];
    [self.view addSubview:BackView_DD];
    
    
    lastview =[[self.view subviews] lastObject];
    x=lastview.frame.size.width+lastview.frame.origin.x;
    UIView * BackView_SC=[[UIButton alloc] initWithFrame:CGRectMake(x+1,y , SCREEN_WIDTH/3-1, 80)];
    BackView_SC.backgroundColor=[UIColor whiteColor];
    UIImageView * image_SC=[[UIImageView alloc] initWithFrame:CGRectMake((BackView_SC.frame.size.width-30)/2, 13, 30, 30)];
    image_SC.image=[UIImage imageNamed:@"shoucang_icon"];
    [BackView_SC addSubview:image_SC];
    UILabel * lbl_SC=[[UILabel alloc] initWithFrame:CGRectMake((BackView_SC.frame.size.width-60)/2, 50, 60, 20)];
    lbl_SC.font=[UIFont systemFontOfSize:14];
    lbl_SC.textColor=[UIColor redColor];
    lbl_SC.text=@"收藏";
    [lbl_SC setTextAlignment:NSTextAlignmentCenter];
    [BackView_SC addSubview:lbl_SC];
    UIButton *  SC_btn=[[UIButton alloc] initWithFrame:CGRectMake(0,0 , SCREEN_WIDTH/3, 80)];
    [SC_btn addTarget:self action:@selector(ShowCollectionVC) forControlEvents:UIControlEventTouchUpInside];
    [BackView_SC addSubview:SC_btn];
    [self.view addSubview:BackView_SC];
    
    
    
    
    
    lastview =[[self.view subviews] lastObject];
    y=lastview.frame.origin.y+lastview.frame.size.height;

    UITableView * MineTableView=[[UITableView alloc] initWithFrame:CGRectMake(0, y, SCREEN_WIDTH, SCREEN_HEIGHT-49-y) style:UITableViewStyleGrouped];
    MineTableView.delegate=self;
    MineTableView.dataSource=self;
    [self.view addSubview:MineTableView];
    
    [SVProgressHUD dismiss];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (0==section) {
        return 3;
    }else if (1==section)
    {
        return 2;
    }else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier=@"MineTableViewCell";
    MineTableViewCell * cell=(MineTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell  = [[[NSBundle mainBundle] loadNibNamed:@"MineTableViewCell" owner:self options:nil] lastObject];
        switch (indexPath.section) {
            case 0:
                cell.MineImg.image=[UIImage imageNamed:imageArray1[indexPath.row]];
                cell.cellBtn.tag=[[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
                [cell.cellBtn addTarget:self action:@selector(cellBtnBackCall:) forControlEvents:UIControlEventTouchUpInside];
                cell.MineName.text=nameArray1[indexPath.row];
                break;
            case 1:
                cell.MineImg.image=[UIImage imageNamed:imageArray2[indexPath.row]];
                cell.cellBtn.tag=[[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
                [cell.cellBtn addTarget:self action:@selector(cellBtnBackCall:) forControlEvents:UIControlEventTouchUpInside];
                cell.MineName.text=nameArray2[indexPath.row];
                break;
            case 2:
                cell.MineImg.image=[UIImage imageNamed:imageArray3[indexPath.row]];
                cell.cellBtn.tag=[[NSString stringWithFormat:@"%ld%ld",(long)indexPath.section,(long)indexPath.row] integerValue];
                [cell.cellBtn addTarget:self action:@selector(cellBtnBackCall:) forControlEvents:UIControlEventTouchUpInside];
                cell.MineName.text=nameArray3[indexPath.row];
                break;
            default:
                break;
        }
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
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

-(void)Login
{
    _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
    [_myLogin setDelegateObject:self setBackFunctionName:@"CallBackFuc:"];
    [self.navigationController pushViewController:_myLogin animated:YES];
}
-(void)cellBtnBackCall:(UIButton *)sender
{
    NSLog(@"%ld",(long)sender.tag);
    _myOther=[[OtherOfMineViewController alloc] initWithNibName:@"OtherOfMineViewController" bundle:[NSBundle mainBundle]];
    _myOther.UserInfoData=UserInfoData;
    switch (sender.tag) {
        case 0:
            
            break;
        case 1:
            _myOther.Othertitle=@"公司简介";
            break;
        case 2:
            if (UserInfoData) {
                _myOther.Othertitle=@"投诉处理";
            }else
            {
                _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
                [_myLogin setDelegateObject:self setBackFunctionName:@"LoginBackCall:"];
                [self.navigationController pushViewController:_myLogin animated:YES];
            }
            break;
        case 10:
            _myOther.Othertitle=@"诚聘";
            break;
        case 11:
            _myOther.Othertitle=@"招商加盟";
            break;
        case 20:
            _myOther.Othertitle=@"设置";
            
            break;
        default:
            break;
    }
    _myOther.celltag=sender.tag;
    [self.navigationController pushViewController:_myOther animated:YES];
    
}

-(void)CallBackFuc:(id)dict
{
    NSLog(@"回调成功啊啊啊%@",dict);
    UserInfoData=dict[@"data"];
    UIView * UserBackGroundView=[[UIView alloc] init];
    UserBackGroundView.frame=BackGroundOfLogin.frame;
    UIImageView * backImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    backImageView.image=[UIImage imageNamed:@"MineBackImage.png"];
    [UserBackGroundView addSubview:backImageView];
    touxiang =[[UIImageView alloc] initWithFrame:CGRectMake(10, (UserBackGroundView.frame.size.height-50)/2, 50, 50)];
    [touxiang setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"avatar"]]]]]];
    touxiang.layer.masksToBounds=YES;
    touxiang.layer.cornerRadius=25;
    [UserBackGroundView addSubview:touxiang];
    
    UILabel * username=[[UILabel alloc] initWithFrame:CGRectMake(touxiang.frame.size.width+20, touxiang.frame.origin.y, 150, 25)];
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:dict[@"data"][@"username"]];
    if (String1.length>10) {
        [String1 replaceCharactersInRange:NSMakeRange(3,4) withString:@"****"];
        username.text=String1;
    }
    [username setTextColor:[UIColor whiteColor]];
    [UserBackGroundView addSubview:username];
    
    
    UILabel * tishi=[[UILabel alloc] initWithFrame:CGRectMake(touxiang.frame.size.width+20, touxiang.frame.origin.y+25, 180, 25)];
    tishi.text=@"完成购买才能获得巴国币哦";
    [tishi setTextColor:[UIColor whiteColor]];
    [UserBackGroundView addSubview:tishi];
    
    UIImageView * goImage=[[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-10-20, (UserBackGroundView.frame.size.height-25)/2, 20, 25)];
    goImage.image=[UIImage imageNamed:@"go.png"];
    [UserBackGroundView addSubview:goImage];
    
    
    UIButton * mybtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 80)];
    [mybtn addTarget:self action:@selector(myBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [UserBackGroundView addSubview:mybtn];
    [self.view addSubview:UserBackGroundView];
    [BackGroundOfLogin removeFromSuperview];
}
-(void)myBtnClick
{
    NSLog(@"账户信息,%@",self.navigationController);
    _myUserInfo=[[UserInfoViewController alloc] initWithNibName:@"UserInfoViewController" bundle:[NSBundle mainBundle]];
    _myUserInfo.UserInfoData=UserInfoData;
    [_myUserInfo setDelegateObject:self setBackFunctionName:@"UserInfoViewBackCall"];
    [self.navigationController pushViewController:_myUserInfo animated:YES];
}

-(void)UserInfoViewBackCall
{
    DataProvider *dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"GetUserInfo:"];
    [dataprovider GetUserInfoWithUserID:UserInfoData[@"userid"]];
}
-(void)GetUserInfo:(id)dict
{
    if (dict) {
         UserInfoData=dict[@"data"];
    }
    [touxiang setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"avatar"]]]]]];
    NSLog(@"%@getuserinfo",dict);
}
-(void)ShowOrderListView
{
    if (userinfoWithFile[@"userid"]||UserInfoData[@"userid"]) {
        self.myOrderList=[[OrderListViewController alloc] init];
        _myOrderList.userid=userinfoWithFile[@"userid"]?userinfoWithFile[@"userid"]:UserInfoData[@"userid"] ;
        [self.navigationController pushViewController:_myOrderList animated:YES];
    }
    else
    {
        _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        [_myLogin setDelegateObject:self setBackFunctionName:@"CallBackFuc:"];
        [self.navigationController pushViewController:_myLogin animated:YES];
    }
    
}
-(void)ShowCollectionVC
{
    
    if (userinfoWithFile[@"userid"]||UserInfoData[@"userid"]) {
        self.myCollection=[[ClictionViewController alloc] init];
        _myCollection.userid=userinfoWithFile[@"userid"]?userinfoWithFile[@"userid"]:UserInfoData[@"userid"];
        [self.navigationController pushViewController:_myCollection animated:YES];
    }
    else
    {
        _myLogin=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:[NSBundle mainBundle]];
        [_myLogin setDelegateObject:self setBackFunctionName:@"CallBackFuc:"];
        [self.navigationController pushViewController:_myLogin animated:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showTabBar];
}
#pragma mark - 兑吧链接
-(void)gotoCoinShop{
    



    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary* userInfo =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    if(userInfo){
        //!!!:  已经登录完成，调用接口获取免登陆链接在页面中显示
        DataProvider* dataProvider=[[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"getDuibaAutoLoginUrl:"];
        [        dataProvider getduibaurlWithAppkey:duiba_app_key appsecret:duiba_app_secret userid:userInfo[@"userid"]];
    }else{
        //!!!:  还没有登录，跳转登录页面，登录成功后返回这一页面
        LoginViewController* loginVC=        [[LoginViewController alloc] init];
        [self.navigationController pushViewController:loginVC animated:YES];
        
    }
    
}
-(void)getDuibaAutoLoginUrl:(id)dict{
    NSLog(@"%@",dict);
    NSDictionary* d=    (    NSDictionary*)dict;
    NSString* url=    d[@"data"][@"url"];
    CreditWebViewController *web=[[CreditWebViewController alloc]initWithUrlByPresent:url];
    CreditNavigationController *nav=[[CreditNavigationController alloc]initWithRootViewController:web];
    [nav setNavColorStyle:[UIColor redColor]];
    [self presentViewController:nav animated:YES completion:nil];
    
}
@end
