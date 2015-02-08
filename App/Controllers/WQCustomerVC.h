//
//  WQCustomerVC.h
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

@protocol WQCustomerVCDelegate;

@interface WQCustomerVC : BaseViewController

@property (nonatomic, assign) id<WQCustomerVCDelegate>delegate;

@property (nonatomic, assign) BOOL isPresentVC;
//推荐客户
@property (nonatomic, strong) NSMutableArray *selectedList;
@end


@protocol WQCustomerVCDelegate <NSObject>

@optional

- (void)customerVC:(WQCustomerVC *)customerVC didSelectCustomers:(NSArray *)customers;
- (void)customerVCDidCancel:(WQCustomerVC *)customerVC;

@end