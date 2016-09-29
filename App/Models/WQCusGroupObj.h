//
//  WQCusGroupObj.h
//  App
//
//  Created by 邱成西 on 15/6/11.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author 邱成西, 15-06-11 19:06:30
 *
 *  客户分组
 */
@interface WQCusGroupObj : NSObject

///客户分组id
@property (nonatomic, assign) NSInteger cusGroupId;
///客户分组下客户数量
@property (nonatomic, assign) NSInteger cusGroupCount;

@property (nonatomic, strong) NSMutableArray *cusArray;
@end
