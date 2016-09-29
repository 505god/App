//
//  WQMessageContentButton.h
//  App
//
//  Created by 邱成西 on 15/5/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WQMessageContentButton : UIButton

//bubble imgae
@property (nonatomic, strong) UIImageView *backImageView;
//audio
@property (nonatomic, strong) UIView *voiceBackView;
@property (nonatomic, strong) UILabel *second;
@property (nonatomic, strong) UIImageView *voice;

@property (nonatomic, assign) BOOL isMyMessage;

- (void)didLoadVoice;

-(void)stopPlay;

@end
