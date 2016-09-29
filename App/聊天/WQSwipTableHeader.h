//
//  WQSwipTableHeader.h
//  App
//
//  Created by 邱成西 on 15/4/11.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WQSwipTableHeaderRevealDirection) {
    WQSwipTableHeaderRevealDirectionNone = -1, // disables panning
    WQSwipTableHeaderRevealDirectionBoth = 0,
    WQSwipTableHeaderRevealDirectionRight = 1,
    WQSwipTableHeaderRevealDirectionLeft = 2,
};

typedef NS_ENUM(NSUInteger, WQSwipTableHeaderAnimationType) {
    WQSwipTableHeaderAnimationTypeEaseInOut            = 0 << 16,
    WQSwipTableHeaderAnimationTypeEaseIn               = 1 << 16,
    WQSwipTableHeaderAnimationTypeEaseOut              = 2 << 16,
    WQSwipTableHeaderAnimationTypeEaseLinear           = 3 << 16,
    WQSwipTableHeaderAnimationTypeBounce               = 4 << 16, // default
};

@protocol WQSwipTableHeaderDelegate;

@interface WQSwipTableHeader : UITableViewHeaderFooterView<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *contextMenuView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, readwrite) WQSwipTableHeaderRevealDirection revealDirection;
@property (nonatomic, readwrite) WQSwipTableHeaderAnimationType animationType;

@property (nonatomic, readwrite) float animationDuration;
@property (nonatomic, readwrite) BOOL shouldAnimateCellReset;

@property (nonatomic, readwrite) BOOL panElasticity;
@property (nonatomic, readwrite) CGFloat panElasticityStartingPoint;
@property (nonatomic, strong) UIColor *backViewbackgroundColor;

@property (nonatomic, assign) id <WQSwipTableHeaderDelegate> delegate;

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;
-(void)didStartSwiping;
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer;
-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity;
-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity;
-(UIView*)backView;
-(void)cleanupBackView;
@end

@protocol WQSwipTableHeaderDelegate <NSObject>
@optional
-(void)swipeTableViewHeaderDidStartSwiping:(WQSwipTableHeader*)swipeTableViewHeader;
-(void)swipeTableViewHeader:(WQSwipTableHeader*)swipeTableViewHeader didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity;
-(void)swipeTableViewHeaderWillResetState:(WQSwipTableHeader*)swipeTableViewHeader fromPoint:(CGPoint)point animation:(WQSwipTableHeaderAnimationType)animation velocity:(CGPoint)velocity;
-(void)swipeTableViewHeaderDidResetState:(WQSwipTableHeader*)swipeTableViewHeader fromPoint:(CGPoint)point animation:(WQSwipTableHeaderAnimationType)animation velocity:(CGPoint)velocity;

-(void)editDidLongPressedHeaderOption:(WQSwipTableHeader *)Header;

-(void)editDidTapPressedOption:(WQSwipTableHeader *)Header;
@end
