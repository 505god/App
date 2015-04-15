//
//  AppDelegate.m
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "AppDelegate.h"
#import <SMS_SDK/SMS_SDK.h>
#import "WQInitVC.h"

#import "Reachability.h"


//首页子ViewController
#import "WQShopVC.h"
#import "WQOrderVC.h"
#import "WQCustomerVC.h"
#import "WQSaleVC.h"


@interface AppDelegate ()

@property (strong, nonatomic) Reachability *hostReach;//网络监听所用

@end

@implementation AppDelegate

+ (AppDelegate *)shareIntance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //statusBar
    if (Platform>=7.0) {
        [WQDataShare sharedService].statusHeight = 20;
    }else {
        [WQDataShare sharedService].statusHeight = 0;
    }
    //短信
    [SMS_SDK registerApp:@"46c880df3c3f" withSecret:@"e5d8a4bb450b2e2f2076bffdf57b2ec7"];
    [SMS_SDK enableAppContactFriends:NO];
    
    //开启网络状况的监听
    _isReachable = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"] ;
    [_hostReach startNotifier];  //开始监听，会启动一个run loop
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    WQInitVC *initVC = LOADVC(@"WQInitVC");
    self.navControl = [[UINavigationController alloc]initWithRootViewController:initVC];
    self.window.rootViewController = self.navControl;
    
    [self getCurrentLanguage];
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - 获取当前语言
- (void)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    DLog( @"%@" , currentLanguage);
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        
    }else if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        
    }else if ([currentLanguage isEqualToString:@"zh-Hans"]) {
        
    }
    
}
#pragma mark - 网络
- (void)reachabilityChanged:(NSNotification *)note {
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    if(status == NotReachable) {
        self.isReachable = NO;
    }else {
        self.isReachable = YES;
    }
}

#pragma mark - 加载RootViewController
-(void)showRootVC {
    self.mainVC = [[WQMainVC alloc]init];
    WQShopVC *shopVC = [[WQShopVC alloc]init];
    WQOrderVC *orderVC = [[WQOrderVC alloc]init];
    WQCustomerVC *customerVC = [[WQCustomerVC alloc]init];
    WQSaleVC *saleVC = [[WQSaleVC alloc]init];

    self.mainVC.childenControllerArray = @[shopVC,orderVC,customerVC,saleVC];

    [self.mainVC setCurrentPageVC:0];
    self.navControl = [[UINavigationController alloc]initWithRootViewController:self.mainVC];
    
    self.window.rootViewController = self.navControl;
    
    SafeRelease(shopVC);SafeRelease(orderVC);SafeRelease(customerVC);SafeRelease(saleVC);
}
@end
