//
//  WQSizeObj.h
//  App
//
//  Created by 邱成西 on 15/2/12.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

//尺码

@interface WQSizeObj : NSObject

@property (nonatomic, assign) NSInteger sizeId;

@property (nonatomic, copy) NSString *sizeName;

@property (nonatomic, assign) NSInteger sizeNumber;

+(WQSizeObj *)returnSizeWithDic:(NSDictionary *)aDic;


////添加产品时候设置的尺码对应的库存
@property (nonatomic, assign) NSInteger stockCount;


@end
