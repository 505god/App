//
//  WQAPIClient.h
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "AFHTTPSessionManager.h"

#import "WQClassObj.h"
#import "WQClassLevelObj.h"

#import "WQColorObj.h"

#import "WQSizeObj.h"

#import "WQCustomerObj.h"
#import "WQCustomerOrderObj.h"

#import "WQUserObj.h"

#import "WQProductObj.h"

#import "WQOrderSearchObj.h"

/*
基于NSURLConnection
基于NSURLSession  用于iOS 7 / Mac OS X 10.9及以上版本。
 */

@interface WQAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

+ (void)cancelConnection;

@end
