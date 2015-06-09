//
//  SetInfoViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/6/8.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "SetInfoViewController.h"
#import "CommenDef.h"

@interface SetInfoViewController ()

@end

@implementation SetInfoViewController
{
    UITextView * txt_advice;
    UILabel *lbl_placeholder;
    UILabel * lbl_zishu;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addLeftButton:@"ic_actionbar_back.png"];
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/25.0 alpha:1.0];
    [self InitAllView];
}

-(void)InitAllView
{
    switch (_setid) {
//        case 0:
//            <#statements#>
//            break;
//        case 1:
            //            <#statements#>
            //            break;
        case 2:
            _lblTitle.text=@"意见反馈";
            [self BuildTextFiled];
            break;
            //        case 3:
//            <#statements#>
//            break;
//        default:
//            break;
    }
}

-(void)BuildTextFiled
{
    txt_advice=[[UITextView alloc] initWithFrame:CGRectMake(10 , 74, SCREEN_WIDTH-20, 80)];
    [txt_advice setKeyboardType:UIKeyboardTypeDefault];
    txt_advice.delegate=self;
    
    
    lbl_placeholder=[[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 15)];
    lbl_placeholder.text = @"我要提意见～";
    lbl_placeholder.font=[UIFont systemFontOfSize:14];
    lbl_placeholder.enabled = NO;//lable必须设置为不可用
    lbl_placeholder.backgroundColor = [UIColor clearColor];
    [txt_advice addSubview:lbl_placeholder];
    lbl_zishu=[[UILabel alloc] initWithFrame:CGRectMake(txt_advice.frame.size.width -160, txt_advice.frame.size.height-20, 150, 15)];
    lbl_zishu.text=@"还能输入140个字";
    lbl_zishu.font=[UIFont systemFontOfSize:13];
    lbl_zishu.enabled=NO;
    lbl_zishu.backgroundColor=[UIColor clearColor];
    [txt_advice addSubview:lbl_zishu];
    
    [self.view addSubview:txt_advice];
    
    UIButton * btn_submit=[[UIButton alloc] initWithFrame:CGRectMake(20, txt_advice.frame.origin.y+txt_advice.frame.size.height, SCREEN_WIDTH-40, 40)];
    [btn_submit setBackgroundColor:[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0]];
    [btn_submit setTitle:@"提交" forState:UIControlStateNormal];
    [btn_submit addTarget:self action:@selector(submityijian) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_submit];
}

-(void)submityijian
{
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    NSUInteger textlength=txt_advice.text.length ;
    if (textlength== 0) {
        lbl_placeholder.text = @"给餐厅留言..";
    }else{
        lbl_placeholder.text = @"";
        lbl_zishu.text=[NSString stringWithFormat:@"还能输入%lu个字",140-textlength];
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
