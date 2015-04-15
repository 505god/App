//
//  WQCustomerVC.h
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

#import "WQCustomerDetailEditVC.h"

//客户

@protocol WQCustomerVCDelegate;

@interface WQCustomerVC : BaseViewController<WQCustomerDetailEditVCDelegate>

@property (nonatomic, assign) id<WQCustomerVCDelegate>delegate;

@property (nonatomic, assign) BOOL isPresentVC;
//推荐客户
@property (nonatomic, strong) NSMutableArray *selectedList;
///推荐客户选择
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end


@protocol WQCustomerVCDelegate <NSObject>

@optional

-(void)customerVC:(WQCustomerVC *)customerVC didSelectCustomers:(NSArray *)customers;

@end