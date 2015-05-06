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

#import "WQUserObj.h"

#import "WQProductObj.h"

#import "WQOrderSearchObj.h"

/*
基于NSURLConnection
基于NSURLSession  用于iOS 7 / Mac OS X 10.9及以上版本。
 */

@interface WQAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

///判断登录与否
+ (NSURLSessionDataTask *)checkLogInWithBlock:(void (^)(NSInteger status, NSError *error))block;
///语言
+ (NSURLSessionDataTask *)postLanguageWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger status, NSError *error))block;
#pragma mark - 登录
///获取登录错误次数
+ (NSURLSessionDataTask *)getWrongNumberWithBlock:(void (^)(NSInteger wrongNumber, NSError *error))block;
///获取验证码
+ (NSURLSessionDataTask *)getWrongCodeWithBlock:(void (^)(NSString *wrongCode, NSError *error))block;
///登录
+ (NSURLSessionDataTask *)logInWithParameters:(NSDictionary *)parameters block:(void (^)(WQUserObj *user, NSError *error))block;
///退出
+ (NSURLSessionDataTask *)logOutWithBlock:(void (^)(NSInteger status, NSError *error))block;
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

#pragma mark - 货币
+(NSURLSessionDataTask *)selectedCoinWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;

#pragma mark - 用户
///获取用户列表
+(NSURLSessionDataTask *)getCustomerListWithBlock:(void (^)(NSArray *array, NSError *error))block;
///修改用户信息
+(NSURLSessionDataTask *)editCustomerWithParameters:(NSDictionary *)parameters block:(void (^)(WQCustomerObj *customer, NSError *error))block;
///删除用户
+(NSURLSessionDataTask *)deleteCustomerWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
///获取用户订单记录
+(NSURLSessionDataTask *)getCustomerOrderListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount,CGFloat totalPrice, NSError *error))block;
///获取邀请码
+(NSURLSessionDataTask *)getCustomerCodeWithBlock:(void (^)(NSString *codeString, NSError *error))block;

#pragma mark - 订单
//获取订单列表
+(NSURLSessionDataTask *)getOrderListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount, NSError *error))block;
//搜索订单列表
+(NSURLSessionDataTask *)getSearchOrderListWithParameters:(NSDictionary *)parameters block:(void (^)(WQOrderSearchObj *orderSearchObj, NSError *error))block;
//删除订单
+(NSURLSessionDataTask *)deleteOrderWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
//订单改价
+(NSURLSessionDataTask *)editOrderWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
//订单付款提醒
+(NSURLSessionDataTask *)remindOrderWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block;
#pragma mark - 商品
//获取热卖商品
+(NSURLSessionDataTask *)getHotSaleListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount, NSError *error))block;
//获取分类下商品
+(NSURLSessionDataTask *)getProductListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount, NSError *error))block;
//获取商品详情
+(NSURLSessionDataTask *)getProductDetailWithParameters:(NSDictionary *)parameters block:(void (^)(NSDictionary *aDic, NSError *error))block;
//创建商品
+(NSURLSessionDataTask *)creatProductWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger status, NSError *error))block;
@end
