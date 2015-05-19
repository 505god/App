//
//  WQLeftBarItem.m
//  App
//
//  Created by 邱成西 on 15/3/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQLeftBarItem.h"


@implementation WQLeftBarItem

-(void)dealloc {
    SafeRelease(_logoImg);
    SafeRelease(_notificationHub);
}

-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.notificationHub = [[RKNotificationHub alloc]initWithView:self];
    [self.notificationHub setCount:-1];
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
    
    [self.logoImg.layer addAnimation:k forKey:@"SHOW"];
}

-(void)layoutSubviews {
    [super layoutSubviews];

    self.logoImg.frame = (CGRect){(self.width-self.logoImg.width)/2,(self.height-self.logoImg.height)/2,self.logoImg.width,self.logoImg.height};
    
    [self.notificationHub setCircleAtFrame:(CGRect){self.logoImg.right-10,self.logoImg.top-10,15,15}];
}

#pragma mark property
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    
    self.backgroundColor = isSelected?[UIColor whiteColor]:COLOR(251, 0, 41, 1);
    [self.logoImg setHighlighted:isSelected];
}
@end
