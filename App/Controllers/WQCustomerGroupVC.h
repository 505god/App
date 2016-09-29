//
//  WQCustomerGroupVC.h
//  App
//
//  Created by 邱成西 on 15/6/11.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"
#import "WQCusGroupObj.h"

@protocol WQCusGroupVCDelegate;

@interface WQCustomerGroupVC : BaseViewController

@property (nonatomic, assign) id<WQCusGroupVCDelegate>delegate;

@end


@protocol WQCusGroupVCDelegate <NSObject>

@optional

-(void)changeCustomerInfo:(WQCustomerObj *)customer;

@end