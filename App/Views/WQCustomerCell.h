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

@end

@protocol WQCustomerCellDelegate <NSObject>

-(void)tapCellWithCustomer:(WQCustomerObj *)customer;

@end