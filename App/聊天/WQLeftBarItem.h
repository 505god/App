//
//  WQLeftBarItem.h
//  App
//
//  Created by 邱成西 on 15/3/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RKNotificationHub.h"

@interface WQLeftBarItem : UIControl

@property (assign,nonatomic) BOOL isSelected;
///logo
@property (nonatomic, weak) IBOutlet UIImageView *logoImg;

@property (nonatomic, weak) IBOutlet UIView *whiteView;
@property (nonatomic, strong) RKNotificationHub *notificationHub;

@end
