//
//  WQAPIClient.m
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQAPIClient.h"

static NSString * const AFAppDotNetAPIBaseURLString = @"https://api.app.net/";

@implementation WQAPIClient

+ (instancetype)sharedClient {
    static WQAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WQAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}

@end
