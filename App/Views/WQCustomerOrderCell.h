//
//  WQCustomerOrderCell.h
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQCustomerOrderObj.h"

@protocol WQCustomerOrderCellDelegate;

@interface WQCustomerOrderCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

///type:0=全部 1=待付款 2=待发货 3=待收货 4=已关闭 9=客户
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) WQCustomerOrderObj *orderObj;

@property (nonatomic, assign) id<WQCustomerOrderCellDelegate>delegate;
@end

@protocol WQCustomerOrderCellDelegate <NSObject>

@optional

-(void)cancelOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj;
-(void)payOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj;
-(void)editPriceOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj;
-(void)alertOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj;
-(void)deliveryOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj;
-(void)receiveOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj;

@end