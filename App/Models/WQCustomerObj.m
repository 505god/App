//
//  WQCustomerObj.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerObj.h"

@implementation WQCustomerObj

+ (NSDictionary*)mts_mapping {
    return  @{@"customerId": mts_key(customerId),
              @"customerName": mts_key(customerName),
              @"customerPhone": mts_key(customerPhone),
              @"customerHeader": mts_key(customerHeader),
              @"customerDegree": mts_key(customerDegree),
              @"customerCode": mts_key(customerCode),
              @"customerArea": mts_key(customerArea),
              @"customerRemark": mts_key(customerRemark),
              @"customerShield": mts_key(customerShield),
              
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
