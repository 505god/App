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
@property (nonatomic, strong) NSString *colorName;
///颜色下产品数量
@property (nonatomic, assign) NSInteger productCount;

@end
