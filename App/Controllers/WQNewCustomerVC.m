//
//  WQNewCustomerVC.m
//  App
//
//  Created by 邱成西 on 15/4/26.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQNewCustomerVC.h"

@interface WQNewCustomerVC ()<WQNavBarViewDelegate>

@property (nonatomic, strong) UILabel *codeLab;

@end

@implementation WQNewCustomerVC

-(void)getCode {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    self.interfaceTask = [WQAPIClient getCustomerCodeWithBlock:^(NSString *codeString, NSError *error) {
       
        if (!error) {
            if ([Utility checkString:codeString]) {
                
            }else {
                //失败
            }
        }else {
            //失败
        }
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"CustomerNew", @"")];
    [self.navBarView.rightBtn setHidden:YES];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
