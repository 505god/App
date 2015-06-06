//
//  Utility.h
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  公用类方法
 */

//推送类型
typedef enum{
    WQPushTypeLogIn = 0,                //异地登陆
    WQPushTypeOrderRemindPay = 1,       //订单提醒付款
    WQPushTypeOrderRemindDelivery = 2,  //订单提醒发货
    WQPushTypeOrderDelivery = 3,        //订单发货
    WQPushTypeOrderFinish = 4,          //订单已完成
    WQPushTypeCustomer = 5,             //客户
    WQPushTypeProduct = 6,              //商品
    WQPushTypeChat = 8,                 //聊天
    WQPushTypeNone = 9
}WQPushType;

#import "WQPopView.h"

@interface Utility : NSObject


+ (NSString *)getNowDateFromatAnDate;

+ (void)roundView: (UIView *) view;

+(void)setLeftRoundcornerWithView:(UIView *)view;

+(void)setRightRoundcornerWithView:(UIView *)view;

+(void)animationWithView:(UIView *)view image:(NSString *)image selectedImage:(NSString *)selectedImage type:(int)type;

+(BOOL)checkString:(NSString *)string;


+(NSDictionary *)returnDicByPath:(NSString *)jsonPath;

+(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;
+(UIImage *)dealImageData:(UIImage *)image;

+ (NSString *) md5: (NSString *) input;

+(NSString *)returnPath;

+(void)showImage:(UIImageView*)avatarImageView;

+(void)checkAlert;
@end
