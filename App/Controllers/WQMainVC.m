//
//  WQMainVC.m
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMainVC.h"
#import "WQMainControl.h"

#import "WQShopVC.h"
#import "WQCustomerVC.h"
#import "WQOrderVC.h"
#import "WQSaleVC.h"

@interface WQMainVC ()

//店铺
@property (nonatomic, weak) IBOutlet WQMainControl *shopControl;
//客户
@property (nonatomic, weak) IBOutlet WQMainControl *customerControl;
//订单
@property (nonatomic, weak) IBOutlet WQMainControl *orderControl;
//销售统计
@property (nonatomic, weak) IBOutlet WQMainControl *saleControl;

@end

@implementation WQMainVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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

#pragma mark - 事件

-(IBAction)shopVCPressed:(id)sender {
    WQShopVC *shopVC = LOADVC(@"WQShopVC");
    [self.navigationController pushViewController:shopVC animated:YES];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    SafeRelease(shopVC);
}
-(IBAction)customerVCPressed:(id)sender {
    WQCustomerVC *customerVC = LOADVC(@"WQCustomerVC");
    [self.navigationController pushViewController:customerVC animated:YES];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    SafeRelease(customerVC);
}
-(IBAction)orderVCPressed:(id)sender {
    WQOrderVC *orderVC = LOADVC(@"WQOrderVC");
    [self.navigationController pushViewController:orderVC animated:YES];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    SafeRelease(orderVC);
}
-(IBAction)saleVCPressed:(id)sender {
    WQSaleVC *saleVC = LOADVC(@"WQSaleVC");
    [self.navigationController pushViewController:saleVC animated:YES];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    SafeRelease(saleVC);
}
@end
