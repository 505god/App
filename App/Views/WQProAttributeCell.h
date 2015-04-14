//
//  WQProAttributeCell.h
//  App
//
//  Created by 邱成西 on 15/4/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

///创建商品属性

#import "WQProductText.h"
#import "WQSwitch.h"

@class WQCreatProductVC;

@protocol WQProAttributeCellDelegate;

@interface WQProAttributeCell : UITableViewCell

///用来标记textField
@property (nonatomic, strong) NSIndexPath *idxPath;

///cell数据源
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) WQCreatProductVC *productVC;

@property (nonatomic, strong) WQProductText *textField;
@property (nonatomic, strong) WQProductText *textField2;

@property (nonatomic, strong) WQSwitch *switchBtn;

@property (nonatomic, assign) id<WQProAttributeCellDelegate>delegate;
@end

@protocol WQProAttributeCellDelegate <NSObject>

-(void)proAttributeCell:(WQProAttributeCell *)cell changeSwitch:(BOOL)isHot;

@end