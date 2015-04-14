//
//  ImgScrollView.h
//  TestLayerImage
//
//  Created by lcc on 14-8-1.
//  Copyright (c) 2014年 lcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImgScrollViewDelegate;

@interface ImgScrollView : UIScrollView

@property (nonatomic, strong) UIImageView *imgView;

@property (weak) id<ImgScrollViewDelegate> i_delegate;

- (void) setContentWithFrame:(CGRect) rect;
- (void) setImage:(UIImage *) image;
- (void) setAnimationRect;
- (void) rechangeInitRdct;

@end

@protocol ImgScrollViewDelegate <NSObject>
- (void) tapImageViewTappedWithObject:(id) sender;
@end