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
    self.xmppStream = [[XMPPStream alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    {
        xmppStream.enableBackgroundingOnSocket = YES;
    }
#endif
    self.xmppReconnect = [[XMPPReconnect alloc] init];
    [self.xmppReconnect activate:self.xmppStream];


    [self.xmppStream setHostName:@"barryhippo.xicp.net"];
    [self.xmppStream setHostPort:5222];
    
    // Add ourself as a delegate to anything we may be interested in
    
    [self.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    self.customCertEvaluation = YES;
    
    BOOL hasConnect = [self.xmppStream isConnected];
    if (!hasConnect)
    {
        [self myConnect];
    }
}

#pragma mark - xmpp链接
- (BOOL)myConnect{
    //设置用户
    XMPPJID *myjid = [XMPPJID jidWithString:[NSString stringWithFormat:@"%d@ubuntu",[WQDataShare sharedService].userObj.userId]];
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
    [self.xmppStream removeDelegate:self];
    
    [self.xmppReconnect deactivate];
    
    [self.xmppStream disconnect];
    
    self.xmppStream = nil;
    self.xmppReconnect = nil;
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
-(void)getOffLineMessage {
    NSString *jid = [NSString stringWithFormat:@"%d@ubuntu",[WQDataShare sharedService].userObj.userId];
    XMPPIQ *iq = [[XMPPIQ alloc] initWithXMLString:[NSString stringWithFormat:@"<presence from='%@'><priority>1</priority></presence>",jid]error:nil];
    [self.xmppStream sendElement:iq];
}

#pragma mark - XMPPStream Delegate
- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket {
    
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings{
    NSString *expectedCertName = [self.xmppStream.myJID domain];
    if (expectedCertName) {
        [settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
    }
    
    if (self.customCertEvaluation) {
        [settings setObject:@(YES) forKey:GCDAsyncSocketManuallyEvaluateTrust];
    }
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender{
}

#pragma mark - XMPPStreamDelegate

- (void)xmppStreamWillConnect:(XMPPStream *)sender {
    DLog(@"xmpp将要连接");
}
//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender {
    DLog(@"xmpp连接成功");
    if ([WQDataShare sharedService].idRegister) {
        NSError *error ;
        if (![self.xmppStream authenticateWithPassword:@"111111" error:&error]){
            DLog(@"error authenticate : %@",error.description);
        }
    }else {
        if ([self.xmppStream isConnected] && [self.xmppStream supportsInBandRegistration]) {
            XMPPJID *myJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%d@ubuntu",[WQDataShare sharedService].userObj.userId]];
            [self.xmppStream setMyJID:myJID];
            
            NSError *error ;
            [WQDataShare sharedService].idRegister = [self.xmppStream registerWithPassword:@"111111" error:&error];
            if (![WQDataShare sharedService].idRegister) {
                DLog(@"注册失败");
            }
        }
    }
}

//注册成功，则授权
- (void)xmppStreamDidRegister:(XMPPStream *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"register"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSError *error ;
    if (![self.xmppStream authenticateWithPassword:@"111111" error:&error]) {
        DLog(@"error authenticate : %@",error.description);
    }
}
- (void)xmppStream:(XMPPStream *)sender didNotRegister:(NSXMLElement *)error{
    DLog(@"注册失败:%@",error.description);
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"register"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (![self.xmppStream authenticateWithPassword:@"111111" error:nil]) {
    }
}
//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender {
    [self goOnline];
    [self getOffLineMessage];
}
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error {
    DLog(@"didNotAuthenticate:%@",error.description);
}
//好友列表
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq {
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
    if (received) {
        if ([received.xmlns isEqualToString:@"urn:xmpp:receipts"]){//消息回执
            //发送成功
            DLog(@"message send success!");
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
- (void)xmppStream:(XMPPStream *)sender didReceiveError:(NSXMLElement *)error {
    DLog(@"接受发生错误: %@",error.description);
}
- (void)xmppStream:(XMPPStream *)sender didSendIQ:(XMPPIQ *)iq {
    DLog(@"didSendIQ:%@",iq.description);
}
- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {
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
    if ([self.chatDelegate respondsToSelector:@selector(didSendMessage:Message:)]) {
        [self.chatDelegate didSendMessage:self Message:message];
    }
}
- (void)xmppStream:(XMPPStream *)sender didSendPresence:(XMPPPresence *)presence {
    DLog(@"状态改变成功:%@",presence.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendIQ:(XMPPIQ *)iq error:(NSError *)error {
    DLog(@"didFailToSendIQ:%@",error.description);
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {
    DLog(@"发送消息失败:%@",error.description);
    if ([self.chatDelegate respondsToSelector:@selector(senMessageFailed:Message:)]) {
        [self.chatDelegate senMessageFailed:self Message:message];
    }
}
- (void)xmppStream:(XMPPStream *)sender didFailToSendPresence:(XMPPPresence *)presence error:(NSError *)error {
    DLog(@"状态改变失败:%@",error.description);
}
- (void)xmppStreamWasToldToDisconnect:(XMPPStream *)sender {
    DLog(@"xmppStreamWasToldToDisconnect");
}
- (void)xmppStreamConnectDidTimeout:(XMPPStream *)sender {
    DLog(@"连接超时");
}
- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error {
    DLog(@"连接失败: %@",error.description);
}
#pragma mark - XMPPRosterDelegate
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    //接收到别人的添加好友请求，默认自动添加为好友
}
#pragma mark - XMPPReconnectDelegate
- (void)xmppReconnect:(XMPPReconnect *)sender didDetectAccidentalDisconnect:(SCNetworkReachabilityFlags)connectionFlags {
    DLog(@"didDetectAccidentalDisconnect:%u",connectionFlags);
}
- (BOOL)xmppReconnect:(XMPPReconnect *)sender shouldAttemptAutoReconnect:(SCNetworkReachabilityFlags)reachabilityFlags {
    DLog(@"shouldAttemptAutoReconnect:%u",reachabilityFlags);
    return YES;
}

@end
