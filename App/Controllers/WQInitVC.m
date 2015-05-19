//
//  WQInitVC.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQInitVC.h"
#import "WQInitView.h"
#import "WQLocalDB.h"
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
    
    __block WQInitView *initView = [[WQInitView alloc]initWithBackgroundImage:nil];
    initView.delegate = self;
    [self.view addSubview:initView];

    ///判断登录与否
    self.interfaceTask  = [[WQAPIClient sharedClient] GET:@"/rest/login/checkLogin" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            NSInteger status = [[jsonData objectForKey:@"status"]integerValue];
            if (status==0) {
                [[WQLocalDB sharedWQLocalDB] deleteLocalUserWithCompleteBlock:^(BOOL finished) {
                    [initView startAnimation];
                    SafeRelease(initView);
                }];
            }else {
                [initView startAnimation];
                SafeRelease(initView);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[WQLocalDB sharedWQLocalDB] deleteLocalUserWithCompleteBlock:^(BOOL finished) {
            [initView startAnimation];
            SafeRelease(initView);
        }];
    }];
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
    
    [WQAPIClient cancelConnection];
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

#pragma mark - WQInitViewDelegate
//开始
-(void)initViewDidBeginAnimating:(WQInitView *)initView {
    
}
//结束
-(void)initViewDidEndAnimating:(WQInitView *) initView {
    AppDelegate *appDel = [AppDelegate shareIntance];
    
    [appDel showRootVC];
}

@end
