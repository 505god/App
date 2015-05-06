//
//  WQEditNameVC.m
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQEditNameVC.h"

@interface WQEditNameVC ()<WQNavBarViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIView *whiteView;

@end

@implementation WQEditNameVC

-(void)dealloc {
    SafeRelease(_whiteView);
    SafeRelease(_nameTxt.delegate);
    SafeRelease(_nameTxt);
    SafeRelease(_delegate);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"ShopName", @"")];
    self.navBarView.navDelegate = self;
    [self.navBarView.rightBtn setTitle:NSLocalizedString(@"Save", @"") forState:UIControlStateNormal];
    self.navBarView.rightBtn.enabled = NO;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    
    self.nameTxt = [[UITextField alloc]initWithFrame:(CGRect){10,7,self.whiteView.width-20,30}];
    self.nameTxt.delegate = self;
    self.nameTxt.borderStyle = UITextBorderStyleNone;
    self.nameTxt.returnKeyType = UIReturnKeyDone;
    self.nameTxt.backgroundColor = [UIColor whiteColor];
    [self.nameTxt setClearButtonMode:UITextFieldViewModeWhileEditing];
    self.nameTxt.placeholder = NSLocalizedString(@"ShopNameLimit", @"");
    self.nameTxt.text = [WQDataShare sharedService].userObj.userName;
    [self.whiteView addSubview:self.nameTxt];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [self.nameTxt becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//比较名称是否改变
-(BOOL)validateChangeName {
    return ![self.nameTxt.text isEqualToString:[WQDataShare sharedService].userObj.userName];
}

#pragma mark - property
-(UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,NavgationHeight}];
        _whiteView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_whiteView];
    }
    return _whiteView;
}
#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editNameVCDidCancel:)]) {
        [self.delegate editNameVCDidCancel:self];
    }
}
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    
    self.interfaceTask = [WQAPIClient editShopNameWithParameters:@{@"storeName":self.nameTxt.text} block:^(NSInteger finished, NSError *error) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(editNameVCDidChange:)]) {
            [self.delegate editNameVCDidChange:self];
        }
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.nameTxt resignFirstResponder];
    return YES;
}
-(void)textFieldDidChange:(NSNotification *)notification {
    UITextField *text = (UITextField *)notification.object;
    
    self.navBarView.rightBtn.enabled = [self validateChangeName];
    
    NSInteger kMaxLength = 10;
    
    NSString *toBeString = text.text;

    NSString *lang = text.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入
        UITextRange *selectedRange = [text markedTextRange];
        UITextPosition *position = [text positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > kMaxLength) {
                text.text = [toBeString substringToIndex:kMaxLength];
            }
        }
    }else {
        if (toBeString.length > kMaxLength) {
            text.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}
@end
