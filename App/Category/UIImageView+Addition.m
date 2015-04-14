//
//  UIImageView+Addition.m
//  App
//
//  Created by 邱成西 on 15/4/14.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "UIImageView+Addition.h"
#import <QuartzCore/QuartzCore.h>

#define kCoverViewTag           2234
#define kImageViewTag           2235
#define kAnimationDuration      0.3f
#define kImageViewWidth         240.0f
#define kBackViewColor          [UIColor colorWithWhite:0.667 alpha:0.5f]

@implementation UIImageView (Addition)

-(void)showLargeImage {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTap:)];
    [self addGestureRecognizer:tapGestureRecognizer];
    SafeRelease(tapGestureRecognizer);
}

- (void)imageTap:(UITapGestureRecognizer *)gesture {
    ///背景
    UIView *coverView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    coverView.backgroundColor = kBackViewColor;
    UITapGestureRecognizer *hiddenViewGecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenViewAnimation)];
    [coverView addGestureRecognizer:hiddenViewGecognizer];
    SafeRelease(hiddenViewGecognizer);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.tag = kImageViewTag;
    imageView.userInteractionEnabled = YES;
    imageView.transform = CGAffineTransformMakeRotation(0);//图片翻转
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    
    [coverView addSubview:imageView];
    coverView.tag = kCoverViewTag;
    [[self window] addSubview:coverView];
    SafeRelease(coverView);
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
    imageView.frame = [self autoFitFrame];
    [UIView commitAnimations];
    
    SafeRelease(imageView);
}

- (void)hiddenView {
    UIView *coverView = (UIView *)[[self window] viewWithTag:kCoverViewTag];
    [coverView removeFromSuperview];
}

- (void)hiddenViewAnimation {
    UIImageView *imageView = (UIImageView *)[[self window] viewWithTag:kImageViewTag];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration]; //动画时长
    CGRect rect = [self convertRect:self.bounds toView:self.window];
    imageView.frame = rect;
    
    [UIView commitAnimations];
    [self performSelector:@selector(hiddenView) withObject:nil afterDelay:kAnimationDuration];
    
}

//自动按原UIImageView等比例调整目标rect
- (CGRect)autoFitFrame {
    //调整为固定宽，高等比例动态变化
    float width = kImageViewWidth;
    float targeHeight = (width*self.frame.size.height)/self.frame.size.width;
    UIView *coverView = (UIView *)[[self window] viewWithTag:kCoverViewTag];
    CGRect targeRect = CGRectMake(coverView.frame.size.width/2 - width/2, coverView.frame.size.height/2 - targeHeight/2, width, targeHeight);
    return targeRect;
}
@end
