//
//  WQClassHeader.h
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WQClassObj.h"

@protocol WQClassHeaderDelegate;

@interface WQClassHeader : UITableViewHeaderFooterView

@property (nonatomic, assign) id<WQClassHeaderDelegate>classDelegate;
@property (nonatomic,assign) NSInteger aSection;
@property (nonatomic,assign) BOOL isSelected;

@property (nonatomic, strong) WQClassObj *classObj;

@end

@protocol WQClassHeaderDelegate <NSObject>

@optional
-(void)headerDidSelectCoverOption:(WQClassHeader *)header;
-(void)headerDidLongPressedOption:(WQClassHeader *)header;
@end