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

#import "JSONKit.h"
#import "MobClick.h"
#import "BlockAlertView.h"

#import "WQMessageVC.h"
@interface AppDelegate ()<ChatDelegate>

@property (strong, nonatomic) Reachability *hostReach;//网络监听所用

@end

@implementation AppDelegate

+ (AppDelegate *)shareIntance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MobClick startWithAppkey:@"554efcf267e58e54b8001625" reportPolicy:BATCH   channelId:@"Web"];
    
    //statusBar
    if (Platform>=7.0) {
        [WQDataShare sharedService].statusHeight = 20;
    }else {
        [WQDataShare sharedService].statusHeight = 0;
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    [APService setupWithOption:launchOptions];
    
    
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
    
    //获取未读信息
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [Utility returnPath];
    NSString *filenameMessage = [path stringByAppendingPathComponent:@"message.plist"];
    if (![fileManage fileExistsAtPath:filenameMessage]) {
        [WQDataShare sharedService].messageArray = [NSMutableArray arrayWithCapacity:0];
    }else {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filenameMessage];
        [WQDataShare sharedService].messageArray = [NSMutableArray arrayWithArray:arr];
        SafeRelease(arr);
    }
    SafeRelease(filenameMessage);
    SafeRelease(path);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"isOn"];
    [defaults synchronize];
    
    [WQDataShare sharedService].isPushing = NO;
    [WQDataShare sharedService].pushType = WQPushTypeNone;
    //点击推送进入App
    NSDictionary *pushDict = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    if (pushDict) {
        [WQDataShare sharedService].isPushing = YES;
        [WQDataShare sharedService].pushType = [[pushDict objectForKey:@"type"]intValue];
    }
    SafeRelease(pushDict);
    
    [WQDataShare sharedService].idRegister = [[[NSUserDefaults standardUserDefaults] objectForKey:@"register"]boolValue];
    
    [self getCurrentLanguage];
    
    
    WQInitVC *initVC = [[WQInitVC alloc]init];
    self.navControl = [[UINavigationController alloc]initWithRootViewController:initVC];
    self.window.rootViewController = self.navControl;
    
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:2 forKey:@"isOn"];
    [defaults synchronize];
    
    [self.xmppManager goOffline];
    [self.xmppManager teardownStream];
    self.xmppManager = nil;
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [Utility returnPath];
    //保存未读消息的数组
    NSString *filenameMessage = [path stringByAppendingPathComponent:@"message.plist"];
    if ([fileManage fileExistsAtPath:filenameMessage]) {
        [fileManage removeItemAtPath:filenameMessage error:nil];
    }
    [NSKeyedArchiver archiveRootObject:[WQDataShare sharedService].messageArray toFile:filenameMessage];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:1 forKey:@"isOn"];
    [defaults synchronize];
    
    [[WQLocalDB sharedWQLocalDB] getLocalUserDataWithCompleteBlock:^(NSArray *array) {
        if (array.count==0) {//未登录
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
        }
    }];
    
    //获取未读信息
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [Utility returnPath];
    NSString *filenameMessage = [path stringByAppendingPathComponent:@"message.plist"];
    if (![fileManage fileExistsAtPath:filenameMessage]) {
        [WQDataShare sharedService].messageArray = [NSMutableArray arrayWithCapacity:0];
    }else {
        NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filenameMessage];
        [WQDataShare sharedService].messageArray = [NSMutableArray arrayWithArray:arr];
        SafeRelease(arr);
    }
    SafeRelease(filenameMessage);
    SafeRelease(path);
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"isOn"];
    [defaults synchronize];
    
    [self.xmppManager goOffline];
    [self.xmppManager teardownStream];
    self.xmppManager = nil;
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *path = [Utility returnPath];
    //保存未读消息的数组
    NSString *filenameMessage = [path stringByAppendingPathComponent:@"message.plist"];
    if ([fileManage fileExistsAtPath:filenameMessage]) {
        [fileManage removeItemAtPath:filenameMessage error:nil];
    }
    [NSKeyedArchiver archiveRootObject:[WQDataShare sharedService].messageArray toFile:filenameMessage];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    NSInteger isOn = [[NSUserDefaults standardUserDefaults] integerForKey:@"isOn"];
    int type = [[userInfo objectForKey:@"type"]intValue];
    if (type==WQPushTypeLogIn) {//异地登陆
        [[WQLocalDB sharedWQLocalDB] deleteLocalUserWithCompleteBlock:^(BOOL finished) {
            if (finished) {
                //TODO:xmpp退出
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sessionCookies"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self.xmppManager goOffline];
                [self.xmppManager teardownStream];
                self.xmppManager = nil;
                [WQDataShare sharedService].userObj = nil;
                
                [self showRootVC];
            }
        }];
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:nil];
        [alert show];
    }else {
        [WQDataShare sharedService].pushType = type;
        if (isOn == 1) {//app登录
            
        }else if (isOn == 2) {//app从后台进入前台
            [WQDataShare sharedService].isPushing = YES;
            [self showRootVC];
        }
    }
}

#pragma mark - 获取当前语言
- (void)getCurrentLanguage {
    NSArray *languages = [NSLocale preferredLanguages];
    NSString *currentLanguage = [languages objectAtIndex:0];
    if ([currentLanguage isEqualToString:@"zh-Hans"] || [currentLanguage isEqualToString:@"zh-Hant"]) {//汉语
        currentLanguage = @"zh";
    }else if ([currentLanguage isEqualToString:@"en"]) {//英语
    }else if ([currentLanguage isEqualToString:@"it"]) {//意大利语
    }else {
        currentLanguage = @"en";
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ///语言
        [[WQAPIClient sharedClient] POST:@"/rest/login/langType" parameters:@{@"language":currentLanguage} success:^(NSURLSessionDataTask *task, id responseObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
            self.navControl = [[UINavigationController alloc]initWithRootViewController:self.mainVC];
            
            self.window.rootViewController = self.navControl;
            
            [WQDataShare sharedService].isPushing = YES;
            [WQDataShare sharedService].pushType = WQPushTypeChat;
            if ([WQDataShare sharedService].isPushing) {
                [WQDataShare sharedService].isPushing = NO;
                
                if ([WQDataShare sharedService].pushType==WQPushTypeOrderRemindDelivery || [WQDataShare sharedService].pushType==WQPushTypeOrderFinish) {
                    [self.mainVC setCurrentPageVC:1];
                }else if ([WQDataShare sharedService].pushType==WQPushTypeCustomer) {
                    [self.mainVC setCurrentPageVC:2];
                }else if ([WQDataShare sharedService].pushType==WQPushTypeChat) {
                    [self.mainVC setCurrentPageVC:2];
                    
                    WQMessageVC *messageVC = [[WQMessageVC alloc]init];
                    [customerVC.navigationController pushViewController:messageVC animated:YES];
                    SafeRelease(messageVC);
                }
            }else {
                [self.mainVC setCurrentPageVC:0];
            }
            
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
                [self logIn];
            });
            
            SafeRelease(shopVC);SafeRelease(orderVC);SafeRelease(customerVC);SafeRelease(saleVC);
        }
    }];
}
-(void)logIn {
    [[WQAPIClient sharedClient] POST:@"/rest/login/userLogin" parameters:@{@"userPhone":[WQDataShare sharedService].userObj.userPhone,@"userPassword":[WQDataShare sharedService].userObj.password,@"validateCode":@""} success:^(NSURLSessionDataTask *task, id responseObject) {
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"https://120.24.64.85:8443/rest/login/userLogin"]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"sessionCookies"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
#pragma mark - chatDelegate
-(void)getNewMessage:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message {
    XMPPJID *fromJid = message.from;
    
    NSDictionary *aDic = [message.body objectFromJSONString];
    WQMessageObj *messageObj = [WQMessageObj messageFromDictionary:aDic];
    
    [[WQLocalDB sharedWQLocalDB] saveMessageToLocal:messageObj completeBlock:^(BOOL finished) {
    }];
    
    if ([WQDataShare sharedService].isInMessageView) {
        if ([[fromJid bare] isEqualToString:[WQDataShare sharedService].otherJID]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetNewMessage" object:messageObj userInfo:nil];
        }else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"isNewMessage" object:@"1" userInfo:nil];
            
            NSString *str = [NSString stringWithFormat:@"%d",messageObj.messageFrom];
            if (![[WQDataShare sharedService].messageArray containsObject:str]) {
                [[WQDataShare sharedService].messageArray addObject:str];
            }
        }
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"isNewMessage" object:@"1" userInfo:nil];
        
        NSString *str = [NSString stringWithFormat:@"%d",messageObj.messageFrom];
        if (![[WQDataShare sharedService].messageArray containsObject:str]) {
            [[WQDataShare sharedService].messageArray addObject:str];
        }
    }
}

-(void)didSendMessage:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message {
    NSDictionary *aDic = [message.body objectFromJSONString];
    WQMessageObj *messageObj = [WQMessageObj messageFromDictionary:aDic];
    
    [[WQLocalDB sharedWQLocalDB] saveMessageToLocal:messageObj completeBlock:^(BOOL finished) {
    }];
    
    if ([WQDataShare sharedService].isInMessageView) {
        XMPPJID *fromJid = message.to;
        if ([[fromJid bare] isEqualToString:[WQDataShare sharedService].otherJID]){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SendNewMessage" object:messageObj userInfo:nil];
        }else {
            //do nothing
        }
    }
}
-(void)senMessageFailed:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message {
    DLog(@"send message error");
}
@end
