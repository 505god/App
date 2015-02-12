//
//  Utility.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  公用类方法
 */



//我的订单-------订单类型
typedef enum{
    RPOrderTypeAll = 0,     //全部
    RPOrderTypeDeal = 1,    //交易单
    RPOrderTypeNoPay = 2,   //未付款
    RPOrderTypeNoUse=3,     //未使用
    RPOrderTypeRefund=4,     //退款
    RPOrderTypeFinish=6,     //已完成
}RPOrderType;

//聊天-------信息类型
typedef enum{
    RPMessageTypeText = 0,    //文字
    RPMessageTypeImage = 1,   //图片
    RPMessageTypeVoice =2,    //语音
    RPMessageTypeMap =3,    //地图
    RPMessageTypeOrder =4,    //订单
}RPMessageType;

//聊天-------信息来源类型
typedef enum{
    RPMessageCellTypeMe = 0,      //我
    RPMessageCellTypeOther = 1,   //其他人
}RPMessageCellType;


//聊天-------键盘输入源
typedef enum{
    RPKeyboardTypeSystem = 0, //默认
    RPKeyboardTypeFace = 1,   //表情
    RPKeyboardTypePhoto = 2,  //图片
    RPKeyboardTypeVoice = 3,  //语音
    RPKeyboardTypeNone = 4,   //没有
}RPKeyboardType;


#import "WQPopView.h"

@interface Utility : NSObject


+ (NSString *)getNowDateFromatAnDate;

+ (void)roundView: (UIView *) view;

+(void)setLeftRoundcornerWithView:(UIView *)view;

+(void)setRightRoundcornerWithView:(UIView *)view;

+ (void)errorAlert:(NSString *)message view:(UIView *)view;

+(void)animationWithView:(UIView *)view image:(NSString *)image selectedImage:(NSString *)selectedImage type:(int)type;

+(BOOL)checkString:(NSString *)string;


+(NSDictionary *)returnDicByPath:(NSString *)jsonPath;
@end
