//
//  WQDataShare.m
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQDataShare.h"

@implementation WQDataShare

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}
+ (WQDataShare *)sharedService {
    static dispatch_once_t once;
    static WQDataShare *dataService = nil;
    
    dispatch_once(&once, ^{
        dataService = [[super alloc] init];
    });
    return dataService;
}

@end
