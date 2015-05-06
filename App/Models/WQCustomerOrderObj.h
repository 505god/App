//
//  WQCustomerOrderObj.h
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQCustomerOrderObj : NSObject

@property (nonatomic, strong) NSString *orderId;
@property (nonatomic, strong) NSString *orderTime;
///订单价格
@property (nonatomic, assign) CGFloat orderPrice;
///订单号
@property (nonatomic, strong) NSString *orderCode;
///订单状态
@property (nonatomic, assign) NSInteger orderStatus;

@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic, assign) NSInteger customerId;
@property (nonatomic, strong) NSString *customerName;
@end
