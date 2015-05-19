//
//  WQLogVC.m
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQLogVC.h"
#import "WQInputText.h"
#import "UIView+XD.h"

#import "WQPhoneVC.h"

#import "WQTapImg.h"
#import "SDImageCache.h"

#import "WQLocalDB.h"
#import "WQInfoVC.h"

@interface WQLogVC ()<UITextFieldDelegate,WQTapImgDelegate>

//用户名、帐号
@property (nonatomic, strong) UITextField *userText;
//密码
@property (nonatomic, strong) UITextField *passwordText;

@property (nonatomic, strong) UIButton *forgetBtn;
@property (nonatomic, strong) UIButton *loginBtn;

///错误次数
@property (nonatomic, assign) NSInteger wrongNumber;
@property (nonatomic, strong) WQTapImg *codeImageView;

//验证码
@property (nonatomic, strong) UITextField *codeText;
@end

@implementation WQLogVC

#pragma mark - 获取登录错误次数
-(void)getWrongNumber {
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        weakSelf.interfaceTask = [[WQAPIClient sharedClient] GET:@"/rest/login/wrongNumber" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    NSDictionary *aDic = (NSDictionary *)[jsonData objectForKey:@"returnObj"];
                    weakSelf.wrongNumber = [[aDic objectForKey:@"wrongNumber"] integerValue];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    });
}

///验证码
-(void)getWrongCode {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.interfaceTask = [[WQAPIClient sharedClient] GET:@"/rest/login/validateCode" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    NSString *wrongCode = [jsonData objectForKey:@"returnObj"];
                    NSString *imageURLString = [NSString stringWithFormat:@"%@%@",Host,wrongCode];
                    
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                        [[SDImageCache sharedImageCache]removeImageForKey:imageURLString withCompletion:^{
                            [weakSelf.codeImageView sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"] options:SDWebImageRefreshCached];
                        }];
                    }];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
    });
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getWrongNumber];
    
    [self setupInputRectangle];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self addObserver:self forKeyPath:@"wrongNumber" options:0 context:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [WQAPIClient cancelConnection];
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
    
    [self removeObserver:self forKeyPath:@"wrongNumber"];
    [self.view endEditing:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 添加输入框

- (void)setupInputRectangle {
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    WQInputText *inputText = [[WQInputText alloc] init];
    CGFloat userY = 100;
    
    //帐号
    self.userText = [inputText setupWithIcon:@"login_name" textY:userY centerX:centerX point:NSLocalizedString(@"logInName", @"")];
    self.userText.delegate = self;
    [self.userText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:self.userText];
    
    //密码
    CGFloat passwordY = self.userText.bottom + 5;
    self.passwordText = [inputText setupWithIcon:@"login_pwd" textY:passwordY centerX:centerX point:NSLocalizedString(@"logInPassword", @"")];
    [self.passwordText setReturnKeyType:UIReturnKeyDone];
    [self.passwordText setSecureTextEntry:YES];
    self.passwordText.delegate = self;
    [self.view addSubview:self.passwordText];
    
    //验证码
    CGFloat codeY = self.passwordText.bottom + 5;
    self.codeText = [inputText setupWithIcon:@"login_pwd" textY:codeY centerX:centerX point:NSLocalizedString(@"logInCode", @"")];
    self.codeText.delegate = self;
    [self.codeText setReturnKeyType:UIReturnKeyDone];
    [self.view addSubview:self.codeText];
    [self.codeText setHidden:YES];
    
    self.codeImageView = [[WQTapImg alloc]initWithFrame:(CGRect){self.passwordText.right-120,self.codeText.bottom-40,120,40}];
    self.codeImageView.delegate = self;
    self.codeImageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
    self.codeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.codeImageView];
    [self.codeImageView setHidden:YES];
    
    //忘记密码
    self.forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetBtn.width = 64;
    self.forgetBtn.height = 20;
    self.forgetBtn.x = self.passwordText.right-64;
    self.forgetBtn.y = self.passwordText.bottom + 10;
    [self.forgetBtn setTitle:NSLocalizedString(@"forgetPwd", @"") forState:UIControlStateNormal];
    self.forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.forgetBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
    [self.forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forgetBtn];
    
    //登录
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.width = self.userText.width;
    self.loginBtn.height = 40;
    self.loginBtn.x = self.passwordText.left;
    self.loginBtn.y = self.passwordText.bottom + 40;
    [self.loginBtn setTitle:NSLocalizedString(@"logIn", @"") forState:UIControlStateNormal];
    self.loginBtn.backgroundColor = COLOR(251, 0, 41, 1);
    self.loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [self.loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
    [self.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    
    SafeRelease(inputText);
}


- (void)loginBtnClick {
    [self.view endEditing:YES];
    if ([Utility checkString:[NSString stringWithFormat:@"%@",self.userText.text]]) {
        if ([Utility checkString:[NSString stringWithFormat:@"%@",self.passwordText.text]]) {
            
            if (self.codeText.hidden== NO && ![Utility checkString:[NSString stringWithFormat:@"%@",self.codeText.text]]) {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"verifycode", @"")];
                return;
            }
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            
            self.interfaceTask = [[WQAPIClient sharedClient] POST:@"/rest/login/userLogin" parameters:@{@"userPhone":self.userText.text,@"userPassword":self.passwordText.text,@"validateCode":self.codeText.text} success:^(NSURLSessionDataTask *task, id responseObject) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                
                NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"https://barryhippo.xicp.net:8443/rest/login/userLogin"]];
                NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"sessionCookies"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *jsonData=(NSDictionary *)responseObject;
                    
                    if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                        
                        NSDictionary *aDic = (NSDictionary *)[jsonData objectForKey:@"returnObj"];
                        NSDictionary *dic = (NSDictionary *)[aDic objectForKey:@"store"];
                        
                        WQUserObj *userObj = [[WQUserObj alloc]init];
                        [userObj mts_setValuesForKeysWithDictionary:dic];
                        userObj.userPhone = self.userText.text;
                        
                        [WQDataShare sharedService].userObj = userObj;
                        
                        [[WQLocalDB sharedWQLocalDB] saveUserDataToLocal:userObj completeBlock:^(BOOL finished) {
                            if (finished) {
                                [self.appDel showRootVC];
                            }
                        }]; 
                    }else {
                        self.wrongNumber ++;
                        [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                    }
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
            }];
        }else {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"logInPasswordError", @"")];
        }
    }else {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"logInNameError", @"")];
    }
}

-(void)forgetBtnClick {
    [self.view endEditing:YES];
    
    WQInfoVC *infoVC = [[WQInfoVC alloc]init];
    [self.navigationController pushViewController:infoVC animated:YES];
    SafeRelease(infoVC);
    
//    WQPhoneVC *phoneVC = [[WQPhoneVC alloc]init];
//    [self.navigationController pushViewController:phoneVC animated:YES];
//    SafeRelease(phoneVC);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userText) {
        return [self.passwordText becomeFirstResponder];
    } else {
        return [self.passwordText resignFirstResponder];
    }
}

#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"wrongNumber"]) {
        if (self.wrongNumber>=3) {//错误3次
            self.forgetBtn.frame = (CGRect){self.forgetBtn.left,self.codeText.bottom+10,self.forgetBtn.width,self.forgetBtn.height};
            
            self.loginBtn.frame = (CGRect){self.loginBtn.left,self.forgetBtn.bottom+10,self.loginBtn.width,self.loginBtn.height};
            
            [self.codeText setHidden:NO];
            [self.codeImageView setHidden:NO];
            
            [self getWrongCode];
        }
    }
}

- (void)tappedWithObject:(id) sender {
    self.codeImageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
    [self getWrongCode];
}
@end
