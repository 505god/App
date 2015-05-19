//
//  WQMessageCell.h
//  App
//
//  Created by 邱成西 on 15/5/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WQMessageContentButton.h"
#import "WQMessageFrame.h"

@protocol WQMessageCellDelegate;

@interface WQMessageCell : UITableViewCell

@property (nonatomic, strong) UILabel *labelTime;
@property (nonatomic, strong) UILabel *labelNum;
@property (nonatomic, strong) UIButton *btnHeadImage;

@property (nonatomic, strong) WQMessageContentButton *btnContent;

@property (nonatomic, strong) WQMessageFrame *messageFrame;

@property (nonatomic, assign) id<WQMessageCellDelegate>delegate;

-(void)startPlay;
-(void)stopPlay;
@end

@protocol WQMessageCellDelegate <NSObject>

@optional
- (void)headImageDidClick:(WQMessageCell *)cell userId:(NSString *)userId;

-(void)playVoiceWithCell:(WQMessageCell *)cell sound:(NSString *)soundStr;
@end