//
//  WQClassLevelObj.h
//  App
//
//  Created by 邱成西 on 15/4/11.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

///二级分类

@interface WQClassLevelObj : NSObject

@property (nonatomic, assign) NSInteger levelClassId;

@property (nonatomic, strong) NSString *levelClassName;

@property (nonatomic, assign) NSInteger productCount;
@end
