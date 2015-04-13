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
///尺码id
@property (nonatomic, assign) NSInteger sizeId;
///尺码名称
@property (nonatomic, copy) NSString *sizeName;
///尺码下产品数量
@property (nonatomic, assign) NSInteger productCount;

@end
