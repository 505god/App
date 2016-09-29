//
//  WQInputText.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQInputText.h"
#import "UIView+XD.h"

@implementation WQInputText

- (UITextField *)setupWithIcon:(NSString *)icon textY:(CGFloat)textY centerX:(CGFloat)centerX point:(NSString *)point;
{
    UITextField *textField = [[UITextField alloc] init];
    textField.width = [UIScreen mainScreen].bounds.size.width-40;
    textField.height = 40;
    textField.centerX = centerX;
    textField.y = textY;
    
    textField.placeholder = point;
    textField.font = [UIFont systemFontOfSize:16];
    textField.textColor = [UIColor blackColor];
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.clearButtonMode = UITextFieldViewModeAlways;
    textField.layer.cornerRadius = 4;
    
    UIImage *bigIcon = [UIImage imageNamed:icon];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:bigIcon];
    if (icon) {
        iconView.width = 25;
    }
    iconView.contentMode = UIViewContentModeLeft;
    textField.leftView = iconView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    SafeRelease(iconView);
    
    textField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"text_bg"]];
    
    return textField;
}

@end
