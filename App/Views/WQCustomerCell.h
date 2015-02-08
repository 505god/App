//
//  WQCustomerCell.h
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RKNotificationHub.h"
#import "WQCustomerObj.h"

@protocol WQCustomerCellDelegate;

@interface WQCustomerCell : UITableViewCell

@property (nonatomic, assign) id<WQCustomerCellDelegate>delegate;

@property (nonatomic, strong) WQCustomerObj *customerObj;

@property (nonatomic, strong) RKNotificationHub *notificationHub;

//选择推荐客户
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;
@end

@protocol WQCustomerCellDelegate <NSObject>
//点击头像浏览客户信息
-(void)tapCellWithCustomer:(WQCustomerObj *)customer;

//选中客户
-(void)selectedCustomer:(WQCustomerObj *)customer animated:(BOOL)animated;

@end