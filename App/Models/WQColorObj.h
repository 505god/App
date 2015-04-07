//
//  WQColorObj.h
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

//颜色分类

@interface WQColorObj : NSObject
///颜色id
@property (nonatomic, assign) NSInteger colorId;
///颜色名称
@property (nonatomic, copy) NSString *colorName;
///颜色下产品数量
@property (nonatomic, assign) NSInteger productCount;

////添加产品时候设置的颜色对应的图片
@property (nonatomic, strong) UIImage *productImg;

////添加产品时候设置的颜色对应的尺码
@property (nonatomic, strong) NSMutableArray *sizeArray;

+(WQColorObj *)returnColorWithDic:(NSDictionary *)aDic;
@end
