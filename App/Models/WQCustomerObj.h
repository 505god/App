//
//  WQCustomerObj.h
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

//客户属性

@interface WQCustomerObj : NSObject

@property (nonatomic, assign) NSInteger customerId;

@property (nonatomic, strong) NSString *customerName;

@property (nonatomic, strong) NSString *customerPhone;

@property (nonatomic, strong) NSString *customerHeader;

//客户等级
@property (nonatomic, assign) NSInteger customerDegree;

//邀请码
@property (nonatomic, strong) NSString *customerCode;

+(WQCustomerObj *)returnCustomerWithDic:(NSDictionary *)aDic;
@end
