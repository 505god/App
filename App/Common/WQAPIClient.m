//
//  WQAPIClient.m
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQAPIClient.h"

@implementation WQAPIClient

+ (instancetype)sharedClient {
    static WQAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WQAPIClient alloc] initWithBaseURL:[NSURL URLWithString:Host]];
        
        _sharedClient.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
    });
    
    return _sharedClient;
}

+ (void)cancelConnection {
    [[WQAPIClient sharedClient].operationQueue cancelAllOperations];
}
@end
