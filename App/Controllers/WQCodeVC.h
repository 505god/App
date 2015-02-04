//
//  WQCodeVC.h
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

@interface WQCodeVC : BaseViewController

//手机号码
@property (nonatomic, strong) NSString *phoneNumber;
//0:注册  1:忘记密码
@property (nonatomic, assign) NSInteger type;

@end
