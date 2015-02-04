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
{
    XMPPStream *xmppStream;
    XMPPReconnect *xmppReconnect;//重连模块
    
    BOOL isXmppConnected;
    BOOL customCertEvaluation;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;

@property (nonatomic, assign) id<ChatDelegate>chatDelegate;


- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

- (void)getOffLineMessage;

+(WQXMPPManager *)sharedInstance;
@end


@protocol ChatDelegate <NSObject>
@optional
-(void)friendStatusChange:(WQXMPPManager *)xmppManager Presence:(XMPPPresence *)presence;
-(void)getNewMessage:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message;
-(void)didSendMessage:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message;
-(void)senMessageFailed:(WQXMPPManager *)xmppManager Message:(XMPPMessage *)message;
@end