//
//  WQMessageCell.m
//  App
//
//  Created by 邱成西 on 15/5/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMessageCell.h"

#import "UIButton+WebCache.h"
#import "WQMessageObj.h"


@interface WQMessageCell ()<WQTapImgDelegate> {
    UIView *headImageBackView;
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
        
        self.headerImg = [[WQTapImg alloc]initWithFrame:CGRectZero];
        self.headerImg.layer.cornerRadius = 20;
        self.headerImg.layer.masksToBounds = YES;
        self.headerImg.delegate = self;
        [headImageBackView addSubview:self.headerImg];
        
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
    }
    return self;
}
//内容及Frame设置
- (void)setMessageFrame:(WQMessageFrame *)messageFrame{
    
    _messageFrame = messageFrame;
    // 1、设置时间
    self.labelTime.text = messageFrame.messageObj.messageShowDate;
    self.labelTime.frame = messageFrame.timeF;
    
    // 2、设置头像
    headImageBackView.frame = messageFrame.iconF;
    self.headerImg.frame = CGRectMake(2, 2, ChatIconWH-4, ChatIconWH-4);
    if (messageFrame.messageObj.fromType == WQMessageFromMe) {
        [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,messageFrame.customerObj.customerHeader]] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    }else {
        [self.headerImg setImage:[UIImage imageNamed:@"header"]];
    }
    
    // 4、设置内容
    [self.btnContent setTitle:@"" forState:UIControlStateNormal];
    self.btnContent.voiceBackView.hidden = YES;
    self.btnContent.backImageView.hidden = YES;
    self.btnContent.frame = messageFrame.contentF;
    
    if (messageFrame.messageObj.fromType == WQMessageFromMe) {
        self.btnContent.isMyMessage = YES;
        [self.btnContent setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(28, 11, 30, 13)];
    }
    else{
        normal = [UIImage imageNamed:@"chatfrom_bg_normal"];
        normal = [normal resizableImageWithCapInsets:UIEdgeInsetsMake(28, 13, 30, 11)];
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
            [self.btnContent.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,messageFrame.messageObj.messageContent]] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
            self.btnContent.backImageView.frame = CGRectMake(0, 0, self.btnContent.frame.size.width, self.btnContent.frame.size.height);
            [self makeMaskView:self.btnContent.backImageView withImage:normal];
        }
            break;
        case WQMessageTypeVoice:
        {
            self.btnContent.voiceBackView.hidden = NO;
            self.btnContent.second.text = [NSString stringWithFormat:@"%@''",messageFrame.messageObj.messageContent];
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
- (void)tappedWithObject:(id) sender{
    if ([self.delegate respondsToSelector:@selector(headImageDidClick:userId:)])  {
        [self.delegate headImageDidClick:self userId:[NSString stringWithFormat:@"%d",self.messageFrame.customerObj.customerId]];
    }
}

-(NSString *)defaultFileNameWithVoice:(NSString *)name {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *voiceDirectory = [documentsDirectory stringByAppendingPathComponent:@"voice"];
    if ( ! [[NSFileManager defaultManager] fileExistsAtPath:voiceDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:voiceDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    return [voiceDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.spx",name]];
}

- (void)btnContentClick{
    //play audio
    if (self.messageFrame.messageObj.messageType == WQMessageTypeVoice) {
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playVoiceWithCell:sound:)]) {
            [self.delegate playVoiceWithCell:self sound:[self defaultFileNameWithVoice:self.messageFrame.messageObj.messageVoicePath]];
        }
    }
    //show the picture
    else if (self.messageFrame.messageObj.messageType == WQMessageTypePicture) {
        if (self.btnContent.backImageView) {
            [Utility showImage:self.btnContent.backImageView];
        }
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [[(UIViewController *)self.delegate view] endEditing:YES];
        }
    }
    // show text and gonna copy that
    else if (self.messageFrame.messageObj.messageType == WQMessageTypeText) {
        [self.btnContent becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setTargetRect:self.btnContent.frame inView:self.btnContent.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

-(void)startPlay {
    [self.btnContent didLoadVoice];
}
-(void)stopPlay {
    [self.btnContent stopPlay];
}
@end
