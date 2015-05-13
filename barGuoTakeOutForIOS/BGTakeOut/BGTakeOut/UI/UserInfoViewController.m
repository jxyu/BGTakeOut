//
//  UserInfoViewController.m
//  BGTakeOut
//
//  Created by 于金祥 on 15/5/5.
//  Copyright (c) 2015年 jxyu. All rights reserved.
//

#import "UserInfoViewController.h"
#import "UIImageView+WebCache.h"
#import "VPImageCropperViewController.h"
#import "DataProvider.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>

#define KWidth self.view.frame.size.width
#define KHeight self.view.frame.size.height
#define ORIGINAL_MAX_WIDTH 640.0f
#define KURL @"http://121.42.139.60/baguo/"

@interface UserInfoViewController () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate>
@property(nonatomic,strong)UINavigationItem *mynavigationItem;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property(nonatomic,strong)UIView * page;
@end

@implementation UserInfoViewController
{
    UIImageView * img_touxiang;
    UITextField *txt_pwd;
    UITextField * txt_phoneNum;
    UIView * touxiangView;
    UINavigationBar *navigationBar;
}


#pragma mark 赋值回调
- (void)setDelegateObject:(id)cbobject setBackFunctionName:(NSString *)selectorName
{
    CallBackObject = cbobject;
    callBackFunctionName = selectorName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 64)];
    navigationBar.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    navigationBar.translucent=YES;
    _mynavigationItem = [[UINavigationItem alloc] initWithTitle:@"我的账户"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Image-2"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(BackBtnClick)];
    [navigationBar pushNavigationItem:_mynavigationItem animated:NO];
    [_mynavigationItem setLeftBarButtonItem:leftButton];
    [self.view addSubview:navigationBar];
    if (_UserInfoData) {
        [self BuildView];
    }
    
    
}
-(void)BuildView
{
    UIView * BackOfUserPhonenum =[[UIView alloc] initWithFrame:CGRectMake(0, navigationBar.frame.size.height+2, KWidth, 40)];
    BackOfUserPhonenum.backgroundColor=[UIColor whiteColor];
    UILabel * Phonenum=[[UILabel alloc] initWithFrame:CGRectMake(10, (BackOfUserPhonenum.frame.size.height-20)/2, KWidth-100, 20)];
    NSMutableString *String1 = [[NSMutableString alloc] initWithString:_UserInfoData[@"username"]];
    if (String1.length>10) {
        [String1 replaceCharactersInRange:NSMakeRange(3,4) withString:@"****"];
        Phonenum.text=String1;
    }
    [BackOfUserPhonenum addSubview:Phonenum];
    [self.view addSubview:BackOfUserPhonenum];
    
    
    touxiangView =[[UIView alloc] initWithFrame:CGRectMake(0, BackOfUserPhonenum.frame.origin.y+BackOfUserPhonenum.frame.size.height+1, KWidth, 60)];
    touxiangView.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_touxiang=[[UILabel alloc] initWithFrame:CGRectMake(10, (touxiangView.frame.size.height-20)/2, KWidth-200, 20)];
    lbl_touxiang.text=@"头像";
    [touxiangView addSubview:lbl_touxiang];
    UIImageView * goImage=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-10-20, (touxiangView.frame.size.height-15)/2, 10, 15)];
    
    goImage.image=[UIImage imageNamed:@"go.png"];
    [touxiangView addSubview:goImage];
    img_touxiang=[[UIImageView alloc] initWithFrame:CGRectMake(goImage.frame.origin.x-50, (touxiangView.frame.size.height-50)/2, 50, 50)];
    [img_touxiang setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,_UserInfoData[@"avatar"]]]]]];
    img_touxiang.layer.masksToBounds=YES;
    img_touxiang.layer.cornerRadius=25;
    [touxiangView addSubview:img_touxiang];
    [self.view addSubview:touxiangView];
    UIButton * btn_touxiang=[[UIButton alloc] init];
    btn_touxiang.frame=touxiangView.frame;
    [btn_touxiang addTarget:self action:@selector(Btn_touxiangClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_touxiang];
    
    UIView * V_Name=[[UIView alloc] initWithFrame:CGRectMake(0, touxiangView.frame.origin.y+touxiangView.frame.size.height+1, KWidth, 40)];
    V_Name.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_name=[[UILabel alloc] initWithFrame:CGRectMake(10, (V_Name.frame.size.height-20)/2, KWidth-200, 20)];
    lbl_name.text=@"昵称";
    [V_Name addSubview:lbl_name];
    UIImageView * goImage1=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-10-20, (V_Name.frame.size.height-15)/2, 10, 15)];
    goImage1.image=[UIImage imageNamed:@"go.png"];
    [V_Name addSubview:goImage1];
    [self.view addSubview:V_Name];
    UIButton * btn_changenickname=[[UIButton alloc] init];
    btn_changenickname.frame=V_Name.frame;
    [btn_changenickname addTarget:self action:@selector(changeNickName) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_changenickname];
    
    UIView * V_pwd=[[UIView alloc] initWithFrame:CGRectMake(0, V_Name.frame.origin.y+V_Name.frame.size.height+1, KWidth, 40)];
    V_pwd.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_pwd=[[UILabel alloc] initWithFrame:CGRectMake(10, (V_pwd.frame.size.height-20)/2, KWidth-200, 20)];
    lbl_pwd.text=@"修改密码";
    [V_pwd addSubview:lbl_pwd];
    UIImageView * goImage2=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-10-20, (V_pwd.frame.size.height-15)/2, 10, 15)];
    goImage2.image=[UIImage imageNamed:@"go.png"];
    [V_pwd addSubview:goImage2];
    [self.view addSubview:V_pwd];
    UIButton * btn_pwd=[[UIButton alloc] init];
    [btn_pwd addTarget:self action:@selector(resetPwd) forControlEvents:UIControlEventTouchUpInside];
    btn_pwd.frame=V_pwd.frame;
    [self.view addSubview:btn_pwd];
    
    UIView * V_address=[[UIView alloc] initWithFrame:CGRectMake(0, V_pwd.frame.origin.y+V_pwd.frame.size.height+1, KWidth, 40)];
    V_address.backgroundColor=[UIColor whiteColor];
    UILabel * lbl_address=[[UILabel alloc] initWithFrame:CGRectMake(10, (V_address.frame.size.height-20)/2, KWidth-200, 20)];
    lbl_address.text=@"我的收货地址";
    [V_address addSubview:lbl_address];
    UIImageView * goImage3=[[UIImageView alloc] initWithFrame:CGRectMake(KWidth-10-20, (V_address.frame.size.height-15)/2, 10, 15)];
    goImage3.image=[UIImage imageNamed:@"go.png"];
    [V_address addSubview:goImage3];
    [self.view addSubview:V_address];
    UIButton * btn_AddressManager=[[UIButton alloc] initWithFrame:V_address.frame];
    [btn_AddressManager addTarget:self action:@selector(Btn_AddressManagerClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn_AddressManager];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)BackBtnClick
{
    SEL func_selector = NSSelectorFromString(callBackFunctionName);
    if ([CallBackObject respondsToSelector:func_selector]) {
        NSLog(@"回调成功...");
        [CallBackObject performSelector:func_selector];
    }else{
        NSLog(@"回调失败...");
    }
    [self.view removeFromSuperview];
}

-(void)Btn_touxiangClick
{
    NSLog(@"上传图片");
    [self editPortrait];
}

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
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
        [self saveImage:editedImage withName:@"avatar.png"];
        
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
        NSLog(@"选择完成");
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
    NSLog(@"%@",dict);
    [img_touxiang setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",KURL,dict[@"data"][@"url"]]]]]
     ];
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"ChangeAvatarBackCall:"];
    [dataprovider ChangeAvatar:dict[@"data"][@"url"] anduserid:_UserInfoData[@"userid"]];
}
-(void)ChangeAvatarBackCall:(id)dict
{
    NSLog(@"%@",dict);
}





-(void)resetPwd
{
    _page=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    _page.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:_page];
    UINavigationBar * navigationBarsub = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 64)];
    navigationBarsub.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    navigationBarsub.translucent=YES;
    UINavigationItem *mynavigationItemsub = [[UINavigationItem alloc] initWithTitle:@"修改密码"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Image-2"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(sub_navigationLeftClick)];
    [navigationBarsub pushNavigationItem:mynavigationItemsub animated:NO];
    [mynavigationItemsub setLeftBarButtonItem:leftButton];
    [_page addSubview:navigationBarsub];
    
    UIView * BackgroundView1=[[UIView alloc] initWithFrame:CGRectMake(0, navigationBarsub.frame.size.height, KWidth, 40)];
    BackgroundView1.backgroundColor=[UIColor whiteColor];
    UILabel * PhoneNum =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    PhoneNum.text=@"旧密码：";
    [BackgroundView1 addSubview:PhoneNum];
    UIView * lastView=[[BackgroundView1 subviews] lastObject];
    CGFloat x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_phoneNum setKeyboardType:UIKeyboardTypeNumberPad];
    [txt_phoneNum setPlaceholder:@"请输入旧密码"];
    [BackgroundView1 addSubview:txt_phoneNum];
    [_page addSubview:BackgroundView1];
    
    lastView=BackgroundView1;
    UIView * BackgroundView2=[[UIView alloc] initWithFrame:CGRectMake(0, lastView.frame.size.height+lastView.frame.origin.y+1, KWidth, 40)];
    BackgroundView2.backgroundColor=[UIColor whiteColor];
    UILabel * Pwd =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    Pwd.text=@"新密码：";
    [BackgroundView2 addSubview:Pwd];
    lastView=[[BackgroundView2 subviews] lastObject];
    x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_pwd=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_pwd setPlaceholder:@"输入新密码"];
    [txt_pwd setKeyboardType:UIKeyboardTypeAlphabet];
    [BackgroundView2 addSubview:txt_pwd];
    [_page addSubview:BackgroundView2];
    
    UIButton * btn_login=[[UIButton alloc] initWithFrame:CGRectMake(30, BackgroundView2.frame.origin.y+BackgroundView2.frame.size.height+10, 260, 40)];
    [btn_login setBackgroundColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0]];
    [btn_login setTitle:@"确定" forState:UIControlStateNormal];
    [btn_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_login addTarget:self action:@selector(resetPwdClick) forControlEvents:UIControlEventTouchUpInside];
    [_page addSubview:btn_login];
    
}
-(void)resetPwdClick
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"ResetPwdCallBack:"];
    [dataprovider ResetPwd:txt_phoneNum.text andNewpwd:txt_pwd.text anduserid:_UserInfoData[@"userid"]];
}
-(void)ResetPwdCallBack:(id)dict
{
    NSLog(@"dict%@",dict);
    if ([dict[@"status"] integerValue]==1) {
        [_page removeFromSuperview];
    }
    
    UIAlertView* alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"通知", nil)
                                                  message:NSLocalizedString(dict[@"msg"], nil)
                                                 delegate:self
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles:nil, nil];
    [alert show];
}

-(void)changeNickName
{
    _page=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    _page.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:_page];
    UINavigationBar * navigationBarsub = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 64)];
    navigationBarsub.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    navigationBarsub.translucent=YES;
    UINavigationItem *mynavigationItemsub = [[UINavigationItem alloc] initWithTitle:@"修改昵称"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Image-2"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(sub_navigationLeftClick)];
    [navigationBarsub pushNavigationItem:mynavigationItemsub animated:NO];
    [mynavigationItemsub setLeftBarButtonItem:leftButton];
    [_page addSubview:navigationBarsub];
    UIView * BackgroundView1=[[UIView alloc] initWithFrame:CGRectMake(0, navigationBarsub.frame.size.height, KWidth, 40)];
    BackgroundView1.backgroundColor=[UIColor whiteColor];
    UILabel * PhoneNum =[[UILabel alloc ] initWithFrame:CGRectMake(10, 5, 80, 30)];
    PhoneNum.text=@"昵称：";
    [BackgroundView1 addSubview:PhoneNum];
    UIView * lastView=[[BackgroundView1 subviews] lastObject];
    CGFloat x=lastView.frame.origin.x+lastView.frame.size.width;
    txt_phoneNum=[[UITextField alloc] initWithFrame:CGRectMake(x, 0, 200, 40)];
    [txt_phoneNum setKeyboardType:UIKeyboardTypeDefault];
    [txt_phoneNum setPlaceholder:_UserInfoData[@"nickname"]];
    [BackgroundView1 addSubview:txt_phoneNum];
    [_page addSubview:BackgroundView1];
    
    
    UIButton * btn_login=[[UIButton alloc] initWithFrame:CGRectMake(30, BackgroundView1.frame.origin.y+BackgroundView1.frame.size.height+10, 260, 40)];
    [btn_login setBackgroundColor:[UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0]];
    [btn_login setTitle:@"确定" forState:UIControlStateNormal];
    [btn_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn_login addTarget:self action:@selector(changeNickNameCallBack) forControlEvents:UIControlEventTouchUpInside];
    [_page addSubview:btn_login];
}
-(void)changeNickNameCallBack
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"ResetPwdCallBack:"];
    [dataprovider ChangeNickName:txt_phoneNum.text anduserid:_UserInfoData[@"userid"]];
}

-(void)Btn_AddressManagerClick
{
    DataProvider * dataprovider=[[DataProvider alloc] init];
    [dataprovider setDelegateObject:self setBackFunctionName:@"Btn_AddressManagerBackCall:"];
    [dataprovider GetUserAddressListWithPage:@"1" andnum:@"8" anduserid:_UserInfoData[@"userid"] andisgetdefault:@""];
    
    
    
}

-(void)sub_navigationLeftClick
{
    [_page removeFromSuperview ];
}

-(void)Btn_AddressManagerBackCall:(id)dict
{
    NSLog(@"获取收货地址：%@",dict);
    _page=[[UIView alloc] initWithFrame:CGRectMake(0, 0, KWidth, KHeight)];
    _page.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    [self.view addSubview:_page];
    UINavigationBar * navigationBarsub = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, 64)];
    navigationBarsub.backgroundColor=[UIColor colorWithRed:229/255.0 green:59/255.0 blue:33/255.0 alpha:1.0];
    navigationBarsub.translucent=YES;
    UINavigationItem *mynavigationItemsub = [[UINavigationItem alloc] initWithTitle:@"收货地址"];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Image-2"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(sub_navigationLeftClick)];
    [navigationBarsub pushNavigationItem:mynavigationItemsub animated:NO];
    [mynavigationItemsub setLeftBarButtonItem:leftButton];
    [_page addSubview:navigationBarsub];
//    UIScrollView *scrollView_address=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, KWidth, KHeight-64)];
//    scrollView_address.scrollEnabled=YES;
//    
//    if (1==[dict[@"status"] intValue]) {
//        NSArray * addressArray=[[NSArray alloc] initWithArray:dict[@"data"]];
//        for (int i=0; i<addressArray.count; i++) {
//            UIView * lastView=[self.view.subviews lastObject];
//            UIView * view_address=[[UIView alloc] initWithFrame:CGRectMake(0, i==0?64:lastView.frame.origin.y+lastView.frame.size.height+5, KWidth, 100)];
//            view_address.backgroundColor=[UIColor colorWithRed:85/255.0 green:88/255.0 blue:95/25.0 alpha:1.0];
//            UILabel * lbl_name=[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
//            lbl_name.text=addressArray[i][@"realname"];
//            lbl_name.textColor=[UIColor whiteColor];
//            [view_address addSubview:lbl_name];
//            UILabel * lbl_phoneNum=[[UILabel alloc] initWithFrame:CGRectMake(KWidth-200, 10, 150, 20)];
//            lbl_phoneNum.text=addressArray[i][@"phonenum"];
//            lbl_phoneNum.textColor=[UIColor whiteColor];
//            [view_address addSubview:lbl_phoneNum];
//            UILabel * lbl_address=[[UILabel alloc]initWithFrame:CGRectMake(10, lbl_name.frame.origin.y+lbl_name.frame.size.height+5,KWidth-50 , 50)];
//            [lbl_address setLineBreakMode:NSLineBreakByWordWrapping];
//            lbl_address.numberOfLines=0;
//            lbl_address.text=addressArray[i][@"addressdetail"];
//            lbl_address.textColor=[UIColor whiteColor];
//            [view_address addSubview:lbl_address];
//            
//            UIButton * Btn_zhezhao=[[UIButton alloc] initWithFrame:view_address.frame];
//            Btn_zhezhao.tag=addressArray[i][@"addid"];
//            [Btn_zhezhao addTarget:self action:@selector(CellClickFuc:) forControlEvents:UIControlEventTouchUpInside];
//            [scrollView_address addSubview:view_address];
//            [scrollView_address addSubview:Btn_zhezhao];
//        }
//        
//        
//    }
//    [scrollView_address setContentSize:CGSizeMake(0, 600)];
//    [self.view addSubview:scrollView_address];
   
    
    UIView * BackView_addAddres=[[UIView alloc] initWithFrame:CGRectMake(0, KHeight-150, KWidth, 40)];
    BackView_addAddres.backgroundColor=[UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
    UIButton * btn_addAddress=[[UIButton alloc] initWithFrame:CGRectMake((KWidth-100)/2, 10, 100, 20)];
    btn_addAddress.layer.masksToBounds=YES;
    btn_addAddress.layer.cornerRadius=3;
    [btn_addAddress setTitle:@"添加地址" forState:UIControlStateNormal];
    [btn_addAddress setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn_addAddress.backgroundColor=[UIColor colorWithRed:229/255.0 green:57/255.0 blue:33/255.0 alpha:1.0];
    [btn_addAddress addTarget:self action:@selector(btn_addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    [BackView_addAddres addSubview:btn_addAddress];
    [_page addSubview:BackView_addAddres];
    [self.view addSubview:_page];
}
-(void)btn_addAddressClick
{
    
    self.myAddress=[[AddAddressViewController alloc] initWithNibName:@"AddAddressViewController" bundle:[NSBundle mainBundle]];
    _myAddress.userid=_UserInfoData[@"userid"];
    UIView * item =_myAddress.view;
    [self.view addSubview:item];
}

-(void)CellClickFuc:(UIButton * )sender
{
    NSLog(@"%ld",(long)sender.tag);
}
@end
