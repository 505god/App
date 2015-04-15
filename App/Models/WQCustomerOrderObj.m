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
              @"proImg": mts_key(proImg),
              @"proName": mts_key(proName),
              @"proNumber": mts_key(proNumber),
              @"orderTime": mts_key(orderTime),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}
@end
