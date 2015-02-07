//
//  NSDictionary+AllKeytoLowerCase.h
//  MagFan
//
//  Created by chao han on 12-5-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AllKeytoLowerCase)

-(NSDictionary*)allKeytoLowerCase;//所有key小写

-(NSMutableDictionary *)mutableDeepCopy;//创建深层可变副本
@end
