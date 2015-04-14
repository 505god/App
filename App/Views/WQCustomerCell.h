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

@interface WQCustomerCell : UITableViewCell

@property (nonatomic, strong) WQCustomerObj *customerObj;

@property (nonatomic, strong) RKNotificationHub *notificationHub;


///选择时 0=隐藏  1=normal  2=highted
@property (nonatomic, assign) NSInteger selectedType;
@end
