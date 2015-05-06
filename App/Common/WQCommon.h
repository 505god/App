
//
//  WQCommon.h
//  App
//
//  Created by 邱成西 on 15/4/1.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

//我的订单-------订单类型
typedef enum{
    WQOrderTypeAll = 0,     //全部
    WQOrderTypeDeal = 1,    //交易单
    WQOrderTypeNoPay = 2,   //未付款
    WQOrderTypeNoUse=3,     //未使用
    WQOrderTypeRefund=4,     //退款
    WQOrderTypeFinish=6,     //已完成
}WQOrderType;

//语言-------系统当前语言
typedef enum{
    WQLanguageChinese = 0,   //汉语
    WQLanguageEnglish = 1,   //英语
    WQLanguageItalian = 2,   //意大利语
}WQLanguageType;

//货币-------
typedef enum{
    WQCoinCNY = 0,           //人民币
    WQCoinUSD = 1,        //美元
    WQCoinEUR = 2,          //欧元
}WQCoinType;


typedef NS_ENUM(NSInteger, MessageType) {
    WQMessageTypeText     = 0 , // 文字
    WQMessageTypePicture  = 1 , // 图片
    WQMessageTypeVoice    = 2   // 语音
};


typedef NS_ENUM(NSInteger, MessageFrom) {
    WQMessageFromMe    = 0,   // 自己发的
    WQMessageFromOther = 1    // 别人发得
};