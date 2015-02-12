//
//  WQCodeVC.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCodeVC.h"

#import <SMS_SDK/SMS_SDK.h>
#import "WQInfoVC.h"

@interface WQCodeVC ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *codeText;
@property (nonatomic, weak) IBOutlet UIButton *getCodeBtn;
@property (nonatomic, assign) NSInteger timeCount;

@end

@implementation WQCodeVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写验证码";
    
    //获取验证码
    [self getPhoneCode];
    self.getCodeBtn.enabled = NO;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(rightNavBarTap)];
    
    self.navigationItem.rightBarButtonItem.enabled = [self checkCodeNumber];
    
    [self.codeText becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)rightNavBarTap {
    [self.view endEditing:YES];
    
    //匹配验证码
    __weak typeof(self) wself = self;
    [SMS_SDK commitVerifyCode:self.codeText.text result:^(enum SMS_ResponseState state) {
        if (state == SMS_ResponseStateSuccess) {
            [NSObject cancelPreviousPerformRequestsWithTarget:wself
                                                     selector:@selector(scrollTimer)
                                                       object:nil];
            
            [wself.getCodeBtn setTitle:@"验证码正确" forState:UIControlStateNormal];
            
            WQInfoVC *infoVC = LOADVC(@"WQInfoVC");
            infoVC.type = self.type;
            infoVC.phoneNumber = self.phoneNumber;
            
            [self.navigationController pushViewController:infoVC animated:YES];
             
            SafeRelease(infoVC);
            
        }else {
//            [KVNProgress showErrorWithStatus:@"验证码不正确!"];
            
            [NSObject cancelPreviousPerformRequestsWithTarget:wself
                                                     selector:@selector(scrollTimer)
                                                       object:nil];
            [wself.getCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            [wself.codeText becomeFirstResponder];
            self.getCodeBtn.enabled = YES;
        }
    }];
}

-(BOOL)checkCodeNumber {
    if ([Utility checkString:self.codeText.text]) {
        NSString *phoneRegex = @"[0-9]{4}";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phoneTest evaluateWithObject:self.codeText.text]){
            return NO;
        }
    }else {
        return NO;
    }
    
    return YES;
}
#pragma mark - 获取验证码

-(void)getPhoneCode
{
    __weak typeof(self) wself = self;
    [SMS_SDK getVerifyCodeByPhoneNumber:self.phoneNumber AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) {
        if (state == SMS_ResponseStateGetVerifyCodeSuccess) {
//            [KVNProgress showSuccessWithStatus:@"验证码已发送!"];
            
            wself.timeCount = 60;
            [wself.getCodeBtn setBackgroundImage:[UIImage imageNamed:@"BindingBtnAct"] forState:UIControlStateNormal];
            [wself.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds 后重新获取验证码",wself.timeCount] forState:UIControlStateNormal];
            [wself performSelector:@selector(scrollTimer) withObject:nil afterDelay:1];
        }else {
//            [KVNProgress showErrorWithStatus:@"验证码获取失败!"];
            self.getCodeBtn.enabled = YES;
        }
    }];
}

-(void)scrollTimer{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(scrollTimer)
                                               object:nil];
    
    self.timeCount --;
    if (self.timeCount<0) {
        [self.getCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        self.getCodeBtn.enabled = YES;
    }else {
        [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%ds 后重新获取验证码",self.timeCount] forState:UIControlStateNormal];
        
        [self performSelector:@selector(scrollTimer) withObject:nil afterDelay:1];
    }
}
#pragma mark - UITextFieldDelegate

- (void)textFieldTextChange:(NSNotification *)notification {
    self.navigationItem.rightBarButtonItem.enabled=[self checkCodeNumber];
}

#pragma mark - 事件

-(IBAction)getCodeBtnPressed:(id)sender {
    [self getPhoneCode];
}


@end
