//
//  WQPricelineObj.m
//  App
//
//  Created by 邱成西 on 15/4/21.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQPricelineObj.h"

@implementation WQPricelineObj

+ (NSDictionary*)mts_mapping {
    return  @{@"time": mts_key(time),
              @"price": mts_key(price),
              @"orderCount": mts_key(orderCount),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
