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
@property (nonatomic, assign) NSInteger proId;
///商品图片
@property (nonatomic, strong) NSString *proImage;
///商品名称
@property (nonatomic, strong) NSString *proName;

///商品价格
@property (nonatomic, strong) NSString *proPrice;
@property (nonatomic, assign) NSInteger proStock;

@property (nonatomic, assign) NSInteger moneyType;

///商品销量
@property (nonatomic, assign) NSInteger proSaleCount;
///商品浏览量
@property (nonatomic, assign) NSInteger proViewCount;

///商品是否热卖
@property (nonatomic, assign) NSInteger proIsHot;
///商品是否上架
@property (nonatomic, assign) NSInteger proIsSale;
@property (nonatomic, strong) NSMutableArray *proImgArray;

///商品类型 0无图  1有图
@property (nonatomic, assign) NSInteger type;
///商品优惠类型
@property (nonatomic, assign) NSInteger proOnSaleType;
@property (nonatomic, strong) NSString *onSalePrice;
@property (nonatomic, assign) NSInteger onSaleStock;
@property (nonatomic, strong) NSString *proSaleEndTime;
@property (nonatomic, strong) NSString *proSaleStartTime;
///商品分类
@property (nonatomic, strong) NSString *proClassAName;
@property (nonatomic, assign) NSInteger proClassAId;
@property (nonatomic, strong) NSString *proClassBName;
@property (nonatomic, assign) NSInteger proClassBId;
@end
