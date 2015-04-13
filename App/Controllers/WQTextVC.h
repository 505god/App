//
//  WQTextVC.h
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

///创建分类、颜色、尺码

#import "WQClassObj.h"

@protocol WQTextVCDelegate;

@interface WQTextVC : UIViewController

@property (nonatomic, weak) IBOutlet UILabel *titleLab;
@property (nonatomic, weak) IBOutlet UITextField *text;
@property (nonatomic, weak) IBOutlet UIButton *btn;

///标题
@property (nonatomic, strong) NSString *titleString;
@property (nonatomic, assign) id<WQTextVCDelegate>delegate;

@property (nonatomic, assign) BOOL isLevelClass;
///type        0:创建    1:修改
@property (nonatomic, assign) NSInteger type;
///标记header位置
@property (nonatomic, strong) NSIndexPath *indexPath;
///输入框内容
@property (nonatomic, strong) NSString *textFieldText;

@property (nonatomic, assign) BOOL isEditing;

@end

@protocol WQTextVCDelegate <NSObject>

-(void)dismissTextVC:(WQTextVC *)textVC;

@end