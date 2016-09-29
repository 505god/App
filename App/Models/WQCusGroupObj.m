//
//  WQCusGroupObj.m
//  App
//
//  Created by 邱成西 on 15/6/11.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCusGroupObj.h"
#import "WQCustomerObj.h"
@implementation WQCusGroupObj

+ (NSDictionary*)mts_mapping {
    return  @{@"groupId": mts_key(cusGroupId),
              @"groupCount": mts_key(cusGroupCount),
              @"groupList": mts_key(cusArray)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(cusArray) : WQCustomerObj.class,
             };
}
@end
