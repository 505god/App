//
//  WQChatManager.h
//  App
//
//  Created by 邱成西 on 15/5/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WQCustomerObj.h"

#import "WQMessageObj.h"

@interface WQChatManager : NSObject

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WQCustomerObj *customerObj;

-(void)getLocalMessageWithId:(NSString *)id1 Id2:(NSString *)id2 start:(NSInteger)start completeBlock:(void (^)(BOOL isCanLoadingMore,NSInteger count))compleBlock;


-(void)getNextLocalMessageWithId:(NSString *)id1 Id2:(NSString *)id2 start:(NSInteger)start completeBlock:(void (^)(BOOL isCanLoadingMore,NSInteger count))compleBlock;
-(void)addMessageFrameWithMessageObj:(WQMessageObj *)messageObj;
@end
