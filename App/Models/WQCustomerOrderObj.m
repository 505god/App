//
//  WQCustomerOrderObj.m
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerOrderObj.h"

@implementation WQCustomerOrderObj
+ (NSDictionary*)mts_mapping {
    return  @{@"orderId": mts_key(orderId),
              @"orderTime": mts_key(orderTime),
              @"orderPrice": mts_key(orderPrice),
              @"orderStatus": mts_key(orderStatus),

              @"userId": mts_key(customerId),
              @"userName": mts_key(customerName),
              
              @"productId": mts_key(productId),
              @"productImg": mts_key(productImg),
              @"detailColorName": mts_key(productColor),
              @"detailSizeName": mts_key(productSize),
              @"productName": mts_key(productName),
              @"detailMoney": mts_key(productPrice),
              @"detailNum": mts_key(productNumber),
              @"proOnSaleType": mts_key(productSaleType),
              @"disCountPrice": mts_key(productDiscount),
              @"onSalePrice": mts_key(productReducePrice),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
