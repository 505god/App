//
//  WQCodeVC.h
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

@interface WQCodeVC : BaseViewController

@property(nonatomic,strong)  UILabel* telLabel;
@property(nonatomic,strong)  UITextField* verifyCodeField;
@property(nonatomic,strong)  UILabel* timeLabel;
@property(nonatomic,strong)  UIButton* repeatSMSBtn;
@property(nonatomic,strong)  UIButton* submitBtn;


-(void)setPhone:(NSString*)phone AndAreaCode:(NSString*)areaCode;
-(void)submit;
-(void)CannotGetSMS;
@end
