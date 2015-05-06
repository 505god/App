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

@interface WQInfoVC ()<UITextFieldDelegate,WQNavBarViewDelegate>

@property (nonatomic, strong) UITextField *userText;
@property (nonatomic, strong) UILabel *userTextName;

@property (nonatomic, strong) UITextField *passwordText;
@property (nonatomic, strong) UILabel *passwordTextName;

@property (nonatomic, assign) BOOL chang;

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
    self.userText = [inputText setupWithIcon:@"login_pwd" textY:userY centerX:centerX point:nil];
    self.userText.delegate = self;
    [self.userText setReturnKeyType:UIReturnKeyNext];
    [self.view addSubview:self.userText];
    
    self.userTextName = [self setupTextName:NSLocalizedString(@"logInPassword", @"") frame:self.userText.frame];
    [self.view addSubview:self.userTextName];
    
    //密码
    CGFloat passwordY = self.userText.bottom + 30;
    self.passwordText = [inputText setupWithIcon:@"login_pwd" textY:passwordY centerX:centerX point:nil];
    [self.passwordText setReturnKeyType:UIReturnKeyDone];
    [self.passwordText setSecureTextEntry:YES];
    self.passwordText.delegate = self;
    [self.view addSubview:self.passwordText];
    
    self.passwordTextName = [self setupTextName:NSLocalizedString(@"confirmPassword", @"") frame:self.passwordText.frame];
    [self.view addSubview:self.passwordTextName];
    
    //登录
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.width = self.userText.width;
    loginBtn.height = 40;
    loginBtn.x = self.passwordText.left;
    loginBtn.y = self.passwordText.bottom + 50;
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
        
    }
}
- (UILabel *)setupTextName:(NSString *)textName frame:(CGRect)frame
{
    UILabel *textNameLabel = [[UILabel alloc] init];
    textNameLabel.text = textName;
    textNameLabel.font = [UIFont systemFontOfSize:16];
    textNameLabel.textColor = [UIColor whiteColor];
    frame.origin.x += 20;
    textNameLabel.frame = frame;
    return textNameLabel;
}
#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.userText) {
        [self diminishTextName:self.userTextName];
        [self restoreTextName:self.passwordTextName textField:self.passwordText];
    } else if (textField == self.passwordText) {
        [self diminishTextName:self.passwordTextName];
        [self restoreTextName:self.userTextName textField:self.userText];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userText) {
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
    [self restoreTextName:self.userTextName textField:self.userText];
    [self restoreTextName:self.passwordTextName textField:self.passwordText];
}


@end
