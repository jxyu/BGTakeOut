//
//  WantRecommendViewController.h
//  BGTakeOut
//
//  Created by 粒橙Leo on 15/5/15.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "BaseNavigationController.h"
#import "VPImageCropperViewController.h"
@interface WantRecommendViewController : BaseNavigationController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,VPImageCropperDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *imgUploadBtn1;

@property (weak, nonatomic) IBOutlet UIButton *imgUploadBtn2;
@property (weak, nonatomic) IBOutlet UIButton *imgUploadBtn3;
@property (weak, nonatomic) IBOutlet UIButton *imgUploadBtn4;

@property (strong, nonatomic) IBOutlet UIView *imgHeaderView;


@property(nonatomic,strong)NSString* oneid;
@property(nonatomic,strong)NSString*    onetitle;
@property(nonatomic,strong)NSString* twoid;
@property(nonatomic,strong)NSString*    twotitle;
@property(nonatomic,strong)NSString* threeid;
@property(nonatomic,strong)NSString*    threetitle;

- (IBAction)imgUpload1:(id)sender;
- (IBAction)imgUpload2:(id)sender;

- (IBAction)imgUpload3:(id)sender;
- (IBAction)imgUpload4:(id)sender;



- (IBAction)commit:(id)sender;

@end
