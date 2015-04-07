//
//  WQMainRightCell.h
//  App
//
//  Created by 邱成西 on 15/4/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQMainRightCell : UITableViewCell

///店铺头像
@property (nonatomic, strong) UIImageView *headerImageView;

///标题
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;


@property (nonatomic, strong) UIImageView *lineView;
@property (nonatomic, strong) UIImageView *directionImage;

//头像链接
-(void)setHeaderImageViewImage:(NSString *)header;
@end
