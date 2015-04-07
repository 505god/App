//
//  WQAPIClient.h
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface WQAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

///获取分类列表
+ (void)getClassListWithBlock:(void (^)(NSArray *array, NSError *error))block;
@end
