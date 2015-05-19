//
//  WQProductVC.h
//  App
//
//  Created by 邱成西 on 15/4/30.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

@protocol WQProductVCDelegate <NSObject>

-(void)deleteProductRefresh;

@end

@interface WQProductVC : BaseViewController

@property (nonatomic, strong) WQClassObj *classObj;
@property (nonatomic, strong) WQClassLevelObj *levelClassObj;

@property (nonatomic, assign) id<WQProductVCDelegate>delegate;
@end
