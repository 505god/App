//
//  WQSubVC.h
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQCustomerVC;

@interface WQSubVC : UIViewController

@property (nonatomic, strong) WQCustomerVC *customerVC;

//纪录通讯录列表的cell
@property (nonatomic, strong) NSIndexPath *idxPath;
@end
