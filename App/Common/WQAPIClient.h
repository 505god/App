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

#import "WQCustomerObj.h"
#import "WQCustomerOrderObj.h"

/*
基于NSURLConnection
基于NSURLSession  用于iOS 7 / Mac OS X 10.9及以上版本。
 */

@interface WQAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

#pragma mark - 店铺

///修改店铺名称
+(NSURLSessionDataTask *)editShopNameWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;

#pragma mark - 分类

///获取分类列表
+ (NSURLSessionDataTask *)getClassListWithBlock:(void (^)(NSArray *array, NSError *error))block;
///添加一级分类
+(NSURLSessionDataTask *)addClassAWithParameters:(NSDictionary *)parameters block:(void (^)(WQClassObj *classObject, NSError *error))block;
///修改一级分类
+(NSURLSessionDataTask *)editClassAWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///删除一级分类
+(NSURLSessionDataTask *)deleteClassAWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;

///添加二级分类
+(NSURLSessionDataTask *)addClassBWithParameters:(NSDictionary *)parameters block:(void (^)(WQClassLevelObj *classObject, NSError *error))block;
///修改二级分类
+(NSURLSessionDataTask *)editClassBWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///删除二级分类
+(NSURLSessionDataTask *)deleteClassBWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;


#pragma mark - 颜色
///获取颜色列表
+(NSURLSessionDataTask *)getColorListWithBlock:(void (^)(NSArray *array, NSError *error))block;
///添加颜色
+(NSURLSessionDataTask *)addColorWithParameters:(NSDictionary *)parameters block:(void (^)(WQColorObj *colorObject, NSError *error))block;
///修改颜色
+(NSURLSessionDataTask *)editColorWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///删除颜色
+(NSURLSessionDataTask *)deleteColorWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;

#pragma mark - 尺寸
///获取尺寸列表
+(NSURLSessionDataTask *)getSizeListWithBlock:(void (^)(NSArray *array, NSError *error))block;
///添加尺寸
+(NSURLSessionDataTask *)addSizeWithParameters:(NSDictionary *)parameters block:(void (^)(WQSizeObj *sizeObject, NSError *error))block;
///修改尺寸
+(NSURLSessionDataTask *)editSizeWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///删除尺寸
+(NSURLSessionDataTask *)deleteSizeWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;

#pragma mark - 用户
///获取分类列表
+(NSURLSessionDataTask *)getCustomerListWithBlock:(void (^)(NSArray *array, NSError *error))block;
///修改用户信息
+(NSURLSessionDataTask *)editCustomerWithParameters:(NSDictionary *)parameters block:(void (^)(WQCustomerObj *customer, NSError *error))block;
///删除用户
+(NSURLSessionDataTask *)deleteCustomerWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///获取用户订单记录
+(NSURLSessionDataTask *)getCustomerOrderListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount,CGFloat totalPrice, NSError *error))block;
@end
