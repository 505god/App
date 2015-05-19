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
    return  @{
              @"productId": mts_key(proId),
              @"productImg": mts_key(proImage),
              @"productName": mts_key(proName),
              @"proPriceBetween": mts_key(proPrice),
              @"productStock": mts_key(proStock),
              @"moneyType": mts_key(moneyType),
              @"productSaleCount": mts_key(proSaleCount),
              @"productViewCount": mts_key(proViewCount),
              @"productIsHot": mts_key(proIsHot),
              @"productIsSale": mts_key(proIsSale),
              @"proImgArray": mts_key(proImgArray),
              @"type": mts_key(type),
              @"proOnSaleType": mts_key(proOnSaleType),
              @"onSalePrice": mts_key(onSalePrice),
              @"onSaleStock": mts_key(onSaleStock),
              @"proSaleEndTime": mts_key(proSaleEndTime),
              @"proSaleStartTime": mts_key(proSaleStartTime),
              @"proClassAName": mts_key(proClassAName),
              @"proClassAId": mts_key(proClassAId),
              @"proClassBId": mts_key(proClassBId),
              @"proClassBName": mts_key(proClassBName),
              
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

@end
