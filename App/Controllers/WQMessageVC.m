//
//  WQMessageVC.m
//  App
//
//  Created by 邱成西 on 15/5/5.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMessageVC.h"


#import "WQMessageCell.h"
#import "WQMessageFrame.h"
#import "WQMessageObj.h"

#import "WQChatManager.h"
#import "JSONKit.h"

#import "WQLocalDB.h"
#import "WQPlayerManager.h"

#define kMESSAGE_TYPE @"messageType"
#define kMESSAGE_FROM @"messageFrom"
#define kMESSAGE_TO @"messageTo"
#define kMESSAGE_CONTENT @"messageContent"
#define kMESSAGE_DATE @"messageDate"

@interface WQMessageVC ()<WQNavBarViewDelegate,WQMessageCellDelegate,UITableViewDataSource,UITableViewDelegate,PlayingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (assign, nonatomic) UIEdgeInsets originalTableViewContentInset;
@property (assign, nonatomic) CGFloat previousTextViewContentHeight;
@property (nonatomic, strong) WQInputFunctionView *messageInputView;

@property (nonatomic, strong) WQChatManager *chatModel;

//生成消息的字典
@property (nonatomic, strong) NSMutableDictionary *tempMessageDic;

//本地数据库分页加载
@property (nonatomic, assign) NSInteger localStart;
//本地数据库分页加载
@property (nonatomic, assign) BOOL isCanLoadingMore;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL isShowKeyboard;
@end

@implementation WQMessageVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.localStart = 0;
    self.isCanLoadingMore = YES;
    
    //导航栏
    [self.navBarView setTitleString:self.customerObj.customerName];
    [self.navBarView.rightBtn setHidden:YES];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.messageInputView];

    [WQDataShare sharedService].otherJID = [NSString stringWithFormat:@"%d@barryhippo.xicp.net",self.customerObj.customerId];
    
    [self loadBaseViewsAndData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.originalTableViewContentInset = self.tableView.contentInset;
    //xmpp连接
    if ([self.appDel.xmppManager.xmppStream isConnected]) {
        [self.appDel.xmppManager myConnect];
    }
    
    [WQDataShare sharedService].isInMessageView = YES;
    
    //聊天通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNewMessage:) name:@"GetNewMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendNewMessage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendNewMessage:) name:@"SendNewMessage" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboardNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboardNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [WQDataShare sharedService].isInMessageView = NO;
    
    [WQAPIClient cancelConnection];
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GetNewMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"SendNewMessage" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - property

-(WQInputFunctionView *)messageInputView {
    if (!_messageInputView) {
        _messageInputView = [[WQInputFunctionView alloc]initWithFrame:CGRectMake(0, self.view.height-NavgationHeight, self.view.width, NavgationHeight) superVC:self delegate:self panGestureRecognizer:self.tableView.panGestureRecognizer];
        _messageInputView.delegate = self;
    }
    return _messageInputView;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height-NavgationHeight} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}
-(NSMutableDictionary *)tempMessageDic {
    if (!_tempMessageDic) {
        _tempMessageDic = [[NSMutableDictionary alloc]init];
    }
    return _tempMessageDic;
}

#pragma mark - private

- (void)loadBaseViewsAndData {
    self.chatModel = [[WQChatManager alloc]init];
    self.chatModel.customerObj = self.customerObj;
    
    [self.chatModel getLocalMessageWithId:[NSString stringWithFormat:@"%d",self.customerObj.customerId] Id2:[NSString stringWithFormat:@"%d",[WQDataShare sharedService].userObj.userId] start:self.localStart completeBlock:^(BOOL isCanLoadingMore,NSInteger count) {
        self.isCanLoadingMore = isCanLoadingMore;
        [self.tableView reloadData];
        
        [self scrollToBottomAnimated:YES];
    }];
}
-(void)initHeaderView {
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.frame = CGRectMake((self.view.width-20)/2, 5, 20, 20);
    [activity startAnimating];
    [header addSubview:activity];
    activity = nil;
    self.tableView.tableHeaderView = header;
    header = nil;
}
#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [textView becomeFirstResponder];
    
    self.isShowKeyboard = YES;
    
    if(!self.previousTextViewContentHeight)
        self.previousTextViewContentHeight = textView.contentSize.height;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    
    self.isShowKeyboard = NO;
}

- (void)textViewDidChange:(UITextView *)textView {
    CGFloat maxHeight = [WQInputFunctionView maxHeight];
    
    CGSize size = [textView sizeThatFits:CGSizeMake(textView.width, maxHeight)];
    CGFloat textViewContentHeight = size.height;
    
    BOOL isShrinking = textViewContentHeight < self.previousTextViewContentHeight;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;
    
    if(!isShrinking && self.previousTextViewContentHeight == maxHeight) {
        changeInHeight = 0;
    }else {
        changeInHeight = MIN(changeInHeight, maxHeight - self.previousTextViewContentHeight);
    }
    
    if(changeInHeight != 0.0f) {
        
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                    0.0f,
                                                                    self.tableView.contentInset.bottom + changeInHeight,
                                                                    0.0f);
                             
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;
                             [self scrollToBottomAnimated:NO];
                             
                             if(isShrinking) {
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                             
                             CGRect inputViewFrame = self.messageInputView.frame;
                             self.messageInputView.frame = CGRectMake(0.0f,
                                                                      inputViewFrame.origin.y - changeInHeight,
                                                                      inputViewFrame.size.width,
                                                                      inputViewFrame.size.height + changeInHeight);
                             
                             if(!isShrinking) {
                                 [self.messageInputView adjustTextViewHeightBy:changeInHeight];
                             }
                         }
                         completion:^(BOOL finished) {
                         }];
        
        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {//点击了return------------发送;
        if (textView.text.length==0){
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"sendMessageError", nil)];
        }else {
            self.tempMessageDic = nil;
            [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",[WQDataShare sharedService].userObj.userId] forKey:kMESSAGE_FROM];
            [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",self.customerObj.customerId] forKey:kMESSAGE_TO];
            [self.tempMessageDic setObject:textView.text forKey:kMESSAGE_CONTENT];
            [self.tempMessageDic setObject:[Utility getNowDateFromatAnDate] forKey:kMESSAGE_DATE];
            [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",0] forKey:kMESSAGE_TYPE];
            [self sendMessage:self.tempMessageDic];
        }
        return NO;
    }
    return YES;
}
#pragma mark - keyboard

- (void)handleWillShowKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboardNotification:(NSNotification *)notification {
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification {
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[self animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = self.messageInputView.frame;
                         if (keyboardRect.origin.y < self.view.height) {
                             inputViewFrame.size.height = self.messageInputView.TextViewInput.height+NavgationHeight-36;
                         }
                         
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - inputViewFrame.size.height;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         self.messageInputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         
                         UIEdgeInsets insets = self.originalTableViewContentInset;
                         insets.bottom = self.view.frame.size.height
                         - self.messageInputView.frame.origin.y-NavgationHeight;
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
    [self scrollToBottomAnimated:YES];
}
#pragma mark - Dismissive text view delegate

- (void)keyboardDidScrollToPoint:(CGPoint)point {
    CGRect inputViewFrame = self.messageInputView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

- (void)keyboardWillBeDismissed {
    CGRect inputViewFrame = self.messageInputView.frame;
    inputViewFrame.origin.y = self.view.bounds.size.height - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

- (void)keyboardWillSnapBackToPoint:(CGPoint)point {
    CGRect inputViewFrame = self.messageInputView.frame;
    CGPoint keyboardOrigin = [self.view convertPoint:point fromView:nil];
    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
    self.messageInputView.frame = inputViewFrame;
}

#pragma mark - Utilities

- (UIViewAnimationOptions)animationOptionsForCurve:(UIViewAnimationCurve)curve {
    switch (curve) {
        case UIViewAnimationCurveEaseInOut:
            return UIViewAnimationOptionCurveEaseInOut;
            
        case UIViewAnimationCurveEaseIn:
            return UIViewAnimationOptionCurveEaseIn;
            
        case UIViewAnimationCurveEaseOut:
            return UIViewAnimationOptionCurveEaseOut;
            
        case UIViewAnimationCurveLinear:
            return UIViewAnimationOptionCurveLinear;
            
        default:
            return kNilOptions;
    }
}

#pragma mark - tableView delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.chatModel.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WQMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellID"];
    if (cell == nil) {
        cell = [[WQMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.chatModel.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataArray[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

//tableView Scroll to bottom
- (void)scrollToBottomAnimated:(BOOL)animated {
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    
    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.tableView])
    {
        if (scrollView.contentOffset.y <= 0 && self.isCanLoadingMore) {
            [self initHeaderView];
            self.localStart += 10;
            //加载聊天记录
            [self performSelector:@selector(getLocalMessage) withObject:nil afterDelay:1];
        }
    }
}

-(void)getLocalMessage {
    
    __weak typeof(self) weakSelf = self;
    [self.chatModel getNextLocalMessageWithId:[NSString stringWithFormat:@"%d",self.customerObj.customerId] Id2:[NSString stringWithFormat:@"%d",[WQDataShare sharedService].userObj.userId] start:self.localStart completeBlock:^(BOOL isCanLoadingMore,NSInteger count) {
        
        weakSelf.tableView.tableHeaderView = nil;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:count inSection:0];
        weakSelf.isCanLoadingMore = isCanLoadingMore;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
        });
    }];
}
#pragma mark - 发送消息

-(void)sendMessage:(NSMutableDictionary *)messageDic {
    NSString *msgJson=[messageDic JSONString];
    //生成消息对象
    NSString *siID = [XMPPStream generateUUID];
    
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:[NSString stringWithFormat:@"%d@barryhippo.xicp.net",self.customerObj.customerId]] elementID:siID];

    [message addBody:msgJson];
    [message addAttributeWithName:@"xmlns" stringValue:@"jabber:client"];
    
    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];
    
    [message addAttributeWithName:@"id" stringValue:message.elementID];
    
    [self.appDel.xmppManager.xmppStream sendElement:message];
}
- (void)WQInputFunctionView:(WQInputFunctionView *)funcView sendPicture:(UIImage *)image {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://barryhippo.xicp.net:8443/rest/img/uploadProImg" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1)  name:@"imgFile" fileName:@"imgFile.jpeg" mimeType:@"image/jpeg"];
        } error:nil];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.securityPolicy.allowInvalidCertificates = YES;
        
        NSProgress *progress = nil;
        
        self.uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (!error) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *jsonData=(NSDictionary *)responseObject;
                    
                    if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                        
                        NSDictionary *obj = [jsonData objectForKey:@"returnObj"];
                        NSString *imagePath = [obj objectForKey:@"img"];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.tempMessageDic = nil;
                            [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",[WQDataShare sharedService].userObj.userId] forKey:kMESSAGE_FROM];
                            [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",self.customerObj.customerId] forKey:kMESSAGE_TO];
                            [self.tempMessageDic setObject:imagePath forKey:kMESSAGE_CONTENT];
                            [self.tempMessageDic setObject:[Utility getNowDateFromatAnDate] forKey:kMESSAGE_DATE];
                            [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",1] forKey:kMESSAGE_TYPE];
                            [self sendMessage:self.tempMessageDic];
                            
                            [MBProgressHUD hideAllHUDsForView:self.appDel.window.rootViewController.view animated:YES];
                        });
                    }
                }
            }
        }];
        [self.uploadTask resume];
        
    });
}

- (void)WQInputFunctionView:(WQInputFunctionView *)funcView fileName:(NSString *)filePath name:(NSString *)name time:(NSTimeInterval)interval {
    
    NSData *armData = [NSData dataWithContentsOfFile:filePath];
    NSString *base64Encoded = [armData base64EncodedStringWithOptions:0];
    
    NSString *timeStr;
    int time = (int)interval;
    if (time<10) {
        timeStr = [NSString stringWithFormat:@"0%d",time];
    }else
        timeStr = [NSString stringWithFormat:@"%d",time];
    
    //base642014051910261812 最后两位是时间
    NSMutableString *soundString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"base64%@%@",name,timeStr]];
    [soundString appendString:base64Encoded];
    
    
    self.tempMessageDic = nil;
    [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",[WQDataShare sharedService].userObj.userId] forKey:kMESSAGE_FROM];
    [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",self.customerObj.customerId] forKey:kMESSAGE_TO];
    [self.tempMessageDic setObject:soundString forKey:kMESSAGE_CONTENT];
    [self.tempMessageDic setObject:[Utility getNowDateFromatAnDate] forKey:kMESSAGE_DATE];
    [self.tempMessageDic setObject:[NSString stringWithFormat:@"%d",2] forKey:kMESSAGE_TYPE];
    [self sendMessage:self.tempMessageDic];
}

-(void)beginRecord {
    [UIView animateWithDuration:0.25f
                     animations:^{
                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,0.0f,0.0f,0.0f);
                         
                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                         [self scrollToBottomAnimated:NO];
                         
                         CGRect inputViewFrame = self.messageInputView.frame;
                         self.messageInputView.frame = CGRectMake(0.0f,self.view.height-NavgationHeight,inputViewFrame.size.width,NavgationHeight);
                         
                     }completion:^(BOOL finished) {
                     }];
}


#pragma mark - chatDelegate
-(void)getNewMessage:(NSNotification *)notification {
    WQMessageObj *messageObj = (WQMessageObj *)notification.object;
    
    //列表展示
    [self dealTheFunctionData:messageObj];
}
-(void)sendNewMessage:(NSNotification *)notification {
    WQMessageObj *messageObj = (WQMessageObj *)notification.object;
    
    //保存为最近联系人
    [[WQLocalDB sharedWQLocalDB] saveCustomerDataToLocal:self.customerObj completeBlock:^(BOOL finished) {
    }];
    
    [self dealTheFunctionData:messageObj];
    
}
//列表展示
-(void)dealTheFunctionData:(WQMessageObj *)messageObj {
    if (self.isShowKeyboard) {
        self.messageInputView.TextViewInput.text = nil;
        [self textViewDidChange:self.messageInputView.TextViewInput];
    }
    
    [self.chatModel addMessageFrameWithMessageObj:messageObj];
    
    [self.tableView reloadData];
    
    [self scrollToBottomAnimated:YES];
    
    self.tempMessageDic = nil;
}

#pragma mark - 播放语音 
static WQMessageCell *tempCell = nil;
-(void)playVoiceWithCell:(WQMessageCell *)cell sound:(NSString *)soundStr {
    if (!self.isPlaying) {
        tempCell = cell;
        [WQPlayerManager sharedManager].delegate = nil;
        self.isPlaying = YES;
        
        [[WQPlayerManager sharedManager] playAudioWithFileName:soundStr delegate:self];
        
        [cell startPlay];
    }else {
        self.isPlaying = NO;
        [WQPlayerManager sharedManager].delegate = nil;
        [[WQPlayerManager sharedManager] stopPlaying];
        [tempCell stopPlay];
        
        if ([tempCell isEqual:cell]) {
            tempCell = nil;
        }else {
            tempCell = cell;
            self.isPlaying = YES;
            [[WQPlayerManager sharedManager] playAudioWithFileName:soundStr delegate:self];
            
            [cell startPlay];
        }
    }
}
- (void)playingStoped {
    self.isPlaying = NO;
    [tempCell stopPlay];
    tempCell = nil;
}
@end
