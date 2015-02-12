//
//  WQProductColorCell.h
//  App
//
//  Created by 邱成西 on 15/2/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WQColorObj.h"
#import "WQProductText.h"

#import "WQTapImg.h"

/**
 *  @author 邱成西, 15-02-12 16:02:28
 *
 *  颜色、图片、尺寸、库存
 */

@class WQNewProductVC;

@protocol WQProductColorCellDelegate;

@interface WQProductColorCell : UITableViewCell

@property (nonatomic, assign) id<WQProductColorCellDelegate>delegate;

@property (nonatomic, strong) WQColorObj *colorObj;

@property (nonatomic, strong) UILabel *colorNameLab;

@property (nonatomic, strong) WQTapImg *productImgView;

@property (nonatomic, strong) NSIndexPath *indexPath;

//箭头
@property (nonatomic, strong) UIImageView *directionImg;

@property (nonatomic, strong) WQNewProductVC *productVC;
@end

@protocol WQProductColorCellDelegate <NSObject>

-(void)addProductImage:(WQProductColorCell *)cell;

@end