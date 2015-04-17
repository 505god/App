//
//  WQAPIClient.m
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQAPIClient.h"



static NSString * const AFAppDotNetAPIBaseURLString = @"https://barryhippo.xicp.net:8443";

@implementation WQAPIClient

+ (instancetype)sharedClient {
    static WQAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[WQAPIClient alloc] initWithBaseURL:[NSURL URLWithString:AFAppDotNetAPIBaseURLString]];
        
        _sharedClient.securityPolicy = [AFSecurityPolicy defaultPolicy];
        _sharedClient.securityPolicy.allowInvalidCertificates = YES;
    });
    
    return _sharedClient;
}

#pragma mark -
#pragma mark - 店铺
///修改店铺名称
+(NSURLSessionDataTask *)editShopNameWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                if (block) {
                    block(1, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

#pragma mark -
#pragma mark - 分类

///获取分类列表
+(NSURLSessionDataTask *)getClassListWithBlock:(void (^)(NSArray *array, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"classList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQClassObj *classObj = [[WQClassObj alloc] init];
                    [classObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:classObj];
                    SafeRelease(classObj);
                }
                
                if (block) {
                    block([NSArray arrayWithArray:mutablePosts], nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///添加一级分类
+(NSURLSessionDataTask *)addClassAWithParameters:(NSDictionary *)parameters block:(void (^)(WQClassObj *classObject, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                WQClassObj *classObj = [[WQClassObj alloc] init];
                [classObj mts_setValuesForKeysWithDictionary:aDic];
                
                if (block) {
                    block(classObj, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///修改一级分类
+(NSURLSessionDataTask *)editClassAWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                NSInteger sucess = [[aDic objectForKey:@"success"]integerValue];
                
                if (block) {
                    block(sucess, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///删除一级分类
+(NSURLSessionDataTask *)deleteClassAWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                NSInteger sucess = [[aDic objectForKey:@"success"]integerValue];
                
                if (block) {
                    block(sucess, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///添加二级分类
+(NSURLSessionDataTask *)addClassBWithParameters:(NSDictionary *)parameters block:(void (^)(WQClassLevelObj *classObject, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                WQClassLevelObj *classObj = [[WQClassLevelObj alloc] init];
                [classObj mts_setValuesForKeysWithDictionary:aDic];
                
                if (block) {
                    block(classObj, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///修改二级分类
+(NSURLSessionDataTask *)editClassBWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                NSInteger sucess = [[aDic objectForKey:@"success"]integerValue];
                
                if (block) {
                    block(sucess, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///删除二级分类
+(NSURLSessionDataTask *)deleteClassBWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                NSInteger sucess = [[aDic objectForKey:@"success"]integerValue];
                
                if (block) {
                    block(sucess, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

#pragma mark -
#pragma mark - 颜色
///获取颜色列表
+ (NSURLSessionDataTask *)getColorListWithBlock:(void (^)(NSArray *array, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"colorList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQColorObj *colorObj = [[WQColorObj alloc] init];
                    [colorObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:colorObj];
                    SafeRelease(colorObj);
                }
                
                if (block) {
                    block([NSArray arrayWithArray:mutablePosts], nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///添加颜色
+(NSURLSessionDataTask *)addColorWithParameters:(NSDictionary *)parameters block:(void (^)(WQColorObj *colorObject, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                WQColorObj *colorObj = [[WQColorObj alloc] init];
                [colorObj mts_setValuesForKeysWithDictionary:aDic];
                
                if (block) {
                    block(colorObj, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///修改颜色
+(NSURLSessionDataTask *)editColorWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                if (block) {
                    block(1, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///删除颜色
+(NSURLSessionDataTask *)deleteColorWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                if (block) {
                    block(1, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}


#pragma mark -
#pragma mark - 尺寸
///获取尺寸列表
+ (NSURLSessionDataTask *)getSizeListWithBlock:(void (^)(NSArray *array, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"sizeList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQSizeObj *sizeObj = [[WQSizeObj alloc] init];
                    [sizeObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:sizeObj];
                    SafeRelease(sizeObj);
                }
                
                if (block) {
                    block([NSArray arrayWithArray:mutablePosts], nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///添加尺寸
+(NSURLSessionDataTask *)addSizeWithParameters:(NSDictionary *)parameters block:(void (^)(WQSizeObj *sizeObject, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                WQSizeObj *sizeObj = [[WQSizeObj alloc] init];
                [sizeObj mts_setValuesForKeysWithDictionary:aDic];
                
                if (block) {
                    block(sizeObj, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///修改尺寸
+(NSURLSessionDataTask *)editSizeWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                if (block) {
                    block(1, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///删除尺寸
+(NSURLSessionDataTask *)deleteSizeWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                if (block) {
                    block(1, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

#pragma mark -
#pragma mark - 用户

+ (NSURLSessionDataTask *)getCustomerListWithBlock:(void (^)(NSArray *array, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"customerList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQCustomerObj *customerObj = [[WQCustomerObj alloc] init];
                    [customerObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:customerObj];
                    SafeRelease(customerObj);
                }
                
                if (block) {
                    block([NSArray arrayWithArray:mutablePosts], nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///修改用户信息
+(NSURLSessionDataTask *)editCustomerWithParameters:(NSDictionary *)parameters block:(void (^)(WQCustomerObj *customer, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                WQCustomerObj *customerObj = [[WQCustomerObj alloc] init];
                [customerObj mts_setValuesForKeysWithDictionary:aDic];
                
                if (block) {
                    block(customerObj, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///删除用户
+(NSURLSessionDataTask *)deleteCustomerWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                if (block) {
                    block(1, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
///获取用户订单记录
+(NSURLSessionDataTask *)getCustomerOrderListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount,CGFloat totalPrice, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/classList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"orderList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQCustomerOrderObj *orderObj = [[WQCustomerOrderObj alloc] init];
                    [orderObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:orderObj];
                    SafeRelease(orderObj);
                }
                
                NSInteger orderNumber = [[aDic objectForKey:@"pageCount"]integerValue];
                
                CGFloat price = [[aDic objectForKey:@"totalPrice"]floatValue];
                if (block) {
                    block([NSArray arrayWithArray:mutablePosts],orderNumber,price, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
@end
