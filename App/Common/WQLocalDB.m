//
//  WQLocalDB.m
//  App
//
//  Created by 邱成西 on 15/4/22.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQLocalDB.h"

@interface WQLocalDB (DBPrivate)
-(WQUserObj *)userModelFromLocal:(FMResultSet *)rs;
-(WQCustomerObj *)customerModelFromLocal:(FMResultSet *)rs;
-(WQMessageObj *)messageModelFromLocal:(FMResultSet *)rs;
@end

@implementation WQLocalDB (DBPrivate)
-(WQUserObj *)userModelFromLocal:(FMResultSet *)rs {
    WQUserObj *userObj = [[WQUserObj alloc]init];
    userObj.userId = [[rs stringForColumn:@"userId"] integerValue];
    userObj.userHead = [rs stringForColumn:@"userHead"];
    userObj.userName = [rs stringForColumn:@"userName"];
    userObj.userPhone = [rs stringForColumn:@"moneyType"];
    return userObj;
}
-(WQCustomerObj *)customerModelFromLocal:(FMResultSet *)rs {
    WQCustomerObj *customerObj = [[WQCustomerObj alloc]init];
    customerObj.customerId = [[rs stringForColumn:@"customerId"] integerValue];
    customerObj.customerName = [rs stringForColumn:@"customerName"];
    customerObj.customerPhone = [rs stringForColumn:@"customerPhone"];
    customerObj.customerHeader = [rs stringForColumn:@"customerHeader"];
    customerObj.customerArea = [rs stringForColumn:@"customerArea"];
    customerObj.customerDegree = [[rs stringForColumn:@"customerDegree"]integerValue];
    customerObj.customerCode = [rs stringForColumn:@"customerCode"];
    customerObj.customerShield = [[rs stringForColumn:@"customerShield"]integerValue];
    customerObj.customerRemark = [rs stringForColumn:@"customerRemark"];
    return customerObj;
}
-(WQMessageObj *)messageModelFromLocal:(FMResultSet *)rs {
    WQMessageObj *messageObj = [[WQMessageObj alloc]init];
    messageObj.messageFrom = [[rs stringForColumn:@"messageFrom"] integerValue];
    messageObj.messageTo = [[rs stringForColumn:@"messageTo"] integerValue];
    messageObj.messageContent = [rs stringForColumn:@"messageContent"];
    messageObj.messageDate = [rs stringForColumn:@"messageDate"];
    messageObj.messageType = [[rs stringForColumn:@"messageType"]integerValue];
    return messageObj;
}
@end

@implementation WQLocalDB

+(WQLocalDB *)sharedWQLocalDB {
    static WQLocalDB *sharedRPLocalDB=nil;
    
    @synchronized(self)
    {
        if (!sharedRPLocalDB)
            sharedRPLocalDB = [[WQLocalDB alloc] init];
        
        return sharedRPLocalDB;
    }
}

#pragma mark - 用户

-(void)saveUserDataToLocal:(WQUserObj *)user completeBlock:(void (^)(BOOL finished))compleBlock {
    [self.db open];

    [self.db executeUpdate:@"delete from WQUser"];

    NSMutableArray *argumentsArray = [NSMutableArray arrayWithCapacity:4];
    [argumentsArray addObject:[NSString stringWithFormat:@"%d",user.userId]];
    [argumentsArray addObject:[NSString stringWithFormat:@"%@",user.userName]];
    [argumentsArray addObject:[NSString stringWithFormat:@"%@",user.userHead]];
    [argumentsArray addObject:[NSString stringWithFormat:@"%d",user.moneyType]];
    
    BOOL res = [self.db executeUpdate:@"insert into WQUser (userId,userName,userHead,moneyType) values (?,?,?,?)" withArgumentsInArray:argumentsArray];

    [self.db close];
    
    if (compleBlock) {
        compleBlock(res);
    }
}
-(void)getLocalUserDataWithCompleteBlock:(void (^)(NSArray *array))compleBlock {
    [self.db open];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    FMResultSet * rs = [self.db executeQuery:@"select * from WQUser"];
    
    while ([rs next]) {
        WQUserObj *tempUser = [self userModelFromLocal:rs];
        [mutableArray addObject:tempUser];
        tempUser = nil;
    }
    
    [rs close];
    
    [self.db close];
    
    if (compleBlock) {
        compleBlock(mutableArray);
    }
}
-(void)deleteLocalUserWithCompleteBlock:(void (^)(BOOL finished))compleBlock {
    [self.db open];
    
    BOOL res = [self.db executeUpdate:@"delete from WQUser"];
    
    [self.db close];
    
    if (compleBlock) {
        compleBlock(res);
    }
}


#pragma mark - 最近联系人列表

-(void)saveCustomerDataToLocal:(WQCustomerObj *)customerObj completeBlock:(void (^)(BOOL finished))compleBlock {
    [self.db open];
    
    FMResultSet * rs = [self.db executeQuery:@"select * from WQCustomer where customerId=?",customerObj.customerId];
    
    BOOL isExit = NO;
    WQCustomerObj *tempCustomer = [[WQCustomerObj alloc]init];
    while ([rs next]) {
        tempCustomer = [self customerModelFromLocal:rs];
        if (tempCustomer.customerId==customerObj.customerId) {
            isExit = YES;
            break;
        }
    }
    [rs close];
    
    if (isExit==YES) {
        BOOL res = [self.db executeUpdate:@"update WQCustomer set customerName=?,customerHeader=?,customerDegree=?,customerRemark=?,customerShield=? where customerId= ?",customerObj.customerName,customerObj.customerHeader,customerObj.customerDegree,customerObj.customerRemark,customerObj.customerShield,customerObj.customerId];
        
        [self.db close];
        
        if (compleBlock) {
            compleBlock(res);
        }
    }else {
        NSMutableArray *argumentsArray = [NSMutableArray arrayWithCapacity:9];
        [argumentsArray addObject:[NSString stringWithFormat:@"%d",customerObj.customerId]];
        [argumentsArray addObject:[NSString stringWithFormat:@"%@",customerObj.customerName]];
        [argumentsArray addObject:[NSString stringWithFormat:@"%@",customerObj.customerPhone]];
        [argumentsArray addObject:[NSString stringWithFormat:@"%@",customerObj.customerHeader]];
        [argumentsArray addObject:[NSString stringWithFormat:@"%@",customerObj.customerArea]];
        [argumentsArray addObject:[NSString stringWithFormat:@"%d",customerObj.customerDegree]];
        [argumentsArray addObject:[NSString stringWithFormat:@"%@",customerObj.customerCode]];
        [argumentsArray addObject:[NSString stringWithFormat:@"%@",customerObj.customerRemark]];
        [argumentsArray addObject:[NSString stringWithFormat:@"%d",customerObj.customerShield]];
        
        BOOL res = [self.db executeUpdate:@"insert into WQCustomer (customerId,customerName,customerPhone,customerHeader,customerArea,customerDegree,customerCode,customerRemark,customerShield) values (?,?,?,?,?,?,?,?,?)" withArgumentsInArray:argumentsArray];
        
        [self.db close];
        
        if (compleBlock) {
            compleBlock(res);
        }
    }
}
-(void)getLocalCustomerWithCompleteBlock:(void (^)(NSArray *array))compleBlock {
    [self.db open];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    
    FMResultSet * rs = [self.db executeQuery:@"select * from WQCustomer"];
    
    while ([rs next]) {
        WQCustomerObj *customerObj = [self customerModelFromLocal:rs];
        [mutableArray addObject:customerObj];
        customerObj = nil;
    }
    
    [rs close];
    
    [self.db close];
    
    if (compleBlock) {
        compleBlock(mutableArray);
    }
}
-(void)deleteLocalCustomerWithCustomerId:(NSString *)customerId completeBlock:(void (^)(BOOL finished))compleBlock {
    [self.db open];
    
    BOOL res = [self.db executeUpdate:@"delete from WQCustomer where customerId = ?",customerId];
    
    [self.db close];
    
    if (compleBlock) {
        compleBlock(res);
    }
}

#pragma mark - 消息
-(void)saveMessageToLocal:(WQMessageObj *)messageObj completeBlock:(void (^)(BOOL finished))compleBlock {
    [self.db open];
    
    NSMutableArray *argumentsArray = [NSMutableArray arrayWithCapacity:5];
    [argumentsArray addObject:[NSString stringWithFormat:@"%d",messageObj.messageFrom]];
    [argumentsArray addObject:[NSString stringWithFormat:@"%d",messageObj.messageTo]];
    [argumentsArray addObject:[NSString stringWithFormat:@"%@",messageObj.messageContent]];
    [argumentsArray addObject:[NSString stringWithFormat:@"%@",messageObj.messageDate]];
    [argumentsArray addObject:[NSString stringWithFormat:@"%d",messageObj.messageType]];
    
    BOOL res = [self.db executeUpdate:@"insert into WQMessage (messageFrom,messageTo,messageContent,messageDate,messageType) values (?,?,?,?,?)" withArgumentsInArray:argumentsArray];
    
    [self.db close];
    
    if (compleBlock) {
        compleBlock(res);
    }
}

-(void)getLocalMessageWithId:(NSString *)id1 Id:(NSString *)id2 start:(NSString *)start completeBlock:(void (^)(NSArray *array))compleBlock {
    
    if(id1==nil || id2==nil){
        return;
    }
    
    [self.db open];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    FMResultSet * rs = [self.db executeQuery:@"select * from WQMessage where (messageFrom=? and messageTo=?)|(messageFrom=? and messageTo=?) order by id desc limit ?,10",id1,id2,id2,id1,start];
    
    while ([rs next]) {
        WQMessageObj *message = [self messageModelFromLocal:rs];
        [mutableArray addObject:message];
        message = nil;
    }
    
    [rs close];
    [self.db close];
    
    if (compleBlock) {
        compleBlock(mutableArray);
    }
}
-(void)getLatestMessageWithId:(NSString *)id1 Id:(NSString *)id2 completeBlock:(void (^)(WQMessageObj *messageObj))compleBlock {
    if(id1==nil || id2==nil){
        return;
    }
    
    [self.db open];
    
    FMResultSet * rs = [self.db executeQuery:@"select * from WQMessage where (messageFrom=? and messageTo=?)|(messageFrom=? and messageTo=?) order by id desc limit 0,1",id1,id2,id2,id1];
    
    WQMessageObj *messageObj;
    while ([rs next]) {
        messageObj = [self messageModelFromLocal:rs];
    }
    [rs close];
    
    [self.db close];
    
    if (compleBlock) {
        compleBlock(messageObj);
    }
}
@end
