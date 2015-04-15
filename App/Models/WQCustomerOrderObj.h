//
//  WQCustomerOrderObj.h
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQCustomerOrderObj : NSObject

@property (nonatomic, assign) NSInteger orderId;
///产品图片
@property (nonatomic, strong) NSString *proImg;
///产品名称
@property (nonatomic, strong) NSString *proName;
///产品数量
@property (nonatomic, assign) NSInteger proNumber;

@property (nonatomic, strong) NSString *orderTime;
@end
