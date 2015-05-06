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
    return  @{@"userId": mts_key(customerId),
              @"userName": mts_key(customerName),
              @"userPhone": mts_key(customerPhone),
              @"userImg": mts_key(customerHeader),
              @"userDegree": mts_key(customerDegree),
              @"storeValidate": mts_key(customerCode),
              @"customerArea": mts_key(customerArea),
              @"customerRemark": mts_key(customerRemark),
              @"customerShield": mts_key(customerShield),
              
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
