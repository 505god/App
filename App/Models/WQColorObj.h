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

@property (nonatomic, assign) NSInteger colorId;

@property (nonatomic, copy) NSString *colorName;

@property (nonatomic, assign) NSInteger colorNumber;

////添加产品时候设置的颜色对应的图片
@property (nonatomic, strong) UIImage *productImg;

////添加产品时候设置的颜色对应的尺码
@property (nonatomic, strong) NSMutableArray *sizeArray;

+(WQColorObj *)returnColorWithDic:(NSDictionary *)aDic;
@end
