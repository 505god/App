//
//  WQXMPPManager.h
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"

@protocol ChatDelegate;

@interface WQXMPPManager : NSObject

@property (nonatomic, strong) XMPPStream *xmppStream;
@property (nonatomic, strong) XMPPReconnect *xmppReconnect;

@property (nonatomic, assign) BOOL isXmppConnected;
@property (nonatomic, assign) BOOL customCertEvaluation;

@property (nonatomic, assign) id<ChatDelegate>chatDelegate;

- (BOOL)myConnect;

- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

- (void)getOffLineMessage;

+(WQXMPPManager *)sharedInstance;

// 获取离线消息
-(void)getOffLineMessage;
@end


@protocol ChatDelegate <NSObject>

@optional
-(void)friendStatusChange:(WQXMPPManager *)xmppManager Presence:(XMPPPresence *)presence;
-(void)getNewMessage:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message;
-(void)didSendMessage:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message;
-(void)senMessageFailed:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message;
@end