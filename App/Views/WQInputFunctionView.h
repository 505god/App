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

//图片
@property (nonatomic, strong) UIButton *btnSendMessage;
///语音
@property (nonatomic, strong) UIButton *btnChangeVoiceState;
///录音
@property (nonatomic, strong) UIButton *btnVoiceRecord;
///文本
@property (nonatomic, strong) WQMessageTextView *TextViewInput;

@property (nonatomic, strong) UIViewController *superVC;

- (instancetype)initWithFrame:(CGRect)frame
                      superVC:(UIViewController *)superVC
                     delegate:(id<UITextViewDelegate, WQDismissiveTextViewDelegate>)delegate
         panGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer;

#pragma mark - Message input view
- (void)adjustTextViewHeightBy:(CGFloat)changeInHeight;

+ (CGFloat)textViewLineHeight;

+ (CGFloat)maxLines;

+ (CGFloat)maxHeight;
@end


@protocol WQInputFunctionViewDelegate <NSObject>

// image
- (void)WQInputFunctionView:(WQInputFunctionView *)funcView sendPicture:(UIImage *)image;

// audio
- (void)WQInputFunctionView:(WQInputFunctionView *)funcView fileName:(NSString *)filePath name:(NSString *)name time:(NSTimeInterval)interval;
//record
-(void)beginRecord;
@end