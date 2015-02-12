//
//  WQSizeVC.h
//  App
//
//  Created by 邱成西 on 15/2/12.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

//尺码

@protocol WQSizeVCDelegate;

@interface WQSizeVC : BaseViewController

@property (nonatomic, assign) id<WQSizeVCDelegate>delegate;

@property (nonatomic, assign) BOOL isPresentVC;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, strong) NSMutableArray *selectedList;

@end

@protocol WQSizeVCDelegate <NSObject>
@optional

- (void)sizeVC:(WQSizeVC *)sizeVC didSelectSize:(NSArray *)sizes;


@end