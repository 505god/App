//
//  WQChatManager.m
//  App
//
//  Created by 邱成西 on 15/5/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQChatManager.h"
#import "WQLocalDB.h"

#import "WQMessageFrame.h"

static NSString *previousTime = nil;

@implementation WQChatManager

#pragma mark - setter

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(void)setCustomerObj:(WQCustomerObj *)customerObj {
    _customerObj = customerObj;
}
#pragma mark - 聊天记录
-(void)getLocalMessageWithId:(NSString *)id1 Id2:(NSString *)id2 start:(NSInteger)start completeBlock:(void (^)(BOOL isCanLoadingMore))compleBlock{
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [[WQLocalDB sharedWQLocalDB]getLocalMessageWithId:id1 Id:id2 start:[NSString stringWithFormat:@"%d",start] completeBlock:^(NSArray *array) {
        
        BOOL isCanLoad = array.count<10?NO:YES;
        
        if (array.count>0) {
            for (int i=array.count-1; i>=0; i--) {
                WQMessageObj *messageObj = (WQMessageObj *)array[i];
                WQMessageFrame *messageFrame = [weakSelf unionMessageFrameWithMessage:messageObj];
                [weakSelf.dataArray insertObject:messageFrame atIndex:0];
            }
        }
        
        if (compleBlock) {
            compleBlock(isCanLoad);
        }
    }];
}

-(WQMessageFrame *)unionMessageFrameWithMessage:(WQMessageObj *)messageObj {
    WQMessageFrame *messageFrame = [[WQMessageFrame alloc]init];
    
    [messageObj minuteOffSetStart:previousTime end:messageObj.messageDate];
    
    if (messageObj.showDateLabel) {
        previousTime = messageObj.messageDate;
    }
    
    messageFrame.messageObj = messageObj;
    
    if (messageObj.messageFrom == [WQDataShare sharedService].userObj.userId) {
        WQCustomerObj *customer = [[WQCustomerObj alloc]init];
        customer.customerId = [WQDataShare sharedService].userObj.userId;
        customer.customerName = [WQDataShare sharedService].userObj.userName;
        customer.customerHeader = [WQDataShare sharedService].userObj.userHead;
        messageFrame.customerObj = customer;
    }else {
        messageFrame.customerObj = self.customerObj;
    }
    
    return messageFrame;
}
@end
