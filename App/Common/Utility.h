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
@end
