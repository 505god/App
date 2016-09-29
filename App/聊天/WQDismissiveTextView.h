//
//  WQDismissiveTextView.h
//  App
//
//  Created by 邱成西 on 15/5/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQDismissiveTextViewDelegate <NSObject>

@optional

- (void)keyboardDidShow;

- (void)keyboardDidScrollToPoint:(CGPoint)point;

- (void)keyboardWillBeDismissed;

- (void)keyboardWillSnapBackToPoint:(CGPoint)point;

@end

@interface WQDismissiveTextView : UITextView


@property (weak, nonatomic) id<WQDismissiveTextViewDelegate> keyboardDelegate;

@property (strong, nonatomic) UIPanGestureRecognizer *dismissivePanGestureRecognizer;


@end
