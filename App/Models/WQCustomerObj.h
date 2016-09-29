//
//  WQCustomerObj.h
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

///客户属性

@interface WQCustomerObj : NSObject
///客户id
@property (nonatomic, assign) NSInteger customerId;
///客户昵称
@property (nonatomic, strong) NSString *customerName;
///客户电话
@property (nonatomic, strong) NSString *customerPhone;//+1
///客户头像
@property (nonatomic, strong) NSString *customerHeader;
///客户地区
@property (nonatomic, strong) NSString *customerArea;//+1
///客户等级
@property (nonatomic, assign) NSInteger customerDegree;
///客户邀请码
@property (nonatomic, strong) NSString *customerCode;//+1

///客户屏蔽
@property (nonatomic, assign) BOOL customerShield;

///客户注册
@property (nonatomic, assign) BOOL customerResign;

@property (nonatomic, assign) NSInteger regsinRedPoint;
@end
