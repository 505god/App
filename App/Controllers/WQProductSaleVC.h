//
//  WQProductSaleVC.h
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

@protocol WQProductSaleVCDelegate;

@interface WQProductSaleVC : BaseViewController<UITextFieldDelegate>

@property (nonatomic, assign) id<WQProductSaleVCDelegate>delegate;

@property (nonatomic, strong) NSMutableDictionary *objectDic;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
//最低价格
@property (nonatomic, strong) NSString *lowPrice;
@end

@protocol WQProductSaleVCDelegate <NSObject>

-(void)selectedSale:(WQProductSaleVC *)saleVC object:(NSDictionary *)dictionary;

@end