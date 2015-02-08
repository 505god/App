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
              @"productStockCount": mts_key(productStockCount),
              @"productDetails": mts_key(productDetails),
              @"productSaleCount": mts_key(productSaleCount),
              @"productProperty": mts_key(productProperty),
              @"productImages": mts_key(productImages),
              @"productPraiseCount": mts_key(productPraiseCount),
              @"productViewCount": mts_key(productViewCount),
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}

+(WQProductObj *)returnProductWithDic:(NSDictionary *)aDic {
    WQProductObj *product = [[WQProductObj alloc]init];
    
    [product mts_setValuesForKeysWithDictionary:aDic];
    
    product.productImagesArray = [product.productImages componentsSeparatedByString:@"||"];
    
    return product;
}

@end
