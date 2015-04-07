//
//  WQEditNameVC.h
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

///编辑用户姓名

@protocol WQEditNameVCDelegate;

@interface WQEditNameVC : BaseViewController

@property (nonatomic, assign) id<WQEditNameVCDelegate>delegate;

@end

@protocol WQEditNameVCDelegate <NSObject>

- (void)editNameVCDidChange:(WQEditNameVC *)editNameVC;
- (void)editNameVCDidCancel:(WQEditNameVC *)editNameVC;

@end