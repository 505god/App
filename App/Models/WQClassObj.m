//
//  WQClassObj.m
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassObj.h"

#import "WQProductObj.h"

@implementation WQClassObj

+ (NSDictionary*)mts_mapping {
    return  @{@"classId": mts_key(classId),
              @"className": mts_key(className),
              @"productCount": mts_key(productCount),
              @"productList": mts_key(productList)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(productList) : WQProductObj.class,
             };
}
@end
