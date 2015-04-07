//
//  WQClassObj.h
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WQClassObj : NSObject

///分类id
@property (nonatomic, assign) NSInteger classId;
///分类名称
@property (nonatomic, strong) NSString *className;
///分类下产品数量
@property (nonatomic, assign) NSInteger productCount;

///分类下产品数组
@property (nonatomic, strong) NSMutableArray *productList;
@end
