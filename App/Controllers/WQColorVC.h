//
//  WQColorVC.h
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

///颜色设置

@class WQColorObj;

@protocol WQColorVCDelegate;

@interface WQColorVC : BaseViewController

@property (nonatomic, assign) id<WQColorVCDelegate>delegate;

@property (nonatomic, assign) BOOL isPresentVC;

@property (nonatomic, strong) WQColorObj *selectedColorObj;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

@protocol WQColorVCDelegate <NSObject>

@optional

-(void)colorVC:(WQColorVC *)colorVC selectedColor:(WQColorObj *)colorObj;


@end