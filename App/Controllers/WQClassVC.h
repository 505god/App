//
//  WQClassVC.h
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

///分类设置

///单选

@class WQClassObj;
@class WQClassLevelObj;

@protocol WQClassVCDelegate;

@interface WQClassVC : BaseViewController

@property (nonatomic, assign) BOOL isPresentVC;

@property (nonatomic, assign) id<WQClassVCDelegate>delegate;

@property (nonatomic, strong) WQClassLevelObj *selectedClassBObj;

///创建产品选择
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

@protocol WQClassVCDelegate <NSObject>

@optional

-(void)classVC:(WQClassVC *)classVC selectedClass:(WQClassLevelObj *)levelClassObj;
@end