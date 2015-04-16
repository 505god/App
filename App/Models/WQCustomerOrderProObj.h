//
//  WQCustomerOrderProObj.h
//  App
//
//  Created by 邱成西 on 15/4/16.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQCustomerOrderProObj : NSObject

@property (nonatomic, assign) NSInteger proId;

@property (nonatomic, strong) NSString *proImg;
@property (nonatomic, strong) NSString *proName;

@property (nonatomic, assign) CGFloat proPrice;
@property (nonatomic, assign) NSInteger proNumber;

///产品优惠  0=无  1=折扣  2＝优惠价格
@property (nonatomic, assign) NSInteger proSaleType;
///产品折扣
@property (nonatomic, assign) CGFloat proDiscount;
///产品优惠的价格
@property (nonatomic, assign) CGFloat proReducePrice;

@end
