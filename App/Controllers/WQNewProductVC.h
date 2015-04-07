//
//  WQNewProductVC.h
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  @author 邱成西, 15-03-25 09:03:33
 *
 *  创建新产品
 */
@interface WQNewProductVC : BaseViewController<UITextFieldDelegate>

//编辑产品详情
@property (nonatomic, assign) BOOL isEditing;

@end
