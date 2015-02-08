//
//  WQMainControl.m
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMainControl.h"
#import "UIView+LayerEffects.h"
#import "UIView+Common.h"

@implementation WQMainControl

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.notificationHub = [[RKNotificationHub alloc]initWithView:self];
    [self.notificationHub moveCircleByX:-5 Y:5];
    
    [self setShadow:[UIColor blackColor] opacity:0.5 offset:CGSizeMake(1.0, 1.0) blurRadius:3];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self animate];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
}

- (void)animate
{
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.9),@(1.0),@(1.1)];
    k.keyTimes = @[@(0.5),@(0.7),@(0.9),@(1.0)];
    k.calculationMode = kCAAnimationLinear;

    [self.layer addAnimation:k forKey:@"SHOW"];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.notificationHub setCircleAtFrame:(CGRect){self.width-15,-15,30,30}];
}

@end
