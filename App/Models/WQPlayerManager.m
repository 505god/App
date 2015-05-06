//
//  WQPlayerManager.m
//  App
//
//  Created by 邱成西 on 15/4/29.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQPlayerManager.h"

@interface WQPlayerManager ()

- (void)startProximityMonitering;  //开启距离感应器监听(开始播放时)
- (void)stopProximityMonitering;   //关闭距离感应器监听(播放完成时)

@end

@implementation WQPlayerManager
@synthesize decapsulator;
@synthesize avAudioPlayer;

static WQPlayerManager *mPlayerManager = nil;
+ (WQPlayerManager *)sharedManager {
    @synchronized(self) {
        if (mPlayerManager == nil)
        {
            mPlayerManager = [[WQPlayerManager alloc] init];
            
            [[NSNotificationCenter defaultCenter] addObserver:mPlayerManager
                                                     selector:@selector(sensorStateChange:)
                                                         name:@"UIDeviceProximityStateDidChangeNotification"
                                                       object:nil];
        }
    }
    return mPlayerManager;
}

+ (id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if(mPlayerManager == nil)
        {
            mPlayerManager = [super allocWithZone:zone];
            return mPlayerManager;
        }
    }
    
    return nil;
}

- (id)init {
    if (self = [super init]) {
        
        //初始化播放器的时候如下设置
        UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
        
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //默认情况下扬声器播放
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        [audioSession setActive:YES error:nil];
    }
    return self;
}

- (void)playAudioWithFileName:(NSString *)filename delegate:(id<PlayingDelegate>)newDelegate {
    if ( ! filename) {
        return;
    }
    if ([filename rangeOfString:@".spx"].location != NSNotFound) {
        [[AVAudioSession sharedInstance] setActive:YES error:nil];
        
        [self stopPlaying];
        self.delegate = newDelegate;
        
        self.decapsulator = [[Decapsulator alloc] initWithFileName:filename];
        self.decapsulator.delegate = self;
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
        [self.decapsulator play];
        
        [self startProximityMonitering];
    }
    else if ([filename rangeOfString:@".mp3"].location != NSNotFound) {
        if ( ! [[NSFileManager defaultManager] fileExistsAtPath:filename]) {
            DLog(@"要播放的文件不存在:%@", filename);
            [self.delegate playingStoped];
            [newDelegate playingStoped];
            return;
        }
        [self.delegate playingStoped];
        self.delegate = newDelegate;
        
        NSError *error;
        self.avAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filename] error:&error];
        if (self.avAudioPlayer) {
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            [[AVAudioSession sharedInstance] setActive:YES error:nil];
            self.avAudioPlayer.delegate = self;
            [self.avAudioPlayer play];
            [self startProximityMonitering];
        }
        else {
            [self.delegate playingStoped];
        }
    }
    else {
        [self.delegate playingStoped];
    }
}

- (void)stopPlaying {
    [self stopProximityMonitering];
    
    if (self.decapsulator) {
        [self.decapsulator stopPlaying];
        //        self.decapsulator.delegate = nil;   //此行如果放在上一行之前会导致回调问题
        self.decapsulator = nil;
    }
    if (self.avAudioPlayer) {
        [self.avAudioPlayer stop];
        self.avAudioPlayer = nil;
        
        //        [self.delegate playingStoped];
    }
    
    [self.delegate playingStoped];
}

- (void)decapsulatingAndPlayingOver {
    [self.delegate playingStoped];
    [self stopProximityMonitering];
}

- (void)sensorStateChange:(NSNotification *)notification {
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗
    if ([[UIDevice currentDevice] proximityState] == YES) {
        DLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else {
        DLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)startProximityMonitering {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
    DLog(@"开启距离监听");
}

- (void)stopProximityMonitering {
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
    DLog(@"关闭距离监听");
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
