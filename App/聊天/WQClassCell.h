//
//  WQClassCell.h
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "RMSwipeTableViewCell.h"

#import "WQClassLevelObj.h"

@interface WQClassCell : RMSwipeTableViewCell

@property (nonatomic, strong) WQClassLevelObj *levelClassObj;

@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;

@end
