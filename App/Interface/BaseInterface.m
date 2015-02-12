//
//  BaseInterface.m
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseInterface.h"


#import "InterfaceCache.h"

@implementation BaseInterface

- (id)init{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (BaseInterface *)sharedInterface {
    static dispatch_once_t once;
    static BaseInterface *dataService = nil;
    
    dispatch_once(&once, ^{
        dataService = [[super alloc] init];
    });
    return dataService;
}

- (void)initWithRequest:(NSMutableDictionary *)params requestUrl:(NSString *)requestUrl method:(NSString *)method completeBlock:(CompleteBlock_t)complet errorBlock:(ErrorBlock_t)error {
    if ([method isEqualToString:@"GET"]) {
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",requestUrl];
        NSString *postURL=[self createPostURL:params];
        [urlStr appendFormat:@"?%@",postURL];
        urlStr = (NSMutableString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)urlStr,
                                                                                              NULL,
                                                                                              NULL,
                                                                                              kCFStringEncodingUTF8));
        
        self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    }else {
        NSMutableString *urlStr = [NSMutableString stringWithFormat:@"%@",requestUrl];
        urlStr = (NSMutableString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)urlStr,
                                                                                              NULL,
                                                                                              NULL,
                                                                                              kCFStringEncodingUTF8));
        self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
        
        NSString *postURL=[self createPostURL:params];
        NSMutableData *postData = [[NSMutableData alloc]initWithData:[postURL dataUsingEncoding:NSUTF8StringEncoding]];
        [self.request setPostBody:postData];
        [self.request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    }
    
    completeBlock = [complet copy];
    errorBlock = [error copy];
    
    [self.request setTimeOutSeconds:60];
    [self.request setRequestMethod:method];
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}
-(NSString *)createPostURL:(NSDictionary *)params
{
    NSString *postString=@"";
    for(NSString *key in [params allKeys])
    {
        NSString *value=[params objectForKey:key];
        postString=[postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if([postString length]>1)
    {
        postString=[postString substringToIndex:[postString length]-1];
    }
    return postString;
}



-(void)cancelOperation
{
    [self.request cancel];
    SafeRelease(self.request);
}

#pragma mark - ASIHttpRequestDelegate

-(void)requestFinished:(ASIHTTPRequest *)request {
    [self cancelOperation];
    NSData *data = [[NSData alloc]initWithData:[request responseData]];
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==0) {
                if (errorBlock) {
                    errorBlock([jsonData objectForKey:@"msg"]);
                }
            }else {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                if (completeBlock) {
                    completeBlock(aDic);
                }
            }
        }
    }else {
        
        if (errorBlock) {
            errorBlock(@"后台出错了,产品经理要被扣工资了～");
        }
    }
}

-(void)requestFailed:(ASIHTTPRequest *)request {
    [self cancelOperation];
    if (errorBlock) {
        errorBlock(@"与服务器链接失败");
    }
}

@end
