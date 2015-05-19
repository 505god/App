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

              @"customerId": mts_key(customerId),
              @"customerName": mts_key(customerName),
              
              @"proId": mts_key(productId),
              @"proImg": mts_key(productImg),
              @"proColor": mts_key(productColor),
              @"proSize": mts_key(productSize),
              @"proName": mts_key(productName),
              @"proPrice": mts_key(productPrice),
              @"proNumber": mts_key(productNumber),
              @"proSaleType": mts_key(productSaleType),
              @"proDiscount": mts_key(productDiscount),
              @"proReducePrice": mts_key(productReducePrice),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
