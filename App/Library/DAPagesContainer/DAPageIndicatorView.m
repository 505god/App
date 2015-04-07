//
//  DAPageIndicatorView.m
//  DAPagesContainerScrollView
//
//  Created by Daria Kopaliani on 5/29/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAPageIndicatorView.h"


@implementation DAPageIndicatorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        _color = [UIColor blackColor];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Public

- (void)setColor:(UIColor *)color
{
    if ([_color isEqual:color]) {
        _color = color;
        [self setNeedsDisplay];
    }
}

#pragma mark - Private
//画三角
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //指定直线样式
    CGContextSetLineCap(context,kCGLineCapSquare);
    //直线宽度
    CGContextSetLineWidth(context,1.0);
    //设置颜色
    
    CGContextSetRGBStrokeColor(context,170./255., 170./255., 170./255., 1.0);
    //开始绘制
    
    CGContextBeginPath(context);
    //画笔移动到点
    CGContextMoveToPoint(context,CGRectGetMinX(rect), CGRectGetMaxY(rect));
    //下一点
    CGContextAddLineToPoint(context,CGRectGetMidX(rect), CGRectGetMinY(rect));
    //下一点
    CGContextAddLineToPoint(context,CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    //绘制完成
    
    CGContextStrokePath(context);
}


@end