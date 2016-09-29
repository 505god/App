//
//  WQProAttributrFooter.h
//  App
//
//  Created by 邱成西 on 15/4/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQProAttributrFooterDelegate;

@interface WQProAttributrFooter : UITableViewHeaderFooterView

@property (nonatomic, assign) id<WQProAttributrFooterDelegate>footDelegate;

@end

@protocol WQProAttributrFooterDelegate <NSObject>

@optional

///添加商品型号
-(void)addMoreProType;
@end