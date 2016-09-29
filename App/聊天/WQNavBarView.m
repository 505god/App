//
//  WQNavBarView.m
//  App
//
//  Created by 邱成西 on 15/3/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQNavBarView.h"

@implementation WQNavBarView

-(void)dealloc {
    SafeRelease(_titleLab);
    SafeRelease(_leftBtn);
    SafeRelease(_rightBtn);
    SafeRelease(_navDelegate);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.font = [UIFont systemFontOfSize:18];
        [self addSubview:self.titleLab];
        
        self.leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftBtn.frame = (CGRect){10,frame.size.height-37,30,30};
        [self.leftBtn setImage:[UIImage imageNamed:@"webback"] forState:UIControlStateNormal];
        [self.leftBtn setImage:[UIImage imageNamed:@"webbackNor"] forState:UIControlStateHighlighted];
        [self.leftBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.leftBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
        [self.leftBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateDisabled];
        [self.leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.leftBtn.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.leftBtn];
        
        self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightBtn.frame = (CGRect){frame.size.width-90,frame.size.height-37,80,30};
        [self.rightBtn setTitleColor:COLOR(251, 0, 41, 1) forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
        [self.rightBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateDisabled];
        
        CGRect imageFrame= CGRectMake(0, 0, 25, 25);
        UIEdgeInsets imageInset = UIEdgeInsetsMake(0, 55, 2.5, 0);
        self.rightBtn.imageView.frame = imageFrame;
        self.rightBtn.imageEdgeInsets = imageInset;
        self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [self.rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.rightBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin;
        [self addSubview:self.rightBtn];
        
    }
    return self;
}


-(void)setIsShowShadow:(BOOL)isShowShadow {
    _isShowShadow = isShowShadow;
    if (isShowShadow) {
        [self setShadow:[UIColor blackColor] rect:(CGRect){0,self.height,self.width,4} opacity:0.5 blurRadius:3];
    }else {
        [self setShadow:[UIColor blackColor] rect:(CGRect){0,0,0,0} opacity:0.5 blurRadius:3];
    }
}

-(void)setTitleString:(NSString *)titleString {
    if(_titleString!=titleString){
        _titleString = titleString;
        
        self.titleLab.text = titleString;
        [self.titleLab sizeToFit];
        
        self.titleLab.frame = (CGRect){(self.width-self.titleLab.width)/2,(NavgationHeight-self.titleLab.height)/2+[WQDataShare sharedService].statusHeight,self.titleLab.width,self.titleLab.height};
        self.titleLab.autoresizingMask =  UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    }
}


-(void)rightBtnClick:(id)sender {
    if (self.navDelegate && [self.navDelegate respondsToSelector:@selector(rightBtnClickByNavBarView:)]) {
        [self.navDelegate rightBtnClickByNavBarView:self];
    }
}

-(void)leftBtnClick:(id)sender {
    if (self.navDelegate && [self.navDelegate respondsToSelector:@selector(leftBtnClickByNavBarView:)]) {
        [self.navDelegate leftBtnClickByNavBarView:self];
    }
}
@end
