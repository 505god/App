//
//  WQAPIClient.h
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface WQAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
