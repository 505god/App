//
//  WQColorObj.m
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQColorObj.h"

@implementation WQColorObj

+ (NSDictionary*)mts_mapping {
    return  @{@"colorId": mts_key(colorId),
              @"colorName": mts_key(colorName),
              @"productCount": mts_key(productCount),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+(WQColorObj *)returnColorWithDic:(NSDictionary *)aDic {
    WQColorObj *color = [[WQColorObj alloc]init];
    
    [color mts_setValuesForKeysWithDictionary:aDic];

    return color;
}

@end
