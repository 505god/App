//
//  WQPlayerManager.h
//  App
//
//  Created by 邱成西 on 15/4/29.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "Decapsulator.h"

@protocol PlayingDelegate <NSObject>

- (void)playingStoped;

@end

@interface WQPlayerManager : NSObject<DecapsulatingDelegate, AVAudioPlayerDelegate>

@property (nonatomic, strong) Decapsulator *decapsulator;
@property (nonatomic, strong) AVAudioPlayer *avAudioPlayer;
@property (nonatomic, assign)  id<PlayingDelegate> delegate;

+ (WQPlayerManager *)sharedManager;

- (void)playAudioWithFileName:(NSString *)filename delegate:(id<PlayingDelegate>)newDelegate;
- (void)stopPlaying;
@end
