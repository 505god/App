//
//  WQProductDetailVC.h
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

#import "WQProductObj.h"

@protocol WQProductDetailVCDelegate;

@interface WQProductDetailVC : BaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) WQProductObj *productObj;

@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) id<WQProductDetailVCDelegate>delegate;
@end

@protocol WQProductDetailVCDelegate <NSObject>
@optional
-(void)editWQProductDetailVC:(WQProductDetailVC *)productDetailVC indexPath:(NSIndexPath *)indexPath;
-(void)deleteWQProductDetailVC:(WQProductDetailVC *)productDetailVC indexPath:(NSIndexPath *)indexPath;

@end