//
//  WQNavBarView.m
//  App
//
//  Created by 邱成西 on 15/3/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQNavBarView.h"

@implementation WQNavBarView

-(void)setIsShowShadow:(BOOL)isShowShadow {
    _isShowShadow = isShowShadow;
    if (isShowShadow) {
        [self setShadow:[UIColor blackColor] rect:(CGRect){0,self.height,self.width,4} opacity:0.5 blurRadius:3];
    }else {
        [self setShadow:[UIColor blackColor] rect:(CGRect){0,0,0,0} opacity:0.5 blurRadius:3];
    }
}
-(void)dealloc {
    SafeRelease(_titleLab);
    SafeRelease(_leftBtn);
    SafeRelease(_rightBtn);
    SafeRelease(_navDelegate);
}
-(IBAction)rightBtnClick:(id)sender {
    if (self.navDelegate && [self.navDelegate respondsToSelector:@selector(rightBtnClickByNavBarView:)]) {
        [self.navDelegate rightBtnClickByNavBarView:self];
    }
}

-(IBAction)leftBtnClick:(id)sender {
    if (self.navDelegate && [self.navDelegate respondsToSelector:@selector(leftBtnClickByNavBarView:)]) {
        [self.navDelegate leftBtnClickByNavBarView:self];
    }
}
@end
