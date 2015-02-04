//
//  WQStarView.h
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQStarView : UIView

@property (nonatomic, assign) NSInteger starNumber;
/*
 *调整底部视图的颜色
 */
@property (nonatomic, strong) UIColor *viewColor;

/*
 *是否允许可触摸
 */
@property (nonatomic, assign) BOOL enable;

@end
