//
//  WQProductObj.h
//  App
//
//  Created by 邱成西 on 15/2/8.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQProductObj : NSObject

@property (nonatomic, assign) NSInteger productId;

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *productPrice;

@property (nonatomic, assign) NSInteger productStockCount;

@property (nonatomic, copy) NSString *productDetails;

@property (nonatomic, assign) NSInteger productSaleCount;

@property (nonatomic, strong) NSArray *productProperty;

@property (nonatomic, copy) NSString *productImages;
@property (nonatomic, strong) NSArray *productImagesArray;

@property (nonatomic, assign) NSInteger productPraiseCount;

@property (nonatomic, assign) NSInteger productViewCount;

+(WQProductObj *)returnProductWithDic:(NSDictionary *)aDic;
@end
