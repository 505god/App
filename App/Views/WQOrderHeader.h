//
//  WQOrderHeader.h
//  App
//
//  Created by 邱成西 on 15/4/16.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WQSwipTableHeader.h"
#import "WQCustomerOrderObj.h"

@interface WQOrderHeader : WQSwipTableHeader

@property (nonatomic,assign) NSInteger aSection;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) WQCustomerOrderObj *orderObj;

@property (nonatomic, strong) UIImageView *editGreyImageView;
@property (nonatomic, strong) UIImageView *editRedImageView;

@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;
@end
