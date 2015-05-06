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

@interface WQInputFunctionView ()<UITextViewDelegate,WQRecorderManagerDelegate,JKImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL isbeginVoiceRecord;

@property (nonatomic, strong) UILabel *placeHold;

@end

@implementation WQInputFunctionView

- (id)initWithSuperVC:(UIViewController *)superVC
{
    self.superVC = superVC;
    CGRect frame = CGRectMake(0, Main_Screen_Height-40, Main_Screen_Width, 40);
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);
        self.opaque = YES;
        self.userInteractionEnabled = YES;
        
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-40, 5, 30, 30);
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(5, 5, 30, 30);
        self.isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];
        
        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.frame = CGRectMake(70, 5, Main_Screen_Width-70*2, 30);
        self.btnVoiceRecord.autoresizingMask = (UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin);
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"chat_message_back"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitle:@"Hold to Talk" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"Release to Send" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.TextViewInput = [[WQMessageTextView alloc]initWithFrame:CGRectMake(45, 5, Main_Screen_Width-2*45, 30)];
        self.TextViewInput.backgroundColor = [UIColor clearColor];
        self.TextViewInput.layer.cornerRadius = 6.0f;
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderColor = [UIColor colorWithWhite:0.8f alpha:1.0f].CGColor;
        self.TextViewInput.layer.borderWidth = 0.65f;
        [self addSubview:self.TextViewInput];
        
        //输入框的提示语
        self.placeHold = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 30)];
        self.placeHold.text = @"Input the contents here";
        self.placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.TextViewInput addSubview:self.placeHold];
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        //添加通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewDidEndEditing:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}
#pragma mark - 录音touch事件
//开始录音
- (void)beginRecordVoice:(UIButton *)button {
    [WQRecorderManager sharedManager].delegate = self;
    [[WQRecorderManager sharedManager] startRecording];
    
    [WQVoiceProgressHud show];
}

- (void)endRecordVoice:(UIButton *)button{
    [[WQRecorderManager sharedManager] stopRecording];
}

- (void)cancelRecordVoice:(UIButton *)button{
    [WQVoiceProgressHud dismissWithError:@"Cancel"];
}

- (void)RemindDragExit:(UIButton *)button{
    [WQVoiceProgressHud changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button{
    [WQVoiceProgressHud changeSubTitle:@"Slide up to cancel"];
}


#pragma mark - RecordingDelegate
- (void)recordingFinishedWithFileName:(NSString *)filePath voiceName:(NSString *)name time:(NSTimeInterval)interval {
    
//    [self.delegate WQInputFunctionView:self sendVoice:voiceData time:self.playTime+1];
    [WQVoiceProgressHud dismissWithSuccess:@"Success"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}
- (void)recordingTimeout {
//    self.isRecording = NO;
//    
//    if (self.vrbDelegate &&[self.vrbDelegate respondsToSelector:@selector(recorderFailed:)]) {
//        [self.vrbDelegate recorderFailed:@"录音超时"];
//    }
}
- (void)recordingStopped {
//    self.isRecording = NO;
}
- (void)recordingFailed:(NSString *)failureInfoString {
    [WQVoiceProgressHud dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}
- (void)levelMeterChanged:(float)levelMeter {
//    if (self.isRecording){
//        [self.recorderView updateMetersByAvgPower:levelMeter];
//    }
}


//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
    self.isbeginVoiceRecord = !self.isbeginVoiceRecord;
    if (self.isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_ipunt_message"] forState:UIControlStateNormal];
        [self.TextViewInput resignFirstResponder];
    }else{
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        [self.TextViewInput becomeFirstResponder];
    }
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender
{
    if (self.isAbleToSendTextMessage) {
        NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate WQInputFunctionView:self sendMessage:resultStr];
    }
    else{
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
}


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.placeHold.hidden = self.TextViewInput.text.length > 0;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    self.placeHold.hidden = textView.text.length>0;
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    self.isAbleToSendTextMessage = !isPhoto;
    [self.btnSendMessage setTitle:isPhoto?@"":@"send" forState:UIControlStateNormal];
    self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
    UIImage *image = [UIImage imageNamed:isPhoto?@"Chat_take_picture":@"chat_send_message"];
    [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.placeHold.hidden = self.TextViewInput.text.length > 0;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - JKImagePickerControllerDelegate

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets{
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
    
    self.TextViewInput.scrollEnabled = (numLines >= 4);
    
    if(numLines >= 6) {
        CGPoint bottomOffset = CGPointMake(0.0f, self.TextViewInput.contentSize.height - self.TextViewInput.bounds.size.height);
        [self.TextViewInput setContentOffset:bottomOffset animated:YES];
    }
}

+ (CGFloat)textViewLineHeight
{
    return 36.0f; // for fontSize 16.0f
}

+ (CGFloat)maxLines
{
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 4.0f : 8.0f;
}

+ (CGFloat)maxHeight
{
    return ([WQInputFunctionView maxLines] + 1.0f) * [WQInputFunctionView textViewLineHeight];
}

@end
