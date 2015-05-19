//
//  WQCustomerOrderCell.h
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "RMSwipeTableViewCell.h"
#import "WQCustomerOrderObj.h"

@interface WQCustomerOrderCell : RMSwipeTableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
///type:0=客户1=待处理2=待付款3=已完成
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) WQCustomerOrderObj *orderObj;

@end
