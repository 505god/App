//
//  WQSizeObj.m
//  App
//
//  Created by 邱成西 on 15/2/12.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSizeObj.h"

@implementation WQSizeObj

+ (NSDictionary*)mts_mapping {
    return  @{@"sizeId": mts_key(sizeId),
              @"sizeName": mts_key(sizeName),
              @"productSize": mts_key(productCount),
              
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
