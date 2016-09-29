//
//  WQInitVC.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQInitVC.h"
#import "WQLocalDB.h"
@interface WQInitVC ()

@property (nonatomic, strong) UIActivityIndicatorView* activityView;
@property (nonatomic, strong) UIImageView *loadingImg;

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
-(void)setupView {
    self.loadingImg = [[UIImageView alloc]initWithFrame:(CGRect){(self.view.width-100)/2,(self.view.height-100)/2-30,100,100}];
    self.loadingImg.image = [UIImage imageNamed:@"chat_voice_record"];
    [self.view addSubview:self.loadingImg];
    
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    lab.text = NSLocalizedString(@"Refreshing", @"");
    lab.font = [UIFont systemFontOfSize:15];
    [lab sizeToFit];
    lab.frame = (CGRect){(self.view.width-lab.width-30)/2+30,self.loadingImg.bottom+20,lab.width,20};
    [self.view addSubview:lab];
    
    
    self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityView.left = lab.left-30;
    self.activityView.top = self.loadingImg.bottom+20;
    [self.activityView startAnimating];
    [self.view addSubview:self.activityView];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupView];
    
    if ([WQDataShare sharedService].isPushing) {
        
        if ([WQDataShare sharedService].pushType==WQPushTypeLogIn) {
            [WQDataShare sharedService].isPushing = NO;
            [[WQLocalDB sharedWQLocalDB] deleteLocalUserWithCompleteBlock:^(BOOL finished) {
                [self performSelectorOnMainThread:@selector(loadRootViewController) withObject:nil waitUntilDone:NO];
            }];
        }else {
            [self check];
        }
    }else {
        [self check];
    }
}

-(void)check {
    ///判断登录与否
    self.interfaceTask  = [[WQAPIClient sharedClient] GET:@"/rest/login/checkLogin" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            NSInteger status = [[jsonData objectForKey:@"status"]integerValue];
            if (status==0) {
                [[WQLocalDB sharedWQLocalDB] deleteLocalUserWithCompleteBlock:^(BOOL finished) {
                    [self performSelectorOnMainThread:@selector(loadRootViewController) withObject:nil waitUntilDone:NO];
                }];
            }else {
                
                [self performSelectorOnMainThread:@selector(loadRootViewController) withObject:nil waitUntilDone:NO];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [[WQLocalDB sharedWQLocalDB] deleteLocalUserWithCompleteBlock:^(BOOL finished) {
            
            [self performSelectorOnMainThread:@selector(loadRootViewController) withObject:nil waitUntilDone:NO];
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


-(void)loadRootViewController {
    AppDelegate *appDel = [AppDelegate shareIntance];
    
    [appDel showRootVC];
}

@end
