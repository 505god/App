//
//  WQSaleVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSaleVC.h"

#define buttonSize 40

@interface WQSaleVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIButton *goBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UIButton *refreshBtn;
@end

@implementation WQSaleVC

-(void)dealloc {
    SafeRelease(_webView.delegate);
    SafeRelease(_webView);
    SafeRelease(_bottomView);
    SafeRelease(_goBtn);
    SafeRelease(_backBtn);
    SafeRelease(_refreshBtn);
}

-(void)setBottom {
    self.webView = [[UIWebView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-self.navBarView.height-20-NavgationHeight}];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.bottomView = [[UIView alloc]initWithFrame:(CGRect){0,self.view.height-NavgationHeight,self.view.width,NavgationHeight}];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [self.bottomView setShadow:[UIColor blackColor] rect:(CGRect){0,0,400,4} opacity:0.5 blurRadius:3];
    [self.view addSubview:self.bottomView];
    
    self.goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.goBtn setImage:[UIImage imageNamed:@"webgo"] forState:UIControlStateNormal];
    [self.goBtn setImage:[UIImage imageNamed:@"webgoNor"] forState:UIControlStateHighlighted];
    [self.goBtn addTarget:self action:@selector(goItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.goBtn.frame = (CGRect){(self.bottomView.width-buttonSize)/2,(self.bottomView.height-buttonSize)/2,buttonSize,buttonSize};
    self.goBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.bottomView addSubview:self.goBtn];
    
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn setImage:[UIImage imageNamed:@"webback"] forState:UIControlStateNormal];
    [self.backBtn setImage:[UIImage imageNamed:@"webbackNor"] forState:UIControlStateHighlighted];
    self.backBtn.frame = (CGRect){(self.goBtn.left-buttonSize)/2,(self.bottomView.height-buttonSize)/2,buttonSize,buttonSize};
    [self.backBtn addTarget:self action:@selector(backItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.backBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.bottomView addSubview:self.backBtn];
    
    self.refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.refreshBtn setImage:[UIImage imageNamed:@"webrefresh"] forState:UIControlStateNormal];
    [self.refreshBtn setImage:[UIImage imageNamed:@"webrefreshNor"] forState:UIControlStateHighlighted];
    [self.refreshBtn addTarget:self action:@selector(refreshItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.refreshBtn.frame = (CGRect){(self.goBtn.left-buttonSize)/2+self.goBtn.right,(self.bottomView.height-buttonSize)/2,buttonSize,buttonSize};
    self.refreshBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.bottomView addSubview:self.refreshBtn];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"SaleVC", @"")];
    [self.navBarView.leftBtn setHidden:YES];
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self setBottom];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *addressURL = [NSURL URLWithString:@"https://barryhippo.xicp.net:8443/rest/statisticsView"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:addressURL];
//    [request setValue:[APService registrationID] forHTTPHeaderField:@"registractionid"];
    [request setValue:@"test" forHTTPHeaderField:@"registractionid"];
    [self.webView loadRequest:request];
    SafeRelease(request);SafeRelease(addressURL);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.webView stopLoading];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - webView代理

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [self.webView stopLoading];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.webView.canGoBack) {
        self.backBtn.enabled=YES;
    }else{
        self.backBtn.enabled=NO;
    }
    if(self.webView.canGoForward){
        self.goBtn.enabled=YES;
    }else{
        self.goBtn.enabled=NO;
    }
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.webView stopLoading];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark - 点击事件

- (void)backItemPressed:(id)sender {
    [self.webView goBack];
}

- (void)goItemPressed:(id)sender {
    [self.webView goForward];
}

- (void)refreshItemPressed:(id)sender {
    UIButton *btn = (UIButton *)sender;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;//HUGE_VALF;
    [btn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView reload];
}
@end
