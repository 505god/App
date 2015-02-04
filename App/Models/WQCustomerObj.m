//
//  WQCustomerObj.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerObj.h"

@implementation WQCustomerObj

+ (NSDictionary*)mts_mapping {
    return  @{@"customerId": mts_key(customerId),
              @"customerName": mts_key(customerName),
              @"customerPhone": mts_key(customerPhone),
              @"customerHeader": mts_key(customerHeader),
              @"customerDegree": mts_key(customerDegree),
              @"customerCode": mts_key(customerCode),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+(WQCustomerObj *)returnCustomerWithDic:(NSDictionary *)aDic {
    WQCustomerObj *customer = [[WQCustomerObj alloc]init];
    
    [customer mts_setValuesForKeysWithDictionary:aDic];
    return customer;
}
@end
