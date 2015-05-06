//
//  WQMessageCell.m
//  App
//
//  Created by 邱成西 on 15/5/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMessageCell.h"

#import "UIButton+AFNetworking.h"
#import "WQMessageObj.h"
#import "WQPlayerManager.h"
#import "UIImageView+Addition.h"

@interface WQMessageCell ()<PlayingDelegate>
{
    UIView *headImageBackView;
    BOOL contentVoiceIsPlaying;
}
@end

@implementation WQMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.accessoryView = nil;
        
        // 1、创建时间
        self.labelTime = [[UILabel alloc] init];
        self.labelTime.textAlignment = NSTextAlignmentCenter;
        self.labelTime.textColor = [UIColor grayColor];
        self.labelTime.font = ChatTimeFont;
        [self.contentView addSubview:self.labelTime];
        
        // 2、创建头像
        headImageBackView = [[UIView alloc]init];
        headImageBackView.layer.cornerRadius = 22;
        headImageBackView.layer.masksToBounds = YES;
        headImageBackView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
        [self.contentView addSubview:headImageBackView];
        self.btnHeadImage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnHeadImage.layer.cornerRadius = 20;
        self.btnHeadImage.layer.masksToBounds = YES;
        [self.btnHeadImage addTarget:self action:@selector(btnHeadImageClick:)  forControlEvents:UIControlEventTouchUpInside];
        [headImageBackView addSubview:self.btnHeadImage];
        
        // 3、创建头像下标
        self.labelNum = [[UILabel alloc] init];
        self.labelNum.textColor = [UIColor grayColor];
        self.labelNum.textAlignment = NSTextAlignmentCenter;
        self.labelNum.font = ChatTimeFont;
        [self.contentView addSubview:self.labelNum];
        
        // 4、创建内容
        self.btnContent = [WQMessageContentButton buttonWithType:UIButtonTypeCustom];
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btnContent.titleLabel.font = ChatContentFont;
        self.btnContent.titleLabel.numberOfLines = 0;
        [self.btnContent addTarget:self action:@selector(btnContentClick)  forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btnContent];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(UUAVAudioPlayerDidFinishPlay) name:@"VoicePlayHasInterrupt" object:nil];
        
        //红外线感应监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:)
                                                     name:UIDeviceProximityStateDidChangeNotification
                                                   object:nil];
        contentVoiceIsPlaying = NO;
        
    }
    return self;
}
- (void)UUAVAudioPlayerDidFinishPlay {
    //关闭红外线感应
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    [WQPlayerManager sharedManager].delegate = nil;
    [[WQPlayerManager sharedManager] stopPlaying];
}

//内容及Frame设置
- (void)setMessageFrame:(WQMessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    // 1、设置时间
    self.labelTime.text = messageFrame.messageObj.messageDate;
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.btnHeadImage.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    [self.btnHeadImage setBackgroundImageForState:UIControlStateNormal
                                          withURL:[NSURL URLWithString:messageFrame.customerObj.customerHeader]
                                 placeholderImage:[UIImage imageNamed:@"headImage.jpeg"]];
    
    // 3、设置下标
    self.labelNum.text = messageFrame.customerObj.customerName;
    if (messageFrame.nameF.origin.x > 160) {
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x - 50, messageFrame.nameF.origin.y + 3, 100, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentRight;
    }else{
        self.labelNum.frame = CGRectMake(messageFrame.nameF.origin.x, messageFrame.nameF.origin.y + 3, 80, messageFrame.nameF.size.height);
        self.labelNum.textAlignment = NSTextAlignmentLeft;
    }
    
    // 4、设置内容
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;
    self.btnContent.frame = messageFrame.contentF;
    
    if (messageFrame.messageObj.fromType == WQMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentRight, ChatContentBottom, ChatContentLeft);
    }else{
        self.btnContent.isMyMessage = NO;
        [self.btnContent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        self.btnContent.contentEdgeInsets = UIEdgeInsetsMake(ChatContentTop, ChatContentLeft, ChatContentBottom, ChatContentRight);
    }
    
    //背景气泡图
    UIImage *normal;
    if (messageFrame.messageObj.fromType == WQMessageFromMe) {
        normal = [UIImage imageNamed:@"chatto_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 10, 10, 22)];
    }
    else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(35, 22, 10, 10)];
    }
    [self.btnContent setBackgroundImage:normal forState:UIControlStateNormal];
    [self.btnContent setBackgroundImage:normal forState:UIControlStateHighlighted];
 
    switch (messageFrame.messageObj.messageType) {
        case WQMessageTypeText:
            [self.btnContent setTitle:messageFrame.messageObj.messageContent forState:UIControlStateNormal];
            break;
        case WQMessageTypePicture:
        {
            self.btnContent.backImageView.hidden = NO;
            self.btnContent.backImageView.image = messageFrame.messageObj.messageImg;
            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
            [self makeMaskView:self.btnContent.backImageView withImage:normal];
        }
            break;
        case WQMessageTypeVoice:
        {
            self.btnContent.voiceBackView.hidden = NO;
//            self.btnContent.second.text = [NSString stringWithFormat:@"%@'s Voice",unionObj.messageObj.strVoiceTime];
        }
            break;
            
        default:
            break;
    }
}
- (void)makeMaskView:(UIView *)view withImage:(UIImage *)image
{
    UIImageView *imageViewMask = [[UIImageView alloc] initWithImage:image];
    imageViewMask.frame = CGRectInset(view.frame, 0.0f, 0.0f);
    view.layer.mask = imageViewMask.layer;
}


//头像点击
- (void)btnHeadImageClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:[NSString stringWithFormat:@"%d",self.messageFrame.customerObj.customerId]];
    }
}


- (void)btnContentClick{
    //play audio
    if (self.messageFrame.messageObj.messageType == WQMessageTypeVoice) {
        if(!contentVoiceIsPlaying){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VoicePlayHasInterrupt" object:nil];
            contentVoiceIsPlaying = YES;
            
            [[WQPlayerManager sharedManager] playAudioWithFileName:@"" delegate:self];
        }else{
            [WQPlayerManager sharedManager].delegate = nil;
            [[WQPlayerManager sharedManager] stopPlaying];
        }
    }
    //show the picture
    else if (self.messageFrame.messageObj.messageType == WQMessageTypePicture)
    {
        if (self.btnContent.backImageView) {
            [self.btnContent.backImageView showLargeImage];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.messageObj.messageType == WQMessageTypeText)
    {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}


//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    if ([[UIDevice currentDevice] proximityState] == YES){
        DLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else{
        DLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)playingStoped {
    contentVoiceIsPlaying = NO;
    [self.btnContent stopPlay];
    [WQPlayerManager sharedManager].delegate = nil;
    [[WQPlayerManager sharedManager] stopPlaying];
}
@end
