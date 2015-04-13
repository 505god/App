
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

//聊天-------信息类型
typedef enum{
    WQMessageTypeText = 0,    //文字
    WQMessageTypeImage = 1,   //图片
    WQMessageTypeVoice =2,    //语音
    WQMessageTypeMap =3,    //地图
    WQMessageTypeOrder =4,    //订单
}WQMessageType;

//聊天-------信息来源类型
typedef enum{
    WQMessageCellTypeMe = 0,      //我
    WQMessageCellTypeOther = 1,   //其他人
}WQMessageCellType;


//聊天-------键盘输入源
typedef enum{
    WQKeyboardTypeSystem = 0, //默认
    WQKeyboardTypeFace = 1,   //表情
    WQKeyboardTypePhoto = 2,  //图片
    WQKeyboardTypeVoice = 3,  //语音
    WQKeyboardTypeNone = 4,   //没有
}WQKeyboardType;

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

