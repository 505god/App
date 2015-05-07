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

#import "WQLogVC.h"
//首页子ViewController
#import "WQShopVC.h"
#import "WQOrderVC.h"
#import "WQCustomerVC.h"
#import "WQSaleVC.h"

#import "WQLocalDB.h"

#import "WQXMPPManager.h"
#import "WQMessageVC.h"
#import "JSONKit.h"

@interface AppDelegate ()<ChatDelegate>

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
    
    WQInitVC *initVC = [[WQInitVC alloc]init];
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
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [self.xmppManager goOffline];
    [self.xmppManager teardownStream];
    self.xmppManager = nil;
}

#pragma mark - 获取当前语言
- (void)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    DLog( @"%@" , currentLanguage);
    if ([currentLanguage isEqualToString:@"zh-Hans"]) {//汉语
        
    }else if ([currentLanguage isEqualToString:@"en"]) {//英语
        
    }else if ([currentLanguage isEqualToString:@"it"]) {//意大利语
        
    }else {
        currentLanguage = @"en";
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [WQAPIClient postLanguageWithParameters:@{@"language":currentLanguage} block:^(NSInteger status, NSError *error) {
        }];
    });
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
    
    [[WQLocalDB sharedWQLocalDB] getLocalUserDataWithCompleteBlock:^(NSArray *array) {
        if (array.count==0) {//未登录
            WQLogVC *logVC = [[WQLogVC alloc]init];
            self.navControl = [[UINavigationController alloc]initWithRootViewController:logVC];
            self.window.rootViewController = self.navControl;
            SafeRelease(logVC);
            
            
        }else {//已登录
            [WQDataShare sharedService].userObj = (WQUserObj *)[array firstObject];
            
            //登录成功之后连接XMPP
            self.xmppManager = [WQXMPPManager sharedInstance];
            
            [self.xmppManager setupStream];
            self.xmppManager.chatDelegate = self;
            //xmpp连接
            if (![self.xmppManager.xmppStream isConnected]) {
                [self.xmppManager myConnect];
            }
            
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
    }];
}

#pragma mark - chatDelegate
-(void)getNewMessage:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message {
    NSDictionary *aDic = [message.body objectFromJSONString];
    WQMessageObj *messageObj = [WQMessageObj messageFromDictionary:aDic];
    
    [[WQLocalDB sharedWQLocalDB] saveMessageToLocal:messageObj completeBlock:^(BOOL finished) {
        
    }];
}

-(void)didSendMessage:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message {
    
}
-(void)senMessageFailed:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message {
    
}
@end
