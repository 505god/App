//
//  WQRecorderManager.h
//  App
//
//  Created by 邱成西 on 15/4/29.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Encapsulator.h"

@protocol WQRecorderManagerDelegate <NSObject>

- (void)recordingFinishedWithFileName:(NSString *)filePath voiceName:(NSString *)name time:(NSTimeInterval)interval;
- (void)recordingTimeout;
- (void)recordingStopped;  //录音机停止采集声音
- (void)recordingFailed:(NSString *)failureInfoString;

@optional
- (void)levelMeterChanged:(float)levelMeter;

@end

@interface WQRecorderManager : NSObject<EncapsulatingDelegate>
{
    Encapsulator *encapsulator;
    NSString *filename;
    NSDate *dateStartRecording;
    NSDate *dateStopRecording;
    NSTimer *timerLevelMeter;
    NSTimer *timerTimeout;
    
    //名称
    NSString *voiceName;
}

@property (nonatomic, assign)  id<WQRecorderManagerDelegate> delegate;
@property (nonatomic, strong) Encapsulator *encapsulator;
@property (nonatomic, strong) NSDate *dateStartRecording, *dateStopRecording;
@property (nonatomic, strong) NSTimer *timerLevelMeter;
@property (nonatomic, strong) NSTimer *timerTimeout;

+ (WQRecorderManager *)sharedManager;

- (void)startRecording;

- (void)stopRecording;

- (void)cancelRecording;

- (NSTimeInterval)recordedTimeInterval;
@end
