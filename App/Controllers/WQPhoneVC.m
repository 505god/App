//
//  WQPhoneVC.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQPhoneVC.h"
#import "WQCodeVC.h"

@interface WQPhoneVC ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *phoneText;

@end

@implementation WQPhoneVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"填写手机号";
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(rightNavBarTap)];
    self.navigationItem.rightBarButtonItem.enabled = [self checkPhoneNumber];
    
    [self.phoneText becomeFirstResponder];
    
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
    if (self.type==0) {
        //TODO:验证手机号码是否已注册
        NSDictionary *aDic = [Utility returnDicByPath:@"checkPhone"];
        DLog(@"%@",aDic);
        
        if ([[aDic objectForKey:@"isPhoneSign"]integerValue]==0) {
            [self pushCodeVC];
        }
    }else {
        //TODO:验证手机号码数据库是否存在，若存在返回用户信息
        [self pushCodeVC];
    }
}

-(void)pushCodeVC {
    WQCodeVC *codeVC = LOADVC(@"WQCodeVC");
    codeVC.phoneNumber = self.phoneText.text;
    codeVC.type = self.type;
    [self.navigationController pushViewController:codeVC animated:YES];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    SafeRelease(codeVC);
}

/**
 *  @author 邱成西, 15-02-03 15:02:06
 *
 *  检测输入的手机号码
 */
-(BOOL)checkPhoneNumber {
    if ([Utility checkString:self.phoneText.text]) {
        NSString *phoneRegex = @"1([3-5]|[7-8]){1}[0-9]{9}";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phoneTest evaluateWithObject:self.phoneText.text]){
            return NO;
        }
    }else {
        return NO;
    }
    return YES;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldTextChange:(NSNotification *)notification {
    self.navigationItem.rightBarButtonItem.enabled = [self checkPhoneNumber];
}

#pragma mark - touchesBegan
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
