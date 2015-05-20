//
//  WQInputFunctionView.m
//  App
//
//  Created by 邱成西 on 15/4/29.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQInputFunctionView.h"
#import "WQVoiceProgressHud.h"
#import "WQRecorderManager.h"
#import "NSString+JSMessagesView.h"
#import "JKImagePickerController.h"

#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))

@interface WQInputFunctionView ()<WQRecorderManagerDelegate,JKImagePickerControllerDelegate>

///判断按钮状态 文字、语音切换
@property (nonatomic, assign) BOOL isbeginVoiceRecord;
///判断是否在录音
@property (nonatomic, assign) BOOL isRecording;
@end

@implementation WQInputFunctionView

-(void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
    self.opaque = YES;
    self.userInteractionEnabled = YES;
    
    //图片
    self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-40, 7, 30, 30);
    [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
    [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnSendMessage];
    
    //改变状态（语音、文字）
    self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnChangeVoiceState.frame = CGRectMake(5, 7, 30, 30);
    self.isbeginVoiceRecord = NO;
    [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
    [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.btnChangeVoiceState];
    
    //语音录入键
    self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnVoiceRecord.frame = CGRectMake(70, 7, Main_Screen_Width-70*2, 30);
    self.btnVoiceRecord.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
    self.btnVoiceRecord.hidden = YES;
    [self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
    [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self.btnVoiceRecord setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    [self.btnVoiceRecord setTitle:NSLocalizedString(@"HoldtoTalk", @"") forState:UIControlStateNormal];
    [self.btnVoiceRecord setTitle:NSLocalizedString(@"ReleasetoSend", @"") forState:UIControlStateHighlighted];
    [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
    [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
    [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
    [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [self addSubview:self.btnVoiceRecord];
    
    
    //输入框
    self.TextViewInput = [[WQMessageTextView alloc]initWithFrame:CGRectZero];
    self.TextViewInput.frame = CGRectMake(45, 4, Main_Screen_Width-2*45, [WQInputFunctionView textViewLineHeight]);
    self.TextViewInput.placeHolder = NSLocalizedString(@"NewMessage", @"");
    self.TextViewInput.backgroundColor = [UIColor clearColor];
    self.TextViewInput.layer.cornerRadius = 6.0f;
    self.TextViewInput.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
    self.TextViewInput.layer.borderWidth = 0.65f;
    [self addSubview:self.TextViewInput];
}

- (instancetype)initWithFrame:(CGRect)frame
                      superVC:(UIViewController *)superVC
                     delegate:(id<UITextViewDelegate, WQDismissiveTextViewDelegate>)delegate
         panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer {
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
        
        self.superVC = superVC;
        self.TextViewInput.delegate = delegate;
        self.TextViewInput.keyboardDelegate = delegate;
        self.TextViewInput.dismissivePanGestureRecognizer = panGestureRecognizer;
    }
    return self;
}

#pragma mark - 录音touch事件
//开始录音
- (void)beginRecordVoice:(UIButton *)button {
    self.isRecording = YES;
    [WQRecorderManager sharedManager].delegate = self;
    [[WQRecorderManager sharedManager] startRecording];
    
    [WQVoiceProgressHud show];
}
//录音完成－－发送
- (void)endRecordVoice:(UIButton *)button{
    [[WQRecorderManager sharedManager] stopRecording];
}
//取消录音
- (void)cancelRecordVoice:(UIButton *)button{
    self.isRecording = YES;
    [WQRecorderManager sharedManager].delegate = nil;
    [[WQRecorderManager sharedManager] stopRecording];
    [WQVoiceProgressHud dismissWithError:NSLocalizedString(@"Cancel", @"")];
}

- (void)RemindDragExit:(UIButton *)button{
    [WQVoiceProgressHud changeSubTitle:NSLocalizedString(@"Releasetocancel", @"")];
}

- (void)RemindDragEnter:(UIButton *)button{
    [WQVoiceProgressHud changeSubTitle:NSLocalizedString(@"Slideuptocancel", @"")];
}

#pragma mark - RecordingDelegate
- (void)recordingFinishedWithFileName:(NSString *)filePath voiceName:(NSString *)name time:(NSTimeInterval)interval {
    
    if (self.isRecording) {
        self.isRecording = NO;
        
        if (interval-1<0.000001) {
            [WQVoiceProgressHud dismissWithError:NSLocalizedString(@"Tooshort", @"")];
        }else {
            [WQVoiceProgressHud dismissWithSuccess:NSLocalizedString(@"Success", @"")];
            
            [self.delegate WQInputFunctionView:self fileName:filePath name:name time:interval];

            
            //缓冲消失时间 (最好有block回调消失完成)
            self.btnVoiceRecord.enabled = NO;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.btnVoiceRecord.enabled = YES;
            });
        }
    }
}
- (void)recordingTimeout {
    self.isRecording = NO;
    [WQRecorderManager sharedManager].delegate = nil;
    [[WQRecorderManager sharedManager] stopRecording];
    [WQVoiceProgressHud dismissWithError:NSLocalizedString(@"recordError", @"")];
}
- (void)recordingStopped {
}
- (void)recordingFailed:(NSString *)failureInfoString {
    self.isRecording = NO;
    [WQRecorderManager sharedManager].delegate = nil;
    [[WQRecorderManager sharedManager] stopRecording];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}
//音量
- (void)levelMeterChanged:(float)levelMeter {
    
}


//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
    self.isbeginVoiceRecord = !self.isbeginVoiceRecord;
    
    if (self.isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        
        [self.delegate beginRecord];
        
        [self.TextViewInput resignFirstResponder];
    }else{
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        [self.TextViewInput becomeFirstResponder];
    }
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender {
    [self.TextViewInput resignFirstResponder];
    
    __block JKImagePickerController *imagePicker = [[JKImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsMultipleSelection = NO;
    imagePicker.minimumNumberOfSelection = 1;
    imagePicker.maximumNumberOfSelection = 1;
    [self.superVC presentViewController:imagePicker animated:YES completion:^{
        SafeRelease(imagePicker);
    }];
}


#pragma mark - TextViewDelegate
-(void)dealloc{
    
}

#pragma mark - JKImagePickerControllerDelegate

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets{
    
    AppDelegate *appDel = [AppDelegate shareIntance];
    [MBProgressHUD showHUDAddedTo:appDel.window.rootViewController.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    JKAssets *asset = (JKAssets *)assets[0];
    __block UIImage *image = nil;
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            UIImage *tempImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            image = [Utility dealImageData:tempImg];//图片处理
            SafeRelease(tempImg);
        }
    } failureBlock:^(NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"PhotoSelectedError", @"")];
    }];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
            [weakSelf.delegate WQInputFunctionView:self sendPicture:image];
        });
    }];
}
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}


#pragma mark - Message input view

- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight
{
    CGRect prevFrame = self.TextViewInput.frame;
    
    
    NSInteger numLines = MAX([self.TextViewInput numberOfLinesOfText],
                       [self.TextViewInput.text js_numberOfLines]);

    
    self.TextViewInput.frame = CGRectMake(prevFrame.origin.x,
                                     prevFrame.origin.y,
                                     prevFrame.size.width,
                                     prevFrame.size.height + changeInHeight);
    
    self.TextViewInput.contentInset = UIEdgeInsetsMake((numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f,
                                                  (numLines >= 6 ? 4.0f : 0.0f),
                                                  0.0f);
    
    self.TextViewInput.scrollEnabled = (numLines >= 3);
    
    if(numLines >= 6) {
        CGFloat y = self.TextViewInput.contentSize.height - self.TextViewInput.bounds.size.height;
        if (y<0) {
            y=6;
        }
        CGPoint bottomOffset = CGPointMake(0.0f, y);
        [self.TextViewInput setContentOffset:bottomOffset animated:YES];
    }
}

+ (CGFloat)textViewLineHeight
{
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return 3.0f;
}

+ (CGFloat)maxHeight
{
    return ([WQInputFunctionView maxLines] + 1.0f) * [WQInputFunctionView textViewLineHeight];
}

@end
