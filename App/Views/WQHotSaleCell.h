//
//  WQHotSaleCell.h
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQProductObj.h"

@interface WQHotSaleCell : UICollectionViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) WQProductObj *productObj;

@end
