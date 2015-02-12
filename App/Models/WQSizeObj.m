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
              @"sizeNumber": mts_key(sizeNumber),
              
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+(WQSizeObj *)returnSizeWithDic:(NSDictionary *)aDic {
    WQSizeObj *size = [[WQSizeObj alloc]init];
    
    [size mts_setValuesForKeysWithDictionary:aDic];
    
    return size;
}

@end
