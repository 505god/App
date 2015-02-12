//
//  WQPopView.h
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQPopView : UIView

@property (nonatomic, strong) UILabel *textLabe;
@property (nonatomic, assign) int queueCount;
@property (nonatomic, strong) UIView *parentView;

- (void)setText:(NSString *)text;
@end
