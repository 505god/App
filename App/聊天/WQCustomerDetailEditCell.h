//
//  WQCustomerDetailEditCell.h
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQCustomerDetailEditVC;

@protocol WQCustomerDetailEditCellDelegate;

@interface WQCustomerDetailEditCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *idxPath;

@property (nonatomic, strong) WQCustomerDetailEditVC *detailEditVC;

@property (nonatomic, strong) NSDictionary *dictionary;

@property (nonatomic, assign) id<WQCustomerDetailEditCellDelegate>delegate;
@end

@protocol WQCustomerDetailEditCellDelegate <NSObject>

@end