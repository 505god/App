//
//  WQAddProductCell.h
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol WQAddProductCellDelegate;

@interface WQAddProductCell : UIButton

@property (nonatomic, assign) id<WQAddProductCellDelegate>delegate;

@property (nonatomic, strong) UIImage *image;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andName:(NSString *)name;

@end

@protocol WQAddProductCellDelegate<NSObject>

// 通知cell被点击，执行删除操作
- (void) unitCellTouched:(WQAddProductCell *)unitCell;

@end