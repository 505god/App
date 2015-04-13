//
//  WQClassObj.m
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassObj.h"

#import "WQClassLevelObj.h"

@implementation WQClassObj

+ (NSDictionary*)mts_mapping {
    return  @{@"classAId": mts_key(classId),
              @"classAName": mts_key(className),
              @"classBCount": mts_key(levelClassCount),
              @"classBList": mts_key(levelClassList)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+ (NSDictionary*)mts_arrayClassMapping
{
    return @{mts_key(levelClassList) : WQClassLevelObj.class,
             };
}
@end
