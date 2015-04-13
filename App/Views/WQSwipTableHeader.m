//
//  WQSwipTableHeader.m
//  App
//
//  Created by 邱成西 on 15/4/11.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSwipTableHeader.h"

@implementation WQSwipTableHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = YES;
        
        [self initialize];
    }
    return self;
}

- (void)initialize {
    //滑动手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panGestureRecognizer setDelegate:self];
    [self addGestureRecognizer:panGestureRecognizer];
    SafeRelease(panGestureRecognizer);
    
    //长按编辑
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.5;
    [self addGestureRecognizer:longPress];
    SafeRelease(longPress);
    
    //单击手势
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPressed:)];
    [self addGestureRecognizer:tapGes];
    SafeRelease(tapGes);
    
    self.revealDirection = WQSwipTableHeaderRevealDirectionBoth;
    self.animationType = WQSwipTableHeaderAnimationTypeBounce;
    self.animationDuration = 0.25f;
    self.shouldAnimateCellReset = YES;
    self.backViewbackgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
    self.panElasticity = YES;
    self.panElasticityStartingPoint = 0;
    
    self.contextMenuView = [[UIView alloc]initWithFrame:self.frame];
    self.contextMenuView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.contextMenuView];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = self.backViewbackgroundColor;
    self.backgroundView = backgroundView;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.shouldAnimateCellReset = YES;
}

#pragma mark - Gesture recognizer delegate

-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    // We only want to deal with the gesture of it's a pan gesture
    if ([panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && self.revealDirection != WQSwipTableHeaderRevealDirectionNone) {
        CGPoint translation = [panGestureRecognizer translationInView:[self superview]];
        return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
    } else {
        return NO;
    }
}

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
    CGFloat panOffset = translation.x;
    if (self.panElasticity) {
        if (ABS(translation.x) > self.panElasticityStartingPoint) {
            CGFloat width = CGRectGetWidth(self.frame);
            CGFloat offset = abs(translation.x);
            panOffset = (offset * 0.55f * width) / (offset * 0.55f + width);
            panOffset *= translation.x < 0 ? -1.0f : 1.0f;
            if (self.panElasticityStartingPoint > 0) {
                panOffset = translation.x > 0 ? panOffset + self.panElasticityStartingPoint / 2 : panOffset - self.panElasticityStartingPoint / 2;
            }
        }
    }
    CGPoint actualTranslation = CGPointMake(panOffset, translation.y);
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan && [panGestureRecognizer numberOfTouches] > 0) {
        [self didStartSwiping];
        [self animateContentViewForPoint:actualTranslation velocity:velocity];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged && [panGestureRecognizer numberOfTouches] > 0) {
        [self animateContentViewForPoint:actualTranslation velocity:velocity];
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [self resetCellFromPoint:actualTranslation  velocity:velocity];
    }
}

-(void)didStartSwiping {
    if ([self.delegate respondsToSelector:@selector(swipeTableViewHeaderDidStartSwiping:)]) {
        [self.delegate swipeTableViewHeaderDidStartSwiping:self];
    }
    [self.backgroundView addSubview:self.backView];
    [self.backView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
}

#pragma mark - Gesture animations

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    if ((point.x > 0 && self.revealDirection == WQSwipTableHeaderRevealDirectionLeft) || (point.x < 0 && self.revealDirection == WQSwipTableHeaderRevealDirectionRight) || self.revealDirection == WQSwipTableHeaderRevealDirectionBoth) {
        self.contextMenuView.frame = CGRectOffset(self.contextMenuView.bounds, point.x, 0);
        if ([self.delegate respondsToSelector:@selector(swipeTableViewHeader:didSwipeToPoint:velocity:)]) {
            [self.delegate swipeTableViewHeader:self didSwipeToPoint:point velocity:velocity];
        }
    } else if ((point.x > 0 && self.revealDirection == WQSwipTableHeaderRevealDirectionRight) || (point.x < 0 && self.revealDirection == WQSwipTableHeaderRevealDirectionLeft)) {
        self.contextMenuView.frame = CGRectOffset(self.contextMenuView.bounds, 0, 0);
    }
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    if ([self.delegate respondsToSelector:@selector(swipeTableViewHeaderWillResetState:fromPoint:animation:velocity:)]) {
        [self.delegate swipeTableViewHeaderWillResetState:self fromPoint:point animation:self.animationType velocity:velocity];
    }
    if (self.shouldAnimateCellReset == NO) {
        return;
    }
    if ((self.revealDirection == WQSwipTableHeaderRevealDirectionLeft && point.x < 0) || (self.revealDirection == WQSwipTableHeaderRevealDirectionRight && point.x > 0)) {
        return;
    }
    if (self.animationType == WQSwipTableHeaderAnimationTypeBounce) {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.contextMenuView.frame = CGRectOffset(self.contextMenuView.bounds, 0 - (point.x * 0.03), 0);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.1
                                                   delay:0
                                                 options:UIViewAnimationOptionCurveEaseInOut
                                              animations:^{
                                                  self.contextMenuView.frame = CGRectOffset(self.contextMenuView.bounds, 0 + (point.x * 0.02), 0);
                                              }
                                              completion:^(BOOL finished) {
                                                  [UIView animateWithDuration:0.1
                                                                        delay:0
                                                                      options:UIViewAnimationOptionCurveEaseOut
                                                                   animations:^{
                                                                       self.contextMenuView.frame = self.contextMenuView.bounds;
                                                                   }
                                                                   completion:^(BOOL finished) {
                                                                       [self cleanupBackView];
                                                                       if ([self.delegate respondsToSelector:@selector(swipeTableViewHeaderDidResetState:fromPoint:animation:velocity:)]) {
                                                                           [self.delegate swipeTableViewHeaderDidResetState:self fromPoint:point animation:self.animationType velocity:velocity];
                                                                       }
                                                                   }
                                                   ];
                                              }
                              ];
                         }
         ];
    } else {
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:self.animationType
                         animations:^{
                             self.contextMenuView.frame = CGRectOffset(self.contextMenuView.bounds, 0, 0);
                         }
                         completion:^(BOOL finished) {
                             [self cleanupBackView];
                             if ([self.delegate respondsToSelector:@selector(swipeTableViewHeaderDidResetState:fromPoint:animation:velocity:)]) {
                                 [self.delegate swipeTableViewHeaderDidResetState:self fromPoint:point animation:self.animationType velocity:velocity];
                             }
                         }
         ];
    }
}

-(UIView*)backView {
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:self.bounds];
        _backView.backgroundColor = self.backViewbackgroundColor;
    }
    return _backView;
}

-(void)cleanupBackView {
    [_backView removeFromSuperview];
    _backView = nil;
}


- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    //长按开始
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(editDidLongPressedHeaderOption:)]) {
            [self.delegate editDidLongPressedHeaderOption:self];
        }
    }//长按结束
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        
    }
}

-(void)tapPressed:(UITapGestureRecognizer *)recognizer {
    if ([self.delegate respondsToSelector:@selector(editDidTapPressedOption:)]) {
        [self.delegate editDidTapPressedOption:self];
    }
}
@end
