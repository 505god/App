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
#import "WQClassLevelObj.h"

@interface WQRightCell : RMSwipeTableViewCell

@property (nonatomic, assign) BOOL isLevel;
///用于编辑时标记位置
@property (nonatomic, strong) NSIndexPath *indexPath;
///标题
@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UIImageView *lineView;

///分类
@property (nonatomic, strong) WQClassObj *classObj;

@property (nonatomic, strong) WQClassLevelObj *levelClassObj;
///颜色
@property (nonatomic, strong) WQColorObj *colorObj;
///尺码
@property (nonatomic, strong) WQSizeObj *sizeObj;

@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;

///选择时 0=隐藏  1=normal  2=highted
@property (nonatomic, assign) NSInteger selectedType;
@end