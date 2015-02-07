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

-(void)addProductImages:(NSArray *)images;

@end

@protocol WQProductImageCellDelegate <NSObject>

-(void)addNewProductWithCell:(WQProductImageCell *)cell;

-(void)addNewProductImage:(UIImage *)image;

-(void)removeProductImage:(UIImage *)image;
@end