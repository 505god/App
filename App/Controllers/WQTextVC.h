//
//  WQTextVC.h
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

///创建分类、颜色、尺码


@protocol WQTextVCDelegate;

@interface WQTextVC : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLab;
@property (nonatomic, weak) IBOutlet UITextField *text;
@property (nonatomic, weak) IBOutlet UIButton *btn;


@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) id<WQTextVCDelegate>delegate;

@end

@protocol WQTextVCDelegate <NSObject>

-(void)dismissTextVC:(WQTextVC *)textVC;

@end