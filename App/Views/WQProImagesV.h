//
//  WQProImagesV.h
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

//添加商品图片

@protocol WQProImagesVDelegate;

@interface WQProImagesV : UIView

@property (nonatomic, assign) id<WQProImagesVDelegate>delegate;

- (void)addNewUnit:(UIImage *)image withName:(NSString *)name;

@end

@protocol WQProImagesVDelegate <NSObject>

-(void)addNewProduct;

//添加产品图片
-(void)addNewImage:(UIImage *)image;

//删除产品图片
-(void)removeImage:(UIImage *)image;
@end