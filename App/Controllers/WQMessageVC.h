//
//  WQMessageVC.h
//  App
//
//  Created by 邱成西 on 15/5/5.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"
#import "WQCustomerObj.h"
#import "WQInputFunctionView.h"

@interface WQMessageVC : BaseViewController<UITextViewDelegate,WQInputFunctionViewDelegate,WQDismissiveTextViewDelegate>

@property (nonatomic, strong) WQCustomerObj *customerObj;

@end
