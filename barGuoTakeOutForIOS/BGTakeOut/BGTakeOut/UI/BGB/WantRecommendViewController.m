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
#import "RankCategoryViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImageView+WebCache.h"
#import "VPImageCropperViewController.h"
#import "DataProvider.h"

#import <AssetsLibrary/AssetsLibrary.h>
#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define ORIGINAL_MAX_WIDTH 640.0f
#define KURL @"http://121.42.139.60/baguo/"
typedef enum{
    uploadImg1,
    uploadImg2,
    uploadImg3,
    uploadImg4
} uploadNO;
@interface WantRecommendViewController (){
    UILabel* text;
    uploadNO selectedNum;
    
    NSString* imgUploadUrl1;
    NSString* imgUploadUrl2;
    NSString* imgUploadUrl3;
    NSString* imgUploadUrl4;
    
    UITextField* nametf;
    UITextField* contacttf;
    UITextField* adrtf;
    UITextField* detailtf;
}

@end

@implementation WantRecommendViewController
#pragma  mark - vc-lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    _threeid=@"";
    imgUploadUrl4=@"";
    imgUploadUrl3=@"";
    imgUploadUrl2=@"";
    imgUploadUrl1=@"";
    
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
    if (![_threeid isEqualToString:@""]) {

        text.text=[NSString stringWithFormat:@"%@ - %@ - %@",_onetitle,_twotitle,_threetitle];
        text.textColor=[UIColor blackColor];
    }
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
                cell.textField.placeholder=@"店铺名称（必填）";
                nametf=cell.textField;
            } else if(indexPath.section==1&&indexPath.row==1){
                cell.textField.placeholder=@"店铺地址（必填）";
                adrtf=cell.textField;
            }else if(indexPath.section==1&&indexPath.row==2){
                cell.textField.placeholder=@"联系方式（必填）";
                contacttf=cell.textField;
            }else if(indexPath.section==2&&indexPath.row==0){
                cell.textField.placeholder=@"推荐详情（必填）";
                detailtf=cell.textField;
            }
            return cell;
        }else{
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                          reuseIdentifier: TableIdentifier ];
            cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text=@"请选择推荐内容所属分类";
            text=cell.textLabel;
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
    if (indexPath.section==0) {
        RankCategoryViewController* rank=[[RankCategoryViewController alloc] init];
        rank.rank=@0;
        [self.navigationController pushViewController:rank animated:YES];
    }
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
    [self editPortrait];
    selectedNum=uploadImg1;
}

- (IBAction)imgUpload2:(id)sender {
        [self editPortrait];
        selectedNum=uploadImg2;
}

- (IBAction)imgUpload3:(id)sender {
    [self editPortrait];
        selectedNum=uploadImg3;
}

- (IBAction)imgUpload4:(id)sender {
        [self editPortrait];
        selectedNum=uploadImg4;
}

- (IBAction)commit:(id)sender {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"UserInfo.plist"];
    NSDictionary* userinfoWithFile =[[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    if(![nametf.text isEqualToString:@""]&&![adrtf.text isEqualToString:@""]&&![contacttf.text isEqualToString:@""]&&![detailtf.text isEqualToString:@""]&&![_threeid isEqualToString:@""]){
        DataProvider*   dataProvider=[[DataProvider alloc] init];
        [dataProvider setDelegateObject:self setBackFunctionName:@"commitSuccess:"];
        [dataProvider commitRecommendWithusername:userinfoWithFile[@"username"] resname:nametf.text resaddress:adrtf.text contacts:contacttf.text resdetail:detailtf.text img1:imgUploadUrl1 img2:imgUploadUrl2 img3:imgUploadUrl3 img4:imgUploadUrl4 oneid:_oneid twoid:_twoid threeid:_threeid];
    }else if([_threeid isEqualToString:@""]){
        [SVProgressHUD showErrorWithStatus:@"亲，请选择推荐的分类信息！" maskType:SVProgressHUDMaskTypeBlack];
    }else{
        [SVProgressHUD showErrorWithStatus:@"亲，请将相关的必填项填写完整，O(∩_∩)O谢谢！" maskType:SVProgressHUDMaskTypeBlack];
    }
    
}
-(void)commitSuccess:(NSDictionary*)dict{
  
    DLog(@"commit-status:%@",dict);
    if([[dict objectForKey:@"status"] isEqualToString:@"1"]){
        [SVProgressHUD showSuccessWithStatus:@"提交成功！" maskType:SVProgressHUDMaskTypeBlack];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark - 选择照片
- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}


#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.imgUploadBtn1.imageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage withName:@"avatar.png"];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
        NSLog(@"选择完成");
        [SVProgressHUD showWithStatus:@"加载中.." maskType:SVProgressHUDMaskTypeBlack];
        //        NSData* imageData = UIImagePNGRepresentation(editedImage);
        DataProvider * dataprovider=[[DataProvider alloc] init];
        [dataprovider setDelegateObject:self setBackFunctionName:@"UploadBackCall:"];
        [dataprovider UpLoadImage:fullPath];
        
        
    }];
}

#pragma mark - 保存图片至沙盒
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // 裁剪
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self presentViewController:imgEditorVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}
#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}
- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}
-(void)UploadBackCall:(id)dict
{
    NSLog(@"upload-back-call:%@",dict);
//    [_imgUploadBtn1.imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]]
////     ];
//[    _imgUploadBtn1.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]] placeholderImage:[UIImage imageNamed:@"placeholder"]];

  
        [SVProgressHUD dismiss];
    switch (selectedNum) {
        case uploadImg1:
            imgUploadUrl1=dict[@"data"][@"url"];
            [_imgUploadBtn1 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]] forState:UIControlStateNormal];

            break;
         case  uploadImg2:
            imgUploadUrl2=dict[@"data"][@"url"];
            [_imgUploadBtn2 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]] forState:UIControlStateNormal];

            break;
        case uploadImg3:
            imgUploadUrl3=dict[@"data"][@"url"];
            [_imgUploadBtn3 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]] forState:UIControlStateNormal];

            break;
        case uploadImg4:
            imgUploadUrl4=dict[@"data"][@"url"];
            [_imgUploadBtn4 setBackgroundImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]] forState:UIControlStateNormal];

            break;
        default:
            break;
    }
}




@end
