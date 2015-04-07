//
//  WQInitView.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQInitView.h"

static CGFloat animationDuration = 1.0;

@implementation WQInitView

- (instancetype) initWithBackgroundImage:(UIImage *)backgroundImage {
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if(self) {
        
        if (backgroundImage) {
            self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        }else {
            self.backgroundColor = COLOR(64, 153, 255, 1);
        }
        
        self.logoImg = [[UIImageView alloc]init];
        self.logoImg.contentMode = UIViewContentModeScaleAspectFit;
        self.logoImg.frame = CGRectMake(0, 0, 40, 40);
        self.logoImg.image = LOADIMAGE(@"back", @"png");
        self.logoImg.center = self.center;
        [self addSubview:self.logoImg];
    }
    return self;
}

-(void)startAnimation {
    if([self.delegate respondsToSelector:@selector(initViewDidBeginAnimating:)])
    {
        [self.delegate initViewDidBeginAnimating:self];
    }
    
    //logo动画
    CGFloat shrinkDuration = animationDuration * 0.3;
    CGFloat growDuration = animationDuration * 0.7;
    
    [UIView animateWithDuration:shrinkDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(0.75, 0.75);
        self.logoImg.transform = scaleTransform;
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:growDuration animations:^{
            CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
            self.logoImg.transform = scaleTransform;
            self.logoImg.alpha = 0;
        } completion:^(BOOL finished) {
            [self.logoImg removeFromSuperview];
        }];
    }];

    //背景动画
    CGFloat bounceDuration = animationDuration * 0.8;
    [NSTimer scheduledTimerWithTimeInterval:bounceDuration target:self selector:@selector(pingGrowAnimation) userInfo:nil repeats:NO];
}

- (void) pingGrowAnimation
{
    CGFloat growDuration = animationDuration *0.2;
    [UIView animateWithDuration:growDuration animations:^{
        CGAffineTransform scaleTransform = CGAffineTransformMakeScale(20, 20);
        self.transform = scaleTransform;
        self.alpha = 0;
        self.backgroundColor = [UIColor blackColor];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [self endAnimating];
    }];
}

- (void) endAnimating
{
    if([self.delegate respondsToSelector:@selector(initViewDidEndAnimating:)])
    {
        [self.delegate initViewDidEndAnimating:self];
    }
}

-(void)dealloc {
    SafeRelease(_logoImg);
    SafeRelease(_delegate);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
