//
//  WQInfoVC.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQInfoVC.h"
#import "WQInputText.h"
#import "UIView+XD.h"

#import "WQLocalDB.h"

@interface WQInfoVC ()<UITextFieldDelegate,WQNavBarViewDelegate>

@property (nonatomic, strong) UITextField *userText;

@property (nonatomic, strong) UITextField *passwordText;


@end

@implementation WQInfoVC

-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"logInPassword", @"")];
    [self.navBarView.rightBtn setHidden:YES];
    self.navBarView.isShowShadow = YES;
    self.navBarView.navDelegate = self;
    [self.view addSubview:self.navBarView];
    
    [self setupInputRectangle];
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

#pragma mark - 添加输入框

- (void)setupInputRectangle {
    CGFloat centerX = [UIScreen mainScreen].bounds.size.width * 0.5;
    WQInputText *inputText = [[WQInputText alloc] init];
    CGFloat userY = 100;
    
    //帐号
    self.userText = [inputText setupWithIcon:@"login_pwd" textY:userY centerX:centerX point:NSLocalizedString(@"logInPassword", @"")];
    self.userText.delegate = self;
    [self.userText setSecureTextEntry:YES];
    [self.userText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:self.userText];
    
    //密码
    CGFloat passwordY = self.userText.bottom + 5;
    self.passwordText = [inputText setupWithIcon:@"login_pwd" textY:passwordY centerX:centerX point:NSLocalizedString(@"confirmPassword", @"")];
    [self.passwordText setReturnKeyType:UIReturnKeyDone];
    [self.passwordText setSecureTextEntry:YES];
    self.passwordText.delegate = self;
    [self.view addSubview:self.passwordText];
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.width = self.userText.width;
    loginBtn.height = 40;
    loginBtn.x = self.passwordText.left;
    loginBtn.y = self.passwordText.bottom + 20;
    [loginBtn setTitle:NSLocalizedString(@"submit", @"") forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR(251, 0, 41, 1);
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    SafeRelease(loginBtn);SafeRelease(inputText);
}
-(void)submit {
    NSString *msg = @"";
    
    if (self.userText.text.length==0) {
        msg = NSLocalizedString(@"logInPasswordError", @"");
    }else if (![self.userText.text isEqualToString:self.passwordText.text]){
        msg = NSLocalizedString(@"confirmPasswordError", @"");
    }
    
    if (msg.length>0) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:msg];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.interfaceTask = [[WQAPIClient sharedClient] POST:@"resetStorePassword" parameters:@{@"userPhone":@"18915411336",@"userPassword":self.passwordText.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    [self.appDel showRootVC];
                }else {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        }];
    }
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


@end
