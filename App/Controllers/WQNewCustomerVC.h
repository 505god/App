//
//  WQNewCustomerVC.h
//  App
//
//  Created by 邱成西 on 15/4/26.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"
#import "WQCustomerObj.h"

@protocol WQNewCustomerVCDelegate;

@interface WQNewCustomerVC : BaseViewController

@property (nonatomic, assign) id<WQNewCustomerVCDelegate>delegate;

@end

@protocol WQNewCustomerVCDelegate <NSObject>

-(void)addNewCustomer:(WQCustomerObj *)customerObj;
@end