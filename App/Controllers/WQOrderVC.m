//
//  WQOrderVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQOrderVC.h"

#import "DAPagesContainer.h"
#import "WQOrderDealVC.h"
#import "WQOrderPayVC.h"
#import "WQOrderFinishVC.h"

#import "WQOrderSearchVC.h"

@interface WQOrderVC ()<WQNavBarViewDelegate>

//待处理、待付款、已完成容器
@property (strong, nonatomic) DAPagesContainer *pagesContainer;

@end

@implementation WQOrderVC

-(void)dealloc {
    SafeRelease(_pagesContainer);
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"OrderVC", @"")];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"searchNormal"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"searchHight"] forState:UIControlStateHighlighted];;
    [self.navBarView.leftBtn setHidden:YES];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self initContainerView];
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

//商品类页面容器
-(void)initContainerView {
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = (CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height};
    self.pagesContainer.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
    //待处理
    WQOrderDealVC *dealVC = [[WQOrderDealVC alloc]init];
    dealVC.title = NSLocalizedString(@"orderDeal", @"");
    
    //待付款
    WQOrderPayVC *payVC = [[WQOrderPayVC alloc]init];
    payVC.title = NSLocalizedString(@"orderPay", @"");
    
    //已完成
    WQOrderFinishVC *finishVC = [[WQOrderFinishVC alloc]init];;
    finishVC.title = NSLocalizedString(@"orderFinish", @"");
    
    self.pagesContainer.viewControllers = @[dealVC,payVC,finishVC];
    SafeRelease(dealVC);SafeRelease(payVC);SafeRelease(finishVC);
}

#pragma mark - 导航栏代理

//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    WQOrderSearchVC *orderSearchVC = [[WQOrderSearchVC alloc]init];
    [self.navigationController pushViewController:orderSearchVC animated:YES];
    SafeRelease(orderSearchVC);
}
@end
