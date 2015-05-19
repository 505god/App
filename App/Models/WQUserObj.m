//
//  WQUserObj.m
//  App
//
//  Created by 邱成西 on 15/4/22.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQUserObj.h"


@implementation WQUserObj

+ (NSDictionary*)mts_mapping {
    return  @{@"storeId": mts_key(userId),
              @"storeName": mts_key(userName),
              @"storeImg": mts_key(userHead),
              @"coinType": mts_key(moneyType),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
