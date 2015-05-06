//
//  WQLocalDB.h
//  App
//
//  Created by 邱成西 on 15/4/22.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQLocalDataBase.h"
#import "WQMessageObj.h"
#import "WQUserObj.h"
#import "WQCustomerObj.h"

@interface WQLocalDB : WQLocalDataBase

+(WQLocalDB *)sharedWQLocalDB;

#pragma mark - 用户
-(void)saveUserDataToLocal:(WQUserObj *)user completeBlock:(void (^)(BOOL finished))compleBlock;
-(void)getLocalUserDataWithCompleteBlock:(void (^)(NSArray *array))compleBlock;
-(void)deleteLocalUserWithCompleteBlock:(void (^)(BOOL finished))compleBlock;


#pragma mark - 最近联系人列表
-(void)saveCustomerDataToLocal:(WQCustomerObj *)customerObj completeBlock:(void (^)(BOOL finished))compleBlock;
-(void)getLocalCustomerWithCompleteBlock:(void (^)(NSArray *array))compleBlock;
-(void)deleteLocalCustomerWithCustomerId:(NSString *)customerId completeBlock:(void (^)(BOOL finished))compleBlock;

#pragma mark - 消息
-(void)saveMessageToLocal:(WQMessageObj *)messageObj completeBlock:(void (^)(BOOL finished))compleBlock;
-(void)getLocalMessageWithId:(NSString *)id1 Id:(NSString *)id2 start:(NSString *)start completeBlock:(void (^)(NSArray *array))compleBlock;
-(void)getLatestMessageWithId:(NSString *)id1 Id:(NSString *)id2 completeBlock:(void (^)(WQMessageObj *messageObj))compleBlock;
@end
