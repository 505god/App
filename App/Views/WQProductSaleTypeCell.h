//
//  WQProductSaleTypeCell.h
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WQProductSaleVC;
@class WQProductText;


@interface WQProductSaleTypeCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) WQProductSaleVC *proSaleVC;

@property (nonatomic, strong) WQProductText *textField;
//最低价格
@property (nonatomic, strong) NSString *lowPrice;
@end
