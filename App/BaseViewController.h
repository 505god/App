//
//  BaseViewController.h
//  WQApp
//
//  Created by 邱成西 on 15/1/7.
//  Copyright (c) 2015年 邱成西. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppDelegate;
@class WQNavBarView;

@interface BaseViewController : UIViewController

@property (nonatomic, strong) AppDelegate *appDel;

//导航栏
@property (nonatomic, strong) WQNavBarView *navBarView;

//没有数据的时候显示
@property (nonatomic, strong) UIView *noneView;
@property (nonatomic, strong) UILabel *noneLabel;

-(void)setNoneText:(NSString *)text animated:(BOOL)animated;

//底部toolBar
@property (nonatomic, strong) UIButton *toolControl;
@property (nonatomic, assign) BOOL isToolBarHidden;

//页面第一次打开
@property (nonatomic, assign) BOOL isFirstShow;

-(void)setToolImage:(NSString *)imageString text:(NSString *)text animated:(BOOL)animated;
@end
