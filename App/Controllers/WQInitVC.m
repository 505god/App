//
//  WQInitVC.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQInitVC.h"
#import "WQInitView.h"
#import "WQLogVC.h"
#import "WQMainVC.h"




@interface WQInitVC ()<WQInitViewDelegate>

@end

@implementation WQInitVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WQInitView *initView = [[WQInitView alloc]initWithBackgroundImage:nil];
    initView.delegate = self;
    [self.view addSubview:initView];
    [initView startAnimation];
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

#pragma mark - WQInitViewDelegate 
//开始
-(void)initViewDidBeginAnimating:(WQInitView *)initView {
    
}
//结束
-(void)initViewDidEndAnimating:(WQInitView *) initView {
    AppDelegate *appDel = [AppDelegate shareIntance];
    
    [appDel showRootVC];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
