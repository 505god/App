//
//  Utility.m
//  LanTaiPro
//
//  Created by comdosoft on 14-5-6.
//  Copyright (c) 2014年 LanTaiPro. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>



@interface Utility ()



@end

@implementation Utility

#pragma mark - 获取当前时间
+ (NSString *)getNowDateFromatAnDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
    dateFormatter = nil;
    return timeString;
}

#pragma mark - 头像设置圆的
+ (void)roundView: (UIView *) view
{
    [view.layer setCornerRadius:(view.frame.size.height/2)];
    [view.layer setMasksToBounds:YES];
}

#pragma mark -左上角和左下角变圆角
+(void)setLeftRoundcornerWithView:(UIView *)view
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
#pragma mark - 右上角和右下角变圆角
+(void)setRightRoundcornerWithView:(UIView *)view
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(4, 4)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}
#pragma mark - 提示信息
+ (void)errorAlert:(NSString *)message view:(UIView *)view
{
    WQPopView *popView = [[WQPopView alloc]initWithFrame:(CGRect){100, 140, 0, 0}];
    popView.parentView = view;
    [popView setText:message];
    [view addSubview:popView];
}

#pragma mark - 放大缩小动画
+(void)animationWithView:(UIView *)view image:(NSString *)image selectedImage:(NSString *)selectedImage type:(int)type
{
    view.layer.contents = (id)[UIImage imageNamed:(type%2==0?selectedImage:image)].CGImage;
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [view.layer addAnimation:k forKey:@"SHOW"];
    k = nil;
}
#pragma mark - 判断字符串是否为空
+(BOOL)checkString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return NO;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return NO;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return NO;
    }
    return YES;
}


+ (Class)JSONParserClass {
    return objc_getClass("NSJSONSerialization");
}

+(NSDictionary *)returnDicByPath:(NSString *)jsonPath {
    NSString *path = [[NSBundle mainBundle] pathForResource:jsonPath ofType:@"json"];
    NSError *error = nil;
    Class JSONSerialization = [Utility JSONParserClass];
    NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:0 error:&error];
    
    if ([[dataObject objectForKey:@"status"]integerValue]==1) {
        NSDictionary *aDic = [dataObject objectForKey:@"returnObj"];
        return aDic;
    }else {
        
    }
    
    return nil;
}


@end
