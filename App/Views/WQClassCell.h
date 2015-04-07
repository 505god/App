//
//  WQClassCell.h
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "RMSwipeTableViewCell.h"

#import "WQProductObj.h"

@interface WQClassCell : RMSwipeTableViewCell

@property (nonatomic, strong) WQProductObj *productObj;

///设置热卖
@property (nonatomic, assign) BOOL isHotSale;
///不是热卖
@property (nonatomic, strong) UIImageView *hotSaleGreyImageView;
///是热卖
@property (nonatomic, strong) UIImageView *hotSaleGreenImageView;
@property (nonatomic, strong) UIView *hotSaleView;
-(void)setIsHotSale:(BOOL)isHotSale;

///设置上架
@property (nonatomic, assign) BOOL isToSale;
///未上架
@property (nonatomic, strong) UIImageView *toSaleGreyImageView;
///上架了
@property (nonatomic, strong) UIImageView *toSaleRedImageView;
-(void)setIsToSale:(BOOL)isToSale;
@end
