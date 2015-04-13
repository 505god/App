//
//  WQProImgItem.h
//  App
//
//  Created by 邱成西 on 15/4/8.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

///商品添加图片

@protocol WQProImgItemDelefate;

@interface WQProImgItem : UIImageView

@property (nonatomic, assign) id <WQProImgItemDelefate>delegate;

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image;
@end

@protocol WQProImgItemDelefate <NSObject>

-(void)deleteProItem:(WQProImgItem *)proItem;

@end