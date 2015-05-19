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

/*
#pragma mark -

///判断登录与否
+ (NSURLSessionDataTask *)checkLogInWithBlock:(void (^)(NSInteger status, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/login/checkLogin" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            NSInteger status = [[jsonData objectForKey:@"status"]integerValue];
            if (block) {
                block(status, nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(0, nil);
        }
    }];
}
 
///语言
+ (NSURLSessionDataTask *)postLanguageWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger status, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/login/langType" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            NSInteger status = [[jsonData objectForKey:@"status"]integerValue];
            if (block) {
                block(status, nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(0, nil);
        }
    }];
}

#pragma mark - 登录
///获取登录错误次数
+ (NSURLSessionDataTask *)getWrongNumberWithBlock:(void (^)(NSInteger wrongNumber, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/login/wrongNumber" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = (NSDictionary *)[jsonData objectForKey:@"returnObj"];
                NSInteger wrongNumber = [[aDic objectForKey:@"wrongNumber"] integerValue];
                if (block) {
                    block(wrongNumber, nil);
                }
            }else {
                if (block) {
                    block(0, nil);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(0, nil);
        }
    }];
}

///获取验证码
+ (NSURLSessionDataTask *)getWrongCodeWithBlock:(void (^)(NSString *wrongCode, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/login/validateCode" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSString *wrongCode = [jsonData objectForKey:@"returnObj"];
                if (block) {
                    block(wrongCode, nil);
                }
            }else {
                if (block) {
                    block(nil, nil);
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, nil);
        }
    }];
}

///登录
+ (NSURLSessionDataTask *)logInWithParameters:(NSDictionary *)parameters block:(void (^)(WQUserObj *user, NSError *error))block{
    return [[WQAPIClient sharedClient] POST:@"/rest/login/userLogin" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:@"https://barryhippo.xicp.net:8443/rest/login/userLogin"]];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"sessionCookies"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                
                NSDictionary *aDic = (NSDictionary *)[jsonData objectForKey:@"returnObj"];
                NSDictionary *dic = (NSDictionary *)[aDic objectForKey:@"store"];
                
                WQUserObj *userObj = [[WQUserObj alloc]init];
                [userObj mts_setValuesForKeysWithDictionary:dic];
                userObj.userPhone = [parameters objectForKey:@"userPhone"];
                if (block) {
                    block(userObj,nil);
                }
            }else {
                if (block) {
                    block(nil, nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil, error);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///退出
+ (NSURLSessionDataTask *)logOutWithBlock:(void (^)(NSInteger status, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/login/logout" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            NSInteger status = [[jsonData objectForKey:@"status"]integerValue];
            if (block) {
                block(status, nil);
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
 
#pragma mark -
#pragma mark - 店铺
///修改店铺名称
+(NSURLSessionDataTask *)editShopNameWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/store/updateStoreName" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
                if (block) {
                    block([NSArray array], nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], nil);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///添加一级分类
+(NSURLSessionDataTask *)addClassAWithParameters:(NSDictionary *)parameters block:(void (^)(WQClassObj *classObject, NSError *error))block {
    
    return [[WQAPIClient sharedClient] POST:@"/rest/store/addClassA" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                if ([aDic allKeys].count>0) {
                    WQClassObj *classObj = [[WQClassObj alloc] init];
                    [classObj mts_setValuesForKeysWithDictionary:aDic];
                    
                    if (block) {
                        block(classObj, nil);
                    }
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
    return [[WQAPIClient sharedClient] POST:@"/rest/store/updateClassA" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
 
///删除一级分类
+(NSURLSessionDataTask *)deleteClassAWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/store/delClassA" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
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
 
///添加二级分类
+(NSURLSessionDataTask *)addClassBWithParameters:(NSDictionary *)parameters block:(void (^)(WQClassLevelObj *classObject, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/store/addClassB" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                if ([aDic allKeys].count>0) {
                    WQClassLevelObj *classObj = [[WQClassLevelObj alloc] init];
                    [classObj mts_setValuesForKeysWithDictionary:aDic];
                    
                    if (block) {
                        block(classObj, nil);
                    }
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
    return [[WQAPIClient sharedClient] POST:@"/rest/store/updateClassB" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

///删除二级分类
+(NSURLSessionDataTask *)deleteClassBWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/store/delClassB" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
#pragma mark - 颜色
///获取颜色列表
+ (NSURLSessionDataTask *)getColorListWithBlock:(void (^)(NSArray *array, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/store/colorList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
                if (block) {
                    block([NSArray array], nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], nil);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
 
///添加颜色
+(NSURLSessionDataTask *)addColorWithParameters:(NSDictionary *)parameters block:(void (^)(WQColorObj *colorObject, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/store/addColor" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                if ([aDic allKeys].count>0) {
                    WQColorObj *colorObj = [[WQColorObj alloc] init];
                    [colorObj mts_setValuesForKeysWithDictionary:aDic];
                    
                    if (block) {
                        block(colorObj, nil);
                    }
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
    return [[WQAPIClient sharedClient] POST:@"/rest/store/updateColor" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    return [[WQAPIClient sharedClient] POST:@"/rest/store/delColor" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    return [[WQAPIClient sharedClient] GET:@"/rest/store/sizeList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
                if (block) {
                    block([NSArray array], nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], nil);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///添加尺寸
+(NSURLSessionDataTask *)addSizeWithParameters:(NSDictionary *)parameters block:(void (^)(WQSizeObj *sizeObject, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/store/addSize" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                if ([aDic allKeys].count>0) {
                    WQSizeObj *sizeObj = [[WQSizeObj alloc] init];
                    [sizeObj mts_setValuesForKeysWithDictionary:aDic];
                    
                    if (block) {
                        block(sizeObj, nil);
                    }
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
    return [[WQAPIClient sharedClient] POST:@"/rest/store/updateSize" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    return [[WQAPIClient sharedClient] POST:@"/rest/store/delSize" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
 
#pragma mark - 货币
+(NSURLSessionDataTask *)selectedCoinWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/store/updateSize" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    return [[WQAPIClient sharedClient] GET:@"/rest/user/getStoreCustomers" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSArray *postsFromResponse = [jsonData objectForKey:@"returnObj"];
                
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
                if (block) {
                    block([NSArray array], nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array], nil);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
 
///修改用户信息
+(NSURLSessionDataTask *)editCustomerWithParameters:(NSDictionary *)parameters block:(void (^)(WQCustomerObj *customer, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/user/updateCustomer" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    return [[WQAPIClient sharedClient] POST:@"/rest/user/delCustomer" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
    return [[WQAPIClient sharedClient] GET:@"/rest/order/userOrderList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
                if (block) {
                    block([NSArray array],0,0, nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array],0,0, error);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

///获取邀请码
+(NSURLSessionDataTask *)getCustomerCodeWithBlock:(void (^)(NSString *codeString, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/user/addCustomer" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
            }else {
                if (block) {
                    block(nil,nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil,error);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
 
#pragma mark - 订单

//获取订单列表
+(NSURLSessionDataTask *)getOrderListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount, NSError *error))block{
    return [[WQAPIClient sharedClient] GET:@"/rest/order/orderList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
                
                if (block) {
                    block([NSArray arrayWithArray:mutablePosts],orderNumber, nil);
                }
            }else {
                if (block) {
                    block([NSArray array],0,nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array],0,error);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

//搜索订单列表
+(NSURLSessionDataTask *)getSearchOrderListWithParameters:(NSDictionary *)parameters block:(void (^)(WQOrderSearchObj *orderSearchObj, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/order/searchOrderList" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                WQOrderSearchObj *orderObj = [[WQOrderSearchObj alloc]init];
                [orderObj mts_setValuesForKeysWithDictionary:aDic];

                if (block) {
                    block(orderObj, nil);
                }
            }else {
                if (block) {
                    block(nil,nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil,error);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

//删除订单
+(NSURLSessionDataTask *)deleteOrderWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/order/delOrder" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
 
//订单改价
+(NSURLSessionDataTask *)editOrderWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/order/changeOrderPrice" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

//订单付款提醒
+(NSURLSessionDataTask *)remindOrderWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger finished, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/order/noticeOrder" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
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

#pragma mark - 商品
 
//获取热卖商品
+(NSURLSessionDataTask *)getHotSaleListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/product/getHostProduct" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"resultList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQProductObj *product = [[WQProductObj alloc]init];
                    [product mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:product];
                    SafeRelease(product);
                }
                
                NSInteger proNumber = [[aDic objectForKey:@"pageCount"]integerValue];
                
                if (block) {
                    block([NSArray arrayWithArray:mutablePosts],proNumber, nil);
                }
            }else {
                if (block) {
                    block([NSArray array],0, nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array],0, nil);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

//获取分类下商品
+(NSURLSessionDataTask *)getProductListWithParameters:(NSDictionary *)parameters block:(void (^)(NSArray *array,NSInteger pageCount, NSError *error))block {
    return [[WQAPIClient sharedClient] GET:@"/rest/product/getClassProduct" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"resultList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQProductObj *product = [[WQProductObj alloc]init];
                    [product mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:product];
                    SafeRelease(product);
                }
                
                NSInteger proNumber = [[aDic objectForKey:@"pageCount"]integerValue];
                
                if (block) {
                    block([NSArray arrayWithArray:mutablePosts],proNumber, nil);
                }
            }else {
                if (block) {
                    block([NSArray array],0, nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block([NSArray array],0, nil);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
 
//获取商品详情
+(NSURLSessionDataTask *)getProductDetailWithParameters:(NSDictionary *)parameters block:(void (^)(NSDictionary *aDic, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/user/getStoreCustomers" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                if (block) {
                    block(aDic, nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

//创建商品
+(NSURLSessionDataTask *)creatProductWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger status, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/product/productAdd" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                if (block) {
                    block([[jsonData objectForKey:@"status"]integerValue], nil);
                }
            }else {
                if (block) {
                    block(0, nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(0, nil);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

//删除商品
+(NSURLSessionDataTask *)deleteProductWithParameters:(NSDictionary *)parameters block:(void (^)(NSInteger status, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/product/delProduct" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                if (block) {
                    block([[jsonData objectForKey:@"status"]integerValue], nil);
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
 
//修改商品
+(NSURLSessionDataTask *)editProductWithParameters:(NSDictionary *)parameters block:(void (^)(WQProductObj *product,NSInteger status, NSError *error))block {
    return [[WQAPIClient sharedClient] POST:@"/rest/product/productEdit" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                WQProductObj *productObj = [[WQProductObj alloc]init];
                [productObj mts_setValuesForKeysWithDictionary:[jsonData objectForKey:@"returnObj"]];
                if (block) {
                    block(productObj,1,nil);
                }
            }else {
                if (block) {
                    block(nil,0,nil);
                }
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (block) {
            block(nil,0,nil);
        }
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
 */
@end
