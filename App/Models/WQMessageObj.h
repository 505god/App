//
//  WQMessageObj.h
//  App
//
//  Created by 邱成西 on 15/4/29.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WQMessageObj : NSObject

///消息来自
@property (nonatomic, assign) NSInteger messageFrom;
///消息发送到
@property (nonatomic, assign) NSInteger messageTo;
///消息内容
@property (nonatomic, strong) NSString *messageContent;
///消息日期
@property (nonatomic, strong) NSString *messageDate;
///消息图片
@property (nonatomic, strong) UIImage *messageImg;
///消息类型
@property (nonatomic, assign) MessageType messageType;
///消息语音
@property (nonatomic, strong) NSString *messageVoicePath;
///消息来源
@property (nonatomic, assign) MessageFrom fromType;
///显示时间
@property (nonatomic, assign) NSInteger showDateLabel;

+(WQMessageObj *)messageFromDictionary:(NSDictionary *)aDic;

- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end;
@end
