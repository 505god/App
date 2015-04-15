//
//  WQCustomerDetailVC.h
//  App
//
//  Created by 邱成西 on 15/4/14.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

///客户详细资料

#import "WQCustomerObj.h"

@class WQCustomerVC;

@protocol WQCustomerDetailVCDelegate;

@interface WQCustomerDetailVC : BaseViewController

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) WQCustomerObj *customerObj;

@property (nonatomic, assign) id<WQCustomerDetailVCDelegate>delegate;

@property (nonatomic, strong) WQCustomerVC *customerVC;
@end

@protocol WQCustomerDetailVCDelegate <NSObject>

@optional

-(void)customerDetailVC:(WQCustomerDetailVC *)detail customer:(WQCustomerObj *)customer;

@end