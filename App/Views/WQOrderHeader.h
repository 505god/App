//
//  WQOrderHeader.h
//  App
//
//  Created by 邱成西 on 15/4/16.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQSwipTableHeader.h"
#import "WQCustomerOrderObj.h"

@interface WQOrderHeader : WQSwipTableHeader

@property (nonatomic,assign) NSInteger aSection;
@property (nonatomic,assign) BOOL isSelected;

///type:0=客户1=待处理2=待付款3=已完成
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) WQCustomerOrderObj *orderObj;




@end
