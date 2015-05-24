//
//  WQOrderSearchObj.m
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQOrderSearchObj.h"
#import "WQCustomerOrderObj.h"

@implementation WQOrderSearchObj

+ (NSDictionary*)mts_mapping {
    return  @{@"payArray": mts_key(payArray),
              @"deliveryArray": mts_key(deliveryArray),
              @"receiveArray": mts_key(receiveArray),
              @"finishArray": mts_key(finishArray),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(payArray) : WQCustomerOrderObj.class,
             mts_key(deliveryArray) : WQCustomerOrderObj.class,
             mts_key(receiveArray) : WQCustomerOrderObj.class,
             mts_key(finishArray) : WQCustomerOrderObj.class,
             };
}

@end
