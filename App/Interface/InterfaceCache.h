//
//  InterfaceCache.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASICacheDelegate.h"

@interface InterfaceCache : NSObject<ASICacheDelegate>
{
    ASICachePolicy defaultCachePolicy;
    NSString *storagePath;
    NSRecursiveLock *accessLock;
    BOOL shouldRespectCacheControlHeaders;
}

+ (id)sharedCache;

+ (BOOL)serverAllowsResponseCachingForRequest:(ASIHTTPRequest *)request;

+ (NSArray *)fileExtensionsToHandleAsHTML;

@property (assign, nonatomic) ASICachePolicy defaultCachePolicy;
@property (retain, nonatomic) NSString *storagePath;
@property (retain) NSRecursiveLock *accessLock;
@property (assign) BOOL shouldRespectCacheControlHeaders;

@end
