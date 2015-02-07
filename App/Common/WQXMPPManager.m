//
//  WQXMPPManager.m
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQXMPPManager.h"

@implementation WQXMPPManager

static WQXMPPManager *sharedManager;

+(WQXMPPManager *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager=[[WQXMPPManager alloc]init];
    });
    return sharedManager;
}


- (void)setupStream{
    xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    xmppReconnect = [[XMPPReconnect alloc] init];
    [xmppReconnect         activate:xmppStream];


    [xmppStream setHostName:@"58.211.5.17"];
    [xmppStream setHostPort:5222];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    customCertEvaluation = YES;
    
    BOOL hasConnect = [self.xmppStream isConnected];
    if (!hasConnect)
    {
        [self myConnect];
    }
}

#pragma mark - xmpp链接
- (BOOL)myConnect{
    //设置用户
    XMPPJID *myjid = [XMPPJID jidWithString:@"2studio@pr-server-6"];
    NSError *error ;
    [self.xmppStream setMyJID:myjid];
    if (![self.xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error]) {
        DLog(@"连接失败 : %@",error.description);
        return NO;
    }
    return YES;
}

#pragma mark - 释放
- (void)teardownStream{
    [xmppStream removeDelegate:self];
    
    [xmppReconnect         deactivate];
    
    [xmppStream disconnect];
    
    xmppStream = nil;
    xmppReconnect = nil;
}
//发送在线状态
- (void)goOnline{
    XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
    [self.xmppStream sendElement:presence];
}

//发送下线状态
- (void)goOffline{
    [self getOffLineMessage];
    
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [self.xmppStream sendElement:presence];
}

- (void)disconnect{
    [self goOffline];
    [self.xmppStream disconnect];
}


#pragma mark - 获取离线消息
-(void)getOffLineMessage
{
    NSString *jid = @"7484customer@pr-server-6";
    XMPPIQ *iq = [[XMPPIQ alloc] initWithXMLString:[NSString stringWithFormat:@"<presence from='%@'><priority>1</priority></presence>",jid]error:nil];
    [self.xmppStream sendElement:iq];
}

#pragma mark - XMPPStream Delegate
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
    
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings{
    NSString *expectedCertName = [xmppStream.myJID domain];
    if (expectedCertName)
    {
        [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
    }
    
    if (customCertEvaluation)
    {
        [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender
{
    DLog(@"xmpp将要连接");
}
//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
    DLog(@"xmpp连接成功");
    
    NSError *error ;
    if (![self.xmppStream authenticateWithPassword:@"111111" error:&error])
    {
        DLog(@"error authenticate : %@",error.description);
    }
}


- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSError *error ;
    if (![self.xmppStream authenticateWithPassword:@"111111" error:&error])
    {
        DLog(@"error authenticate : %@",error.description);
    }
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error
{
    if (![self.xmppStream authenticateWithPassword:@"111111" error:nil])
    {
        
    }
}
//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
    [self goOnline];
    
    [self getOffLineMessage];
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    DLog(@"didNotAuthenticate:%@",error.description);
}
//好友列表
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    //    if ([@"result" isEqualToString:iq.type]) {
    //        NSXMLElement *query = iq.childElement;
    //        if ([@"query" isEqualToString:query.name]) {
    //            NSArray *items = [query children];
    //            for (NSXMLElement *item in items) {
    //                NSString *jid = [item attributeStringValueForName:@"jid"];
    //                XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
    ////                [self.roster addObject:xmppJID];
    //            }
    //        }
    //    }
    return YES;
}
//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    DLog(@"收到信息:%@",message.description);
    /*
     NSXMLElement *request = [message elementForName:@"request"];
     if (request) {
     if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"]) {//消息回执
     //组装消息回执
     XMPPMessage *msg = [XMPPMessage messageWithType:[message attributeStringValueForName:@"type"] to:message.from elementID:message.elementID];
     NSXMLElement *recieved = [NSXMLElement elementWithName:@"received" xmlns:@"urn:xmpp:receipts"];
     [msg addChild:recieved];
     
     //发送回执
     [self.xmppStream sendElement:msg];
     
     if ([self.chatDelegate respondsToSelector:@selector(getNewMessage:Message:)]) {
     [self.chatDelegate getNewMessage:self Message:message];
     }
     }
     }else {
     NSXMLElement *received = [message elementForName:@"received"];
     if (received)
     {
     if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
     {
     //发送成功
     NSLog(@"message send success!");
     }
     }
     }
     */
    NSXMLElement *received = [message elementForName:@"received"];
    if (received)
    {
        if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"])//消息回执
        {
            //发送成功
            NSLog(@"message send success!");
        }
    }else {
        if ([self.chatDelegate respondsToSelector:@selector(getNewMessage:Message:)]) {
            [self.chatDelegate getNewMessage:self Message:message];
        }
    }
    
}
//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    if (presence.status) {
        if ([self.chatDelegate respondsToSelector:@selector(friendStatusChange:Presence:)]) {
            [self.chatDelegate friendStatusChange:self Presence:presence];
        }
    }
}
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error
{
    DLog(@"接受发生错误: %@",error.description);
}
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq
{
    DLog(@"didSendIQ:%@",iq.description);
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    DLog(@"发送消息成功:%@",message.description);
    /*
     NSXMLElement *request = [message elementForName:@"request"];
     if (request) {
     if ([request.xmlns isEqualToString:@"urn:xmpp:receipts"]) {//消息回执
     if ([self.chatDelegate respondsToSelector:@selector(didSendMessage:Message:)])
     {
     [self.chatDelegate didSendMessage:self Message:message];
     }
     }
     }
     */
    if ([self.chatDelegate respondsToSelector:@selector(didSendMessage:Message:)])
    {
        [self.chatDelegate didSendMessage:self Message:message];
    }
}
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence
{
    DLog(@"状态改变成功:%@",presence.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error
{
    DLog(@"didFailToSendIQ:%@",error.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error
{
    DLog(@"发送消息失败:%@",error.description);
    if ([self.chatDelegate respondsToSelector:@selector(senMessageFailed:Message:)])
    {
        [self.chatDelegate senMessageFailed:self Message:message];
    }
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error
{
    DLog(@"状态改变失败:%@",error.description);
}
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender
{
    DLog(@"xmppStreamWasToldToDisconnect");
}
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender
{
    DLog(@"连接超时");
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
    DLog(@"断开连接失败: %@",error.description);
}
#pragma mark - XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    //接收到别人的添加好友请求，默认自动添加为好友
    XMPPJID *jid = presence.from;
//    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:jid andAddToRoster:YES];//同意添加
}
#pragma mark - XMPPReconnectDelegate
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags
{
    DLog(@"didDetectAccidentalDisconnect:%u",connectionFlags);
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags
{
    DLog(@"shouldAttemptAutoReconnect:%u",reachabilityFlags);
    return YES;
}

@end