//
//  WQProductObj.m
//  App
//
//  Created by 邱成西 on 15/2/8.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductObj.h"
#import "WQAPIClient.h"

@implementation WQProductObj

+ (NSDictionary*)mts_mapping {
    return  @{@"productId": mts_key(productId),
              @"productName": mts_key(productName),
              @"productPrice": mts_key(productPrice),
              @"productSaleCount": mts_key(productSaleCount),
              @"productImage": mts_key(productImage),
              @"productViewCount": mts_key(productViewCount),
              @"productIsHot": mts_key(productIsHot),
              @"productIsSale": mts_key(productIsSale)
              };
}

+ (BOOL)mts_shouldSetUndefinedKeys {
    return NO;
}


+(NSURLSessionDataTask *)getProductsWithBlock:(void (^)(NSArray *products, NSError *error))block {
    
    return [[WQAPIClient sharedClient] POST:HOTSALE parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
//    return [[WQAPIClient sharedClient] GET:@"stream/0/posts/stream/global" parameters:nil success:^(NSURLSessionDataTask * __unused task, id JSON) {
//        NSArray *postsFromResponse = [JSON valueForKeyPath:@"data"];
//        NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
//        for (NSDictionary *attributes in postsFromResponse) {
//            Post *post = [[Post alloc] initWithAttributes:attributes];
//            [mutablePosts addObject:post];
//        }
//        
//        if (block) {
//            block([NSArray arrayWithArray:mutablePosts], nil);
//        }
//    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
//        if (block) {
//            block([NSArray array], error);
//        }
//    }];
}

@end
