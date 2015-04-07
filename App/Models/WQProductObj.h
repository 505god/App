//
//  WQProductObj.h
//  App
//
//  Created by 邱成西 on 15/2/8.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

//产品属性

@interface WQProductObj : NSObject

//----------------------第一页展示
///商品id
@property (nonatomic, assign) NSInteger productId;
///商品图片
@property (nonatomic, strong) NSString *productImage;
///商品名称
@property (nonatomic, strong) NSString *productName;
///商品价格
@property (nonatomic, strong) NSString *productPrice;
///商品销量
@property (nonatomic, assign) NSInteger productSaleCount;
///商品浏览量
@property (nonatomic, assign) NSInteger productViewCount;

///商品是否热卖
@property (nonatomic, assign) NSInteger productIsHot;
///商品是否上架
@property (nonatomic, assign) NSInteger productIsSale;


+(NSURLSessionDataTask *)getProductsWithBlock:(void (^)(NSArray *products, NSError *error))block;
@end
