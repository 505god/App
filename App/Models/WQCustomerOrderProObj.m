//
//  WQCustomerOrderProObj.m
//  App
//
//  Created by 邱成西 on 15/4/16.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerOrderProObj.h"

@implementation WQCustomerOrderProObj

+ (NSDictionary*)mts_mapping {
    return  @{@"proId": mts_key(proId),
              @"proImg": mts_key(proImg),
              @"proName": mts_key(proName),
              @"proPrice": mts_key(proPrice),
              @"proNumber": mts_key(proNumber),
              @"proSaleType": mts_key(proSaleType),
              @"proDiscount": mts_key(proDiscount),
              @"proReducePrice": mts_key(proReducePrice),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
