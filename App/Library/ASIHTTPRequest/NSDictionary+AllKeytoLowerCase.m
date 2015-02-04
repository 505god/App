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
@end
