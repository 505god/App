//
//  WQPricelineObj.h
//  App
//
//  Created by 邱成西 on 15/4/21.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQPricelineObj : NSObject

///时间
@property (nonatomic, strong) NSString *time;

///成交额
@property (nonatomic, strong) NSString *price;

///订单量
@property (nonatomic, assign) NSInteger orderCount;

@end
