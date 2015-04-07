//
//  WQMainVC.h
//  App
//
//  Created by 邱成西 on 15/3/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

#import "WQLeftBarView.h"
#import "WQNavBarView.h"

@interface WQMainVC : BaseViewController

//左侧按钮
@property (nonatomic, strong) WQLeftBarView *leftBarView;

//子viewController
@property (nonatomic, assign) NSInteger currentPage;
@property (strong, nonatomic) NSArray *childenControllerArray;
@property (strong, nonatomic) UIViewController *currentViewController;

-(void)setCurrentPageVC:(NSInteger)page;
@end
