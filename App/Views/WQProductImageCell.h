//
//  WQProductImageCell.h
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WQProductImageCellDelegate;

@interface WQProductImageCell : UITableViewCell

@property (nonatomic, assign) id<WQProductImageCellDelegate>delegate;

//新添产品图片数组
-(void)addProductImages:(NSArray *)images;

//产品详情数组
-(void)setImages:(NSArray *)imageArray;

@end

@protocol WQProductImageCellDelegate <NSObject>

-(void)addNewProductWithCell:(WQProductImageCell *)cell;

-(void)addNewProductImage:(UIImage *)image;

-(void)removeProductImage:(UIImage *)image;
@end