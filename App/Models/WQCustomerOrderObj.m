//
//  WQCustomerOrderObj.m
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerOrderObj.h"
#import "WQCustomerOrderProObj.h"

@implementation WQCustomerOrderObj
+ (NSDictionary*)mts_mapping {
    return  @{@"orderId": mts_key(orderId),
              @"orderTime": mts_key(orderTime),
              @"orderPrice": mts_key(orderPrice),
              @"orderCode": mts_key(orderCode),
              @"orderStatus": mts_key(orderStatus),
              @"productList": mts_key(productList),
              @"customerId": mts_key(customerId),
              @"customerName": mts_key(customerName),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(productList) : WQCustomerOrderProObj.class,
             };
}
@end
