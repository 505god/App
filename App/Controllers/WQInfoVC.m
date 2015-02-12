//
//  WQInfoVC.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQInfoVC.h"
#import "WQTapImg.h"

#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface WQInfoVC ()<JKImagePickerControllerDelegate,UITextFieldDelegate,WQTapImgDelegate>

@property (nonatomic, weak) IBOutlet WQTapImg *headerImg;

@property (nonatomic, weak) IBOutlet UILabel *promptLab;
@property (nonatomic, weak) IBOutlet UITextField *passwordText1;
@property (nonatomic, weak) IBOutlet UITextField *passwordText2;

@property (nonatomic, weak) IBOutlet UITextField *companyText;
@property (nonatomic, weak) IBOutlet UIButton *signBtn;

@end

@implementation WQInfoVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写信息";
    
    if (self.type==0) {//注册
        self.headerImg.image = [UIImage imageNamed:@"randomheader_7"];
        self.headerImg.delegate = self;
        
    }else if (self.type==1){//找回密码
        //TODO:显示用户头像
        self.promptLab.hidden = YES;
        self.companyText.userInteractionEnabled = NO;
        self.companyText.text = self.phoneNumber;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(IBAction)signBtnPressed:(id)sender {
    if ([Utility checkString:self.companyText.text]) {
        if ([Utility checkString:self.passwordText1.text]) {
            if (![self.passwordText1.text isEqualToString:self.passwordText2.text]) {
                [Utility errorAlert:@"两次密码不一致" view:self.view];
            }else {
                [KVNProgress showWithParameters:@{KVNProgressViewParameterStatus: @"努力加载中...",KVNProgressViewParameterBackgroundType:@(KVNProgressBackgroundTypeSolid),KVNProgressViewParameterFullScreen: @(NO)}];
                
                if (self.type==0) {
                    
                }else if (self.type==1) {
                    
                }
            }
        }else {
            [Utility errorAlert:@"请设置密码" view:self.view];
        }
    }else {
        [Utility errorAlert:@"请输入用户姓名" view:self.view];
    }
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.companyText){
        return [self.passwordText1 becomeFirstResponder];
    }else if (textField == self.passwordText1){
        return [self.passwordText2 becomeFirstResponder];
    }else if (textField == self.passwordText2){
        return [self.view endEditing:YES];
    }
    return YES;
}

#pragma mark - RpImageViewTapDelegate
- (void)tappedWithObject:(id) sender {
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}
#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    JKAssets *set = (JKAssets *)assets[0];
    
    __weak typeof(self) weakSelf = self;
    
    __block UIImage *image = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        [lib assetForURL:set.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *tempImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                image = [weakSelf dealImage:tempImg];
                SafeRelease(tempImg);
            }
        } failureBlock:^(NSError *error) {
            
        }];
    });
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        weakSelf.headerImg.image = image;
        
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(UIImage *)dealImage:(UIImage *)image {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 200*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return [UIImage imageWithData:imageData];
}

@end
