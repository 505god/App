//
//  WQProductObj.m
//  App
//
//  Created by 邱成西 on 15/2/8.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductObj.h"

@implementation WQProductObj

+ (NSDictionary*)mts_mapping {
    return  @{@"productId": mts_key(productId),
              @"productName": mts_key(productName),
              @"productPrice": mts_key(productPrice),
              @"productSaleCount": mts_key(productSaleCount),
              @"productImage": mts_key(productImage),
              @"productViewCount": mts_key(productViewCount),
              @"productIsHot": mts_key(productIsHot),
              @"productIsSale": mts_key(productIsSale)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
