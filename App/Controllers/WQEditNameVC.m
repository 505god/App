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
@property (nonatomic, strong) UITextField *nameTxt;
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
    
    [self.view addSubview:self.whiteView];
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
    BOOL res = NO;
    
    return res;
}

#pragma mark - property
-(UIView *)whiteView {
    if (!_whiteView) {
        _whiteView = [[UIView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,NavgationHeight}];
        _whiteView.backgroundColor = [UIColor whiteColor];
        
        _nameTxt = [[UITextField alloc]initWithFrame:(CGRect){10,7,_whiteView.width-20,30}];
        _nameTxt.delegate = self;
        _nameTxt.borderStyle = UITextBorderStyleNone;
        _nameTxt.returnKeyType = UIReturnKeyDone;
        _nameTxt.clearsOnBeginEditing = YES;
        _nameTxt.backgroundColor = [UIColor whiteColor];
        _nameTxt.placeholder = NSLocalizedString(@"ShopNameLimit", @"");
        [_whiteView addSubview:_nameTxt];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(editNameVCDidChange:)]) {
        [self.delegate editNameVCDidChange:self];
    }
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
#warning check
    NSString *lang = text.textInputMode.primaryLanguage;
//    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
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
