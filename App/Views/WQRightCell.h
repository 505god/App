//
//  WQRightCell.h
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "RMSwipeTableViewCell.h"

#import "WQClassObj.h"
#import "WQColorObj.h"
#import "WQSizeObj.h"

@interface WQRightCell : RMSwipeTableViewCell

///标题
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *lineView;

///分类
@property (nonatomic, strong) WQClassObj *classObj;
///颜色
@property (nonatomic, strong) WQColorObj *colorObj;
///尺码
@property (nonatomic, strong) WQSizeObj *sizeObj;

@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;
@end
