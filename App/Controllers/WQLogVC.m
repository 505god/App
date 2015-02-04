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

@interface WQLogVC ()<UITextFieldDelegate>

//指令
@property (nonatomic, strong) UITextField *companyText;
@property (nonatomic, strong) UILabel *companyTextName;
//用户名、帐号
@property (nonatomic, strong) UITextField *userText;
@property (nonatomic, strong) UILabel *userTextName;
//密码
@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UILabel *passwordTextName;


@property (nonatomic, assign) BOOL chang;
@end

@implementation WQLogVC


#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInputRectangle];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.title = @"登录";
    [self.navigationItem setHidesBackButton:YES];
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
    CGFloat companyY = 20;
    
    //指令、公司
    self.companyText = [inputText setupWithIcon:@"login_name" textY:companyY centerX:centerX point:nil];
    self.companyText.delegate = self;
    [self.companyText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:self.companyText];
    
    self.companyTextName = [self setupTextName:@"指令" frame:self.companyText.frame];
    [self.view addSubview:self.companyTextName];
    
    //帐号
    CGFloat userY = CGRectGetMaxY(self.companyText.frame) + 30;
    self.userText = [inputText setupWithIcon:@"login_name" textY:userY centerX:centerX point:nil];
    self.userText.delegate = self;
    [self.userText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:self.userText];
    
    self.userTextName = [self setupTextName:@"手机" frame:self.userText.frame];
    [self.view addSubview:self.userTextName];
    
    //密码
    CGFloat passwordY = CGRectGetMaxY(self.userText.frame) + 30;
    self.passwordText = [inputText setupWithIcon:@"login_pwd" textY:passwordY centerX:centerX point:nil];
    [self.passwordText setReturnKeyType:UIReturnKeyDone];
    [self.passwordText setSecureTextEntry:YES];
    self.passwordText.delegate = self;
    [self.view addSubview:self.passwordText];
    
    self.passwordTextName = [self setupTextName:@"密码" frame:self.passwordText.frame];
    [self.view addSubview:self.passwordTextName];
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetBtn.width = 64;
    forgetBtn.height = 20;
    forgetBtn.x = CGRectGetMaxX(self.passwordText.frame)-64;
    forgetBtn.y = CGRectGetMaxY(self.passwordText.frame) + 10;
    [forgetBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetBtn setTitleColor:COLOR(242, 242, 242, 1) forState:UIControlStateNormal];
    [forgetBtn setTitleColor:COLOR(6, 102, 186, 1) forState:UIControlStateHighlighted];
    [forgetBtn addTarget:self action:@selector(forgetBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetBtn];
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.width = 120;
    loginBtn.height = 40;
    loginBtn.x = CGRectGetMinX(self.passwordText.frame);
    loginBtn.y = CGRectGetMaxY(self.passwordText.frame) + 50;
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    loginBtn.backgroundColor = COLOR(37, 153, 210, 1);
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setTitleColor:COLOR(6, 102, 186, 1) forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //注册
    UIButton *resigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resigBtn.width = 120;
    resigBtn.height = 40;
    resigBtn.x = CGRectGetMaxX(self.passwordText.frame)-120;
    resigBtn.y = CGRectGetMaxY(self.passwordText.frame) + 50;
    [resigBtn setTitle:@"注册" forState:UIControlStateNormal];
    resigBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    resigBtn.layer.borderWidth = 1;
    resigBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [resigBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [resigBtn setTitleColor:COLOR(6, 102, 186, 1) forState:UIControlStateHighlighted];
    [resigBtn addTarget:self action:@selector(resigBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resigBtn];
}

- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor whiteColor];
    frame.origin.x += 20;
    textNameLabel.frame = frame;
    textNameLabel.alpha = 0.8;
    return textNameLabel;
}

- (void)loginBtnClick {
    [self.view endEditing:YES];
    if ([Utility checkString:self.userText.text]) {
        NSString *phoneRegex = @"1([3-5]|[7-8]){1}[0-9]{9}";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phoneTest evaluateWithObject:self.userText.text]){
            [Utility errorAlert:@"请输入正确手机号码" dismiss:YES];
        }else {
            if ([Utility checkString:self.passwordText.text]) {
                DLog(@"登录中...");
            }else {
                [Utility errorAlert:@"请输入密码" dismiss:YES];
            }
        }
    }else {
        [Utility errorAlert:@"请输入手机号码" dismiss:YES];
    }
}
-(void)pushResignVCWithType:(NSInteger)type {
    [self.view endEditing:YES];
    
    WQPhoneVC *phoneVC = LOADVC(@"WQPhoneVC");
    phoneVC.type = type;
    [self.navigationController pushViewController:phoneVC animated:YES];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    SafeRelease(phoneVC);
}
-(void)resigBtnClick {
    [self pushResignVCWithType:0];
}

-(void)forgetBtnClick {
    [self pushResignVCWithType:1];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.companyText) {
        [self diminishTextName:self.companyTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    }else if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        [self restoreTextName:self.companyTextName textField:self.companyText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
        [self restoreTextName:self.companyTextName textField:self.companyText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.companyText) {
        return [self.userText becomeFirstResponder];
    } else if (textField == self.userText) {
        return [self.passwordText becomeFirstResponder];
    } else {
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
        return [self.passwordText resignFirstResponder];
    }
}
- (void)diminishTextName:(UILabel *)label {
    [UIView animateWithDuration:0.5 animations:^{
        label.transform = CGAffineTransformMakeTranslation(-20, -16);
        label.font = [UIFont systemFontOfSize:12];
    }];
}
- (void)restoreTextName:(UILabel *)label textField:(UITextField *)textFieled {
    [self textFieldTextChange:textFieled];
    if (self.chang) {
        [UIView animateWithDuration:0.5 animations:^{
            label.transform = CGAffineTransformIdentity;
            label.font = [UIFont systemFontOfSize:16];
        }];
    }
}
- (void)textFieldTextChange:(UITextField *)textField {
    if (textField.text.length != 0) {
        self.chang = NO;
    } else {
        self.chang = YES;
    }
}

#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    [self restoreTextName:self.companyTextName textField:self.companyText];
    [self restoreTextName:self.userTextName textField:self.userText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
}
@end
