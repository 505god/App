//
//  WQProductPropertyCell.h
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

//产品属性cell

#import "WQProductText.h"

@protocol WQProductPropertyCellDelegate;

@interface WQProductPropertyCell : UITableViewCell

@property (nonatomic, assign) id<WQProductPropertyCellDelegate>delegate;

//default is NO; YES 创建新的属性cell
@property (nonatomic, assign) BOOL isCouldExtend;

@property (nonatomic, weak) IBOutlet WQProductText *titleTextField;
@property (nonatomic, weak) IBOutlet WQProductText *infoTextField;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSString *textString;
@end

@protocol WQProductPropertyCellDelegate <NSObject>

-(void)addProperty:(WQProductPropertyCell *)cell;

@end