//
//  WQSaleVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSaleVC.h"

#define buttonSize 40

@interface WQSaleVC ()<UIWebViewDelegate,WQNavBarViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WQSaleVC

-(void)dealloc {
    SafeRelease(_webView.delegate);
    SafeRelease(_webView);
}

-(void)setBottom {
    self.webView = [[UIWebView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-self.navBarView.height-10}];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];

    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"SaleVC", @"")];
    [self.navBarView.leftBtn setHidden:YES];
    
    CGRect imageFrame= CGRectMake(0, 0, 0, 0);
    UIEdgeInsets imageInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.navBarView.rightBtn.imageView.frame = imageFrame;
    self.navBarView.rightBtn.imageEdgeInsets = imageInset;
    self.navBarView.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.navBarView.rightBtn.frame = (CGRect){self.navBarView.width-50,self.navBarView.height-42,40,40};
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"webrefresh"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"webrefreshNor"] forState:UIControlStateHighlighted];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self setBottom];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSURL *addressURL = [NSURL URLWithString:@"https://120.24.64.85:8443/rest/statisticsView"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:addressURL];
    [request setValue:[APService registrationID] forHTTPHeaderField:@"registractionid"];
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
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.webView stopLoading];
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
#pragma mark - 点击事件
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 1.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;//HUGE_VALF;
    [self.navBarView.rightBtn.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.webView reload];
}

@end
