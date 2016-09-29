//
//  WQMessageFrame.m
//  App
//
//  Created by 邱成西 on 15/5/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMessageFrame.h"

@implementation WQMessageFrame

-(void)setMessageObj:(WQMessageObj *)messageObj {
    _messageObj = messageObj;
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    
    // 1、计算时间的位置
    if (messageObj.showDateLabel) {
        CGFloat timeY = ChatMargin;
        
        CGSize timeSize = [messageObj.messageShowDate boundingRectWithSize:CGSizeMake(300, 100) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:ChatTimeFont,NSFontAttributeName, nil] context:nil].size;
        
        CGFloat timeX = (screenW - timeSize.width) / 2;
        _timeF = CGRectMake(timeX, timeY, timeSize.width + ChatTimeMarginW, timeSize.height + ChatTimeMarginH);
    }
    
    // 2、计算头像位置
    CGFloat iconX = ChatMargin;
    if (messageObj.fromType == WQMessageFromMe) {
        iconX = screenW - ChatMargin - ChatIconWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + ChatMargin;
    _iconF = CGRectMake(iconX, iconY, ChatIconWH, ChatIconWH);
    
    // 3、计算ID位置
    _nameF = CGRectMake(iconX, iconY+ChatIconWH, ChatIconWH, 20);
    
    // 4、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF)+ChatMargin;
    CGFloat contentY = iconY;
    
    //根据种类分
    CGSize contentSize;
    switch (messageObj.messageType) {
        case WQMessageTypeText:
            contentSize = [messageObj.messageContent boundingRectWithSize:CGSizeMake(ChatContentW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:ChatContentFont,NSFontAttributeName, nil] context:nil].size;
            break;
        case WQMessageTypePicture:
            contentSize = CGSizeMake(ChatPicWH, ChatPicWH-20);
            break;
        case WQMessageTypeVoice:
            contentSize = CGSizeMake(60, 20);
            break;
        default:
            break;
    }
    if (messageObj.fromType == WQMessageFromMe) {
        contentX = iconX - contentSize.width - ChatContentLeft - ChatContentRight - ChatMargin;
    }
    _contentF = CGRectMake(contentX, contentY, contentSize.width + ChatContentLeft + ChatContentRight, contentSize.height + ChatContentTop + ChatContentBottom);
    
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_nameF))  + ChatMargin;
}

-(void)setCustomerObj:(WQCustomerObj *)customerObj {
    _customerObj = customerObj;
}

@end
