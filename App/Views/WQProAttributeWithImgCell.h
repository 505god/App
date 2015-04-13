//
//  WQProAttributeWithImgCell.h
//  App
//
//  Created by 邱成西 on 15/4/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "RMSwipeTableViewCell.h"

///创建商品属性----带图片

#import "WQTapImg.h"
#import "WQColorObj.h"

#import "WQProductBtn.h"

#define DeleteBtnTag  100
#define SizeTextFieldTag   1000
#define PriceTextFieldTag  10000
#define StockTextFieldTag  100000

@class WQCreatProductVC;
@class WQProductBtn;

@protocol WQProAttributeWithImgCellDelegate;

@interface WQProAttributeWithImgCell : RMSwipeTableViewCell

@property (nonatomic, assign) id<WQProAttributeWithImgCellDelegate>attributeWithImgDelegate;

///商品图片
@property (nonatomic, strong) WQTapImg *proImgView;
///商品颜色
@property (nonatomic, strong) WQColorObj *colorObj;
@property (nonatomic, strong) WQProductBtn *colorBtn;

@property (nonatomic, strong) NSDictionary *dictionary;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) WQCreatProductVC *productVC;

@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;
@end

@protocol WQProAttributeWithImgCellDelegate <NSObject>

@optional
///选择颜色
-(void)selectedProductColor:(WQProductBtn *)colorBtn;
///添加图片
-(void)selectedProductImage:(WQProAttributeWithImgCell *)cell;
///添加尺码
-(void)selectedProductSize:(WQProductBtn *)sizeBtn;

///删除尺码、价格、库存
-(void)deleteProductSize:(WQProductBtn *)deleteBtn;
///添加尺码、价格、库存
-(void)addProductSize:(WQProductBtn *)addBtn;
@end