//
//  WQPriceLineCell.h
//  App
//
//  Created by 邱成西 on 15/4/21.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQPricelineObj.h"

@interface WQPriceLineCell : UITableViewCell

@property (nonatomic, strong) WQPricelineObj *priceLineObj;

@property (nonatomic, strong) NSIndexPath *indexPath;
@end
