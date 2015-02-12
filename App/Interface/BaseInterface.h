//
//  BaseInterface.h
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h" 
#import "NSDictionary+AllKeytoLowerCase.h"

typedef void(^CompleteBlock_t)(NSDictionary * object);
typedef void(^ErrorBlock_t)(NSString *notice);

@interface BaseInterface : NSObject {
    CompleteBlock_t completeBlock;
    ErrorBlock_t errorBlock;
}

@property (nonatomic, strong) ASIHTTPRequest *request;

+ (BaseInterface *)sharedInterface;

- (void)initWithRequest:(NSMutableDictionary *)params requestUrl:(NSString *)requestUrl method:(NSString *)method completeBlock:(CompleteBlock_t)complet errorBlock:(ErrorBlock_t)error;


-(void)cancelOperation;

@end
