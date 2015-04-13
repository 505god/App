//
//  WQAPIClient.h
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "WQClassObj.h"
#import "WQClassLevelObj.h"

#import "WQColorObj.h"

#import "WQSizeObj.h"

@interface WQAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

#pragma mark - 分类

///获取分类列表
+ (void)getClassListWithBlock:(void (^)(NSArray *array, NSError *error))block;
///添加一级分类
+(void)addClassAWithParameters:(NSDictionary *)parameters block:(void (^)(WQClassObj *classObject, NSError *error))block;
///修改一级分类
+(void)editClassAWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///删除一级分类
+(void)deleteClassAWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;

///添加二级分类
+(void)addClassBWithParameters:(NSDictionary *)parameters block:(void (^)(WQClassLevelObj *classObject, NSError *error))block;
///修改二级分类
+(void)editClassBWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///删除二级分类
+(void)deleteClassBWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;


#pragma mark - 颜色

///添加颜色
+(void)addColorWithParameters:(NSDictionary *)parameters block:(void (^)(WQColorObj *colorObject, NSError *error))block;
///修改颜色
+(void)editColorWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///删除颜色
+(void)deleteColorWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;

#pragma mark - 尺寸

///添加尺寸
+(void)addSizeWithParameters:(NSDictionary *)parameters block:(void (^)(WQSizeObj *sizeObject, NSError *error))block;
///修改尺寸
+(void)editSizeWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///删除尺寸
+(void)deleteSizeWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
@end
