//
//  NSDictionary+AllKeytoLowerCase.m
//  MagFan
//
//  Created by chao han on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NSDictionary+AllKeytoLowerCase.h"

@implementation NSDictionary (AllKeytoLowerCase)

-(NSDictionary*)allKeytoLowerCase{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:self.count];
    NSEnumerator *keyenum = self.keyEnumerator;
    
    for(NSString  *k  in  keyenum)  {  
        [dict setObject:[self objectForKey:k] forKey:k.lowercaseString];
    } 
    
    return self;
}


//创建深层可变副本
-(NSMutableDictionary *)mutableDeepCopy{
    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc]
                                       initWithCapacity:[self count]];
    NSArray *keys = [self allKeys];
    for(id key in keys){
        id oneValue = [self valueForKey:key];
        id oneCopy = nil;
        
        if([oneValue respondsToSelector:@selector(mutableDeepCopy)])
            oneCopy = [oneValue mutableDeepCopy];
        else if([oneValue respondsToSelector:@selector(mutableCopy)])
            oneCopy = [oneValue mutableCopy];
        if(oneCopy == nil)
            oneCopy = [oneValue copy];
        [returnDict setValue:oneCopy forKey:key];
    }
    return returnDict;
}
@end
