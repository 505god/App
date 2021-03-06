//
//  WQClassHeader.h
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSwipTableHeader.h"

#import "WQClassObj.h"
#import "WQCusGroupObj.h"

@interface WQClassHeader : WQSwipTableHeader

@property (nonatomic,assign) NSInteger aSection;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic, strong) WQClassObj *classObj;//分类
@property (nonatomic, strong) WQCusGroupObj *cusGroupObj;//客户数组

@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;

@end
