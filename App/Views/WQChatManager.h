//
//  WQChatManager.h
//  App
//
//  Created by 邱成西 on 15/5/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQCustomerObj.h"

@interface WQChatManager : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WQCustomerObj *customerObj;

@end
