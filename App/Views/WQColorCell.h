//
//  WQColorCell.h
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WQColorObj.h"

@protocol WQColorCellDelegate;

@interface WQColorCell : UITableViewCell

@property (nonatomic, assign) id<WQColorCellDelegate>delegate;

@property (nonatomic, strong) WQColorObj *colorObj;

@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, weak) IBOutlet UIButton *checkButton;

@end

@protocol WQColorCellDelegate <NSObject>

-(void)selectedColor:(WQColorObj *)colorObj animated:(BOOL)animated;

@end