//
//  WQPopView.h
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author 邱成西, 15-03-25 09:03:00
 *
 *  提示的弹出框
 */
@interface WQPopView : UIWindow

+ (void)showWithImageName:(NSString*)imageName message:(NSString *)string;
+ (void)hiddenImage:(void (^)(BOOL finish))compleBlock;
@end
