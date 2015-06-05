//
//  WQCoinVC.h
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

///货币设置
///跟用户绑定

@protocol WQCoinVCDelegate;

@interface WQCoinVC : BaseViewController

@property (nonatomic, assign) id<WQCoinVCDelegate>delegate;

@property (nonatomic, assign) BOOL isPresentVC;

@property (nonatomic, assign) NSInteger coinType;
@end


@protocol WQCoinVCDelegate <NSObject>
@optional

-(void)coinVC:(WQCoinVC *)coinVC selectedCoin:(NSInteger)type name:(NSString *)name;
@end