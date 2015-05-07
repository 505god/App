//
//  WQSizeVC.h
//  App
//
//  Created by 邱成西 on 15/2/12.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

@class WQSizeObj;
///尺码设置
@protocol WQSizeVCDelegate;

@interface WQSizeVC : BaseViewController

@property (nonatomic, assign) id<WQSizeVCDelegate>delegate;

@property (nonatomic, assign) BOOL isPresentVC;

@property (nonatomic, strong) WQSizeObj *selectedSizeObj;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

///已选择的尺码
@property (nonatomic, strong) NSMutableArray *hasSelectedSize;
@end

@protocol WQSizeVCDelegate <NSObject>
@optional

-(void)sizeVC:(WQSizeVC *)sizeVC selectedSize:(WQSizeObj *)sizeObj;
@end