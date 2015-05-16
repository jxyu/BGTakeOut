//
//  WantRecommendViewController.m
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/15.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "WantRecommendViewController.h"
#import "AppDelegate.h"
#import "BGBTableViewCell.h"
@interface WantRecommendViewController ()

@end

@implementation WantRecommendViewController
#pragma  mark - vc-lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    
    
}
-(void)initView{
    _lblTitle.text=@"我要推荐";
    [self addLeftButton:@"ic_actionbar_back.png"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    _imgHeaderView.frame=CGRectMake(0, 0, SCREEN_WIDTH, 80);
    _tableView.tableHeaderView=_imgHeaderView;
    UIView* view=[[UIView alloc] init];
    view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [_tableView setTableFooterView:view];
}
-(void)viewWillAppear:(BOOL)animated
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hiddenTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *TableIdentifier = @"wantSectionsTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             TableIdentifier ];
    if (cell == nil) {
        
        if(indexPath.section==1||indexPath.section==2){
            BGBTableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:
                                    TableIdentifier ];
            NSArray* array=[[NSBundle mainBundle] loadNibNamed:@"BGBTableViewCell" owner:self options:nil];
            cell=                        (BGBTableViewCell*)[array objectAtIndex:0];
            cell.textField.delegate=self;
            if (indexPath.section==1&&indexPath.row==0) {
                cell.textField.placeholder=@"名称";
            } else if(indexPath.section==1&&indexPath.row==1){
                cell.textField.placeholder=@"地址";
            }else if(indexPath.section==1&&indexPath.row==2){
                cell.textField.placeholder=@"联系方式";
            }else if(indexPath.section==2&&indexPath.row==0){
                cell.textField.placeholder=@"推荐详情";
            }
            return cell;
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier: TableIdentifier ];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"请选择推荐内容所属分类";
            cell.textLabel.textColor=[UIColor lightGrayColor];
        }
    }
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0&&indexPath.section==2) {
        return 88.0;
    }
    return 44.0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int row;
    if (section==0) {
        row=1;
    }else if (section==1){
        row=3;
    }else{
        row=1;
    }
    return row;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section==0) {
        UILabel* lbl=[[UILabel alloc] init];
        lbl.frame=CGRectMake(118, 28, 100, 20);
        lbl.text=@"";
        lbl.textColor=[UIColor grayColor];
        lbl.backgroundColor=[UIColor groupTableViewBackgroundColor];
        lbl.font= [UIFont fontWithName:@"Arial-BoldItalicMT" size:14];
        return lbl;
    }
    UIView* u=[[UIView alloc] init];
    u.backgroundColor=[UIColor groupTableViewBackgroundColor];
    return u;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}
#pragma mark - tableview-delegate
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow]animated:YES];
}
#pragma mark -UITextField-delegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _tableView.frame=CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y-200, _tableView.frame.size.width, _tableView.frame.size.height);

    [UIView commitAnimations];

    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    _tableView.frame=CGRectMake(_tableView.frame.origin.x, _tableView.frame.origin.y+200, _tableView.frame.size.width, _tableView.frame.size.height);
    
    [UIView commitAnimations];

}
//-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
//    return YES;
//}
#pragma mark - 界面按钮点击方法
- (IBAction)imgUpload1:(id)sender {
}

- (IBAction)imgUpload2:(id)sender {
}

- (IBAction)imgUpload3:(id)sender {
}

- (IBAction)imgUpload4:(id)sender {
}

- (IBAction)commit:(id)sender {
}
@end
