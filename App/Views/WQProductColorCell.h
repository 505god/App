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

@protocol WQProductColorCellDelegate;

@interface WQProductColorCell : UITableViewCell

@property (nonatomic, assign) id<WQProductColorCellDelegate>delegate;

@property (nonatomic, strong) WQColorObj *colorObj;

@property (nonatomic, weak) IBOutlet UILabel *colorLab;

@property (nonatomic, weak) IBOutlet WQTapImg *productImgView;

@property (nonatomic, weak) IBOutlet WQProductText *stockTxt;

@property (nonatomic, strong) NSIndexPath *indexPath;

//箭头
@property (nonatomic, weak) IBOutlet  UIImageView *directionImg;
@end

@protocol WQProductColorCellDelegate <NSObject>

-(void)addProductImage:(WQProductColorCell *)cell;

@end