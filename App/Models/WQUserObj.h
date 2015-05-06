//
//  WQUserObj.h
//  App
//
//  Created by 邱成西 on 15/4/22.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WQUserObj : NSObject

///storeId ＝＝＝ userId
@property (nonatomic, assign) NSInteger userId;

@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userHead;
@property (nonatomic, strong) NSString *userPhone;

@property (nonatomic, assign) NSInteger moneyType;

@end
