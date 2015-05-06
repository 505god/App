//
//  BaseViewController.m
//  WQApp
//
//  Created by 邱成西 on 15/1/7.
//  Copyright (c) 2015年 邱成西. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()


@end

@implementation BaseViewController

-(void)dealloc {
    SafeRelease(_noneView);
    SafeRelease(_noneLabel);
    SafeRelease(_appDel);
    SafeRelease(_toolControl);
    SafeRelease(_navBarView);
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.view.autoresizesSubviews = YES;
    
    self.view.backgroundColor = COLOR(235, 235, 241, 1);
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (Platform>=7.0) {
        self.edgesForExtendedLayout=UIRectEdgeNone;
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property

-(AppDelegate *)appDel {
    if (!_appDel) {
        _appDel = [AppDelegate shareIntance];
    }
    return _appDel;
}

-(WQNavBarView *)navBarView {
    if (!_navBarView) {
        _navBarView = [[WQNavBarView alloc]initWithFrame:(CGRect){0,0,self.view.width, NavgationHeight+[WQDataShare sharedService].statusHeight}];
        _navBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _navBarView;
}

-(UIView *)noneView {
    if (!_noneView) {
        _noneView = [[UIView alloc]initWithFrame:self.view.bounds];
        _noneView.backgroundColor = [UIColor clearColor];
        _noneView.hidden = YES;
        _noneView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _noneView.userInteractionEnabled = NO;
        [self.view addSubview:_noneView];
    }
    return _noneView;
}

-(UILabel *)noneLabel {
    if (!_noneLabel) {
        _noneLabel = [[UILabel alloc]initWithFrame:(CGRect){(self.view.width-60)/2,(self.view.height-20)/2,60,20}];
        _noneLabel.backgroundColor = [UIColor clearColor];
        _noneLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin  |UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _noneLabel.textColor = [UIColor lightGrayColor];
        _noneLabel.font = [UIFont systemFontOfSize:15];
        [self.noneView addSubview:_noneLabel];
    }
    return _noneLabel;
}

-(UIButton *)toolControl {
    if (!_toolControl) {
        _toolControl = [UIButton buttonWithType:UIButtonTypeCustom];
        _toolControl.frame = (CGRect){0,self.view.height-NavgationHeight,self.view.width,NavgationHeight};
        _toolControl.backgroundColor = [UIColor whiteColor];
        _toolControl.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
        [_toolControl addTarget:self action:@selector(toolControlPressed) forControlEvents:UIControlEventTouchUpInside];
        [_toolControl setShadow:[UIColor blackColor] rect:(CGRect){0,0,400,4} opacity:0.5 blurRadius:3];
        _toolControl.titleLabel.font = [UIFont systemFontOfSize:17];
        [_toolControl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_toolControl setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
        [_toolControl setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateDisabled];
        _toolControl.hidden = !self.isToolBarHidden;
        [self.view addSubview:_toolControl];
    }
    return _toolControl;
}
#pragma mark -

-(void)setNoneText:(NSString *)text animated:(BOOL)animated {
    self.noneView.hidden = !animated;
    if (animated) {
        self.noneLabel.text = text;
    }else {
        self.noneLabel.text = @"";
        [self.noneView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.noneView removeFromSuperview];
        SafeRelease(self.noneView);
        SafeRelease(self.noneLabel);
    }
}

-(void)setToolImage:(NSString *)imageString text:(NSString *)text animated:(BOOL)animated {
    self.isToolBarHidden = animated;
    self.toolControl.hidden= !self.isToolBarHidden;
    if (animated) {
        if ([Utility checkString:imageString]) {
            [self.toolControl setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
        }
        if ([Utility checkString:text]) {
            [self.toolControl setTitle:text forState:UIControlStateNormal];
        }
    }else {
        [self.toolControl removeFromSuperview];
        SafeRelease(self.toolControl);
    }
}
-(void)toolControlPressed {
    
}
@end
