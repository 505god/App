//
//  WQInputText.h
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @author 邱成西, 15-02-03 14:02:40
 *
 *  输入框
 */
@interface WQInputText : NSObject

/**
 *  @author 邱成西, 15-02-03 14:02:50
 *
 *  <#Description#>
 *
 *  @param icon    输入框图标
 *  @param textY   输入框y值
 *  @param centerX 输入框x值
 *  @param point   输入框提示文字
 *
 *  @return UITextField
 */
- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;

@end
