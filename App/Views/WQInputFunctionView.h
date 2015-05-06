//
//  WQInputFunctionView.h
//  App
//
//  Created by 邱成西 on 15/4/29.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WQMessageTextView.h"

@protocol WQInputFunctionViewDelegate;

@interface WQInputFunctionView : UIView

@property (nonatomic, assign) id<WQInputFunctionViewDelegate>delegate;

///发送
@property (nonatomic, strong) UIButton *btnSendMessage;
///语音
@property (nonatomic, strong) UIButton *btnChangeVoiceState;
///录音
@property (nonatomic, strong) UIButton *btnVoiceRecord;
///文本
@property (nonatomic, strong) WQMessageTextView *TextViewInput;

@property (nonatomic, assign) BOOL isAbleToSendTextMessage;

@property (nonatomic, strong) UIViewController *superVC;

- (id)initWithSuperVC:(UIViewController *)superVC;

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto;


#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

+ (CGFloat)textViewLineHeight;

+ (CGFloat)maxLines;

+ (CGFloat)maxHeight;
@end


@protocol WQInputFunctionViewDelegate <NSObject>

// text
- (void)WQInputFunctionView:(WQInputFunctionView *)funcView sendMessage:(NSString *)message;

// image
- (void)WQInputFunctionView:(WQInputFunctionView *)funcView sendPicture:(UIImage *)image;

// audio
- (void)WQInputFunctionView:(WQInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second;

@end