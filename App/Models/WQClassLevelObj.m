//
//  WQClassLevelObj.m
//  App
//
//  Created by 邱成西 on 15/4/11.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassLevelObj.h"

@implementation WQClassLevelObj

+ (NSDictionary*)mts_mapping {
    return  @{@"classBId": mts_key(levelClassId),
              @"classBName": mts_key(levelClassName),
              @"productCount": mts_key(productCount)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
