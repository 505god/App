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
    return  @{@"dealArray": mts_key(dealArray),
              @"payArray": mts_key(payArray),
              @"finishArray": mts_key(finishArray),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(dealArray) : WQCustomerOrderObj.class,
             mts_key(payArray) : WQCustomerOrderObj.class,
             mts_key(finishArray) : WQCustomerOrderObj.class,
             };
}

@end
