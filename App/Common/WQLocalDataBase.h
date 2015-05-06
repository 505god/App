//
//  WQLocalDataBase.h
//  App
//
//  Created by 邱成西 on 15/4/22.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 数据库
 * 功能－－创建并保存数据库，创建表
 */
#import "FMDatabase.h"

@interface WQLocalDataBase : NSObject

@property (nonatomic, strong) FMDatabase *db;

@end
