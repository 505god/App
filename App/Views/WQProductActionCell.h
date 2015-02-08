//
//  WQProductActionCell.h
//  App
//
//  Created by 邱成西 on 15/2/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQProductActionCellDelegate;

@interface WQProductActionCell : UITableViewCell

@property (nonatomic, assign) id<WQProductActionCellDelegate>delegate;

@property (nonatomic, weak) IBOutlet UILabel *titleLab;
@property (nonatomic, weak) IBOutlet UILabel *infoLab;
@property (nonatomic, weak) IBOutlet UIImageView *imgView;
@property (nonatomic, weak) IBOutlet UISwitch *switchBtn;
@end

@protocol WQProductActionCellDelegate <NSObject>

-(void)setProductHot:(BOOL)isHot;

@end