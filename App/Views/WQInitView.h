//
//  WQInitView.h
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WQInitViewDelegate;

@interface WQInitView : UIView

@property (nonatomic, assign) id<WQInitViewDelegate>delegate;
//置于中心位置的logo
@property (nonatomic, strong) UIImageView *logoImg;

-(instancetype) initWithBackgroundImage:(UIImage *)backgroundImage;

//开始动画
-(void)startAnimation;

@end


@protocol WQInitViewDelegate <NSObject>
//开始
-(void)initViewDidBeginAnimating:(WQInitView *)initView;
//结束
-(void)initViewDidEndAnimating:(WQInitView *) initView;

@end