//
//  WQMainControl.h
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RKNotificationHub.h"

@interface WQMainControl : UIControl

///logo
@property (nonatomic, weak) IBOutlet UIImageView *logoImg;
///标题
@property (nonatomic, weak) IBOutlet UILabel *titleLab;

@property (nonatomic, strong) RKNotificationHub *notificationHub;

@end
