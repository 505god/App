//
//  WQDataShare.h
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WQUserObj.h"
#import "WQCustomerObj.h"

typedef void(^CompleteBlock)(NSArray *array);

@interface WQDataShare : NSObject {
    CompleteBlock completeBlock;
}

@property (nonatomic, strong) AppDelegate *appDel;

//区分6、7statusBar高度
@property (nonatomic, assign) NSInteger statusHeight;

@property (nonatomic, strong) WQUserObj *userObj;
///xmpp注册
@property (nonatomic, assign) BOOL idRegister;//1＝注册，0=未注册

@property (nonatomic, assign) BOOL isInMessageView;
///当前聊天对象的JID
@property (nonatomic, strong) NSString *otherJID;

///聊天输入框获取键盘语言
@property (nonatomic, strong) NSString *getLanguage;

@property (nonatomic, strong) NSMutableArray *messageArray;

//分类
@property (nonatomic, strong) NSMutableArray *classArray;
//颜色
@property (nonatomic, strong) NSMutableArray *colorArray;
//尺码
@property (nonatomic, strong) NSMutableArray *sizeArray;

//客户户列表
@property (nonatomic, strong) NSMutableArray *customerArray;//用于搜索

//判断是否是点击推送进来的
@property (nonatomic, assign) BOOL isPushing;
@property (nonatomic, assign) WQPushType pushType;

+ (WQDataShare *)sharedService;


-(void)sortCustomers:(NSArray *)customers CompleteBlock:(CompleteBlock)complet;

@end
