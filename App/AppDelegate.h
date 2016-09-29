//
//  AppDelegate.h
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WQMainVC.h"

#import "WQXMPPManager.h"

//7xdfdw9g7
//55ufkitbr
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *navControl;

@property (nonatomic, strong) WQXMPPManager *xmppManager;

@property (assign, nonatomic) BOOL isReachable;//网络是否连接

+ (AppDelegate *)shareIntance;

- (void)getCurrentLanguage;
-(void)showRootVC;
-(void)saveMessageData;
@end

