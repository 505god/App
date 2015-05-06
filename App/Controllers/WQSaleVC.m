//
//  WQSaleVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSaleVC.h"

#import "DAPagesContainer.h"
#import "WQPriceLineVC.h"

#define ARC4RANDOM_MAX 0x100000000


@interface WQSaleVC ()<UIWebViewDelegate>

@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@property (nonatomic, strong) UIWebView *webView;
@end

@implementation WQSaleVC

-(void)dealloc {
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"SaleVC", @"")];
//    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addProperty"] forState:UIControlStateNormal];
    [self.navBarView.leftBtn setHidden:YES];
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];

//    [self initContainerView];
    
    self.webView = [[UIWebView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height}];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initContainerView {
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = (CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height};
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
    //价格轴
    WQPriceLineVC *priceVC = [[WQPriceLineVC alloc]init];
    priceVC.title = NSLocalizedString(@"salePriceLine", @"");
    self.pagesContainer.viewControllers = @[priceVC];
    SafeRelease(priceVC);//SafeRelease(payVC);SafeRelease(finishVC);
}

@end
