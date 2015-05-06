//
//  WQProductDetailVC.h
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

#import "WQProductObj.h"

@interface WQProductDetailVC : BaseViewController<UITextFieldDelegate>

@property (nonatomic, strong) WQProductObj *productObj;

@end
