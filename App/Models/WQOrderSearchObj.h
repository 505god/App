//
//  WQOrderSearchObj.h
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * 待处理 1
 * 待付款 2
 * 已完成 3
 */

@interface WQOrderSearchObj : NSObject

@property (nonatomic, strong) NSMutableArray *payArray;
@property (nonatomic, strong) NSMutableArray *deliveryArray;
@property (nonatomic, strong) NSMutableArray *receiveArray;
@property (nonatomic, strong) NSMutableArray *finishArray;
@end
