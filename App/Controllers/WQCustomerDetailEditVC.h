//
//  WQCustomerDetailEditVC.h
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

#import "WQStarView.h"
#import "WQSwitch.h"

#import "WQCustomerObj.h"

@class WQCustomerVC;

@protocol WQCustomerDetailEditVCDelegate;

@interface WQCustomerDetailEditVC : BaseViewController<UITextFieldDelegate,WQStarViewDelegate>

@property (nonatomic, strong) WQCustomerObj *customerObj;

@property (nonatomic, assign) id<WQCustomerDetailEditVCDelegate>delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) WQCustomerVC *customerVC;

-(void)switchChanged:(WQSwitch *)sender;
@end


@protocol WQCustomerDetailEditVCDelegate <NSObject>
@optional
//保存
-(void)saveCustomerInfo:(WQCustomerObj *)customer;
//删除
-(void)deleteCustomer:(WQCustomerObj *)customer index:(NSIndexPath *)indexPath;
@end