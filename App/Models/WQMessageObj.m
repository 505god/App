//
//  WQMessageObj.m
//  App
//
//  Created by 邱成西 on 15/4/29.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMessageObj.h"
#import "NSDate+Utils.h"

@implementation WQMessageObj

+(WQMessageObj *)messageFromDictionary:(NSDictionary *)aDic {
    WQMessageObj *message = [[WQMessageObj alloc]init];
    
    message.messageFrom = [aDic[@"messageFrom"]integerValue];
    message.messageTo = [aDic[@"messageTo"]integerValue];
    message.messageContent = aDic[@"messageContent"];
    message.messageType = [aDic[@"messageType"] integerValue];
    message.messageDate = aDic[@"messageDate"];
    
    if (message.messageFrom == [WQDataShare sharedService].userObj.userId) {
        message.fromType = WQMessageFromMe;
    }else {
        message.fromType = WQMessageFromOther;
    }
    
    return message;
}

//"08-10 晚上08:09:41.0" ->
//"昨天 上午10:09"或者"2012-08-10 凌晨07:09"
- (NSString *)changeTheDateString:(NSString *)Str {
    NSDate *lastDate = [NSDate dateFromString:Str withFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *dateStr;  //年月日
    NSString *period;   //时间段
    NSString *hour;     //时
    
    if ([lastDate year]==[[NSDate date] year]) {
        NSInteger days = [NSDate daysOffsetBetweenStartDate:lastDate endDate:[NSDate date]];
        if (days <= 2) {
            dateStr = [lastDate stringYearMonthDayCompareToday];
        }else{
            dateStr = [lastDate stringMonthDay];
        }
    }else{
        dateStr = [lastDate stringYearMonthDay];
    }
    
    
    if ([lastDate hour]>=5 && [lastDate hour]<12) {
        period = @"AM";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }else if ([lastDate hour]>=12 && [lastDate hour]<=18){
        period = @"PM";
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else if ([lastDate hour]>18 && [lastDate hour]<=23){
        period = NSLocalizedString(@"Night", @"");
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]-12];
    }else{
        period = NSLocalizedString(@"Dawn", @"");
        hour = [NSString stringWithFormat:@"%02d",(int)[lastDate hour]];
    }
    return [NSString stringWithFormat:@"%@ %@ %@:%02d",dateStr,period,hour,(int)[lastDate minute]];
}

//显示日期与否
- (void)minuteOffSetStart:(NSString *)start end:(NSString *)end {
    if (!start) {
        self.showDateLabel = YES;
        self.messageShowDate = [self changeTheDateString:self.messageDate];
        return;
    }
    
    NSDate *startDate = [NSDate dateFromString:start withFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *endDate = [NSDate dateFromString:end withFormat:@"yyyy-MM-dd HH:mm"];
    
    //这个是相隔的秒数
    NSTimeInterval timeInterval = [startDate timeIntervalSinceDate:endDate];
    
    //相距5分钟显示时间Label
    if (fabs (timeInterval) > 5*60) {
        self.showDateLabel = YES;
        self.messageShowDate = [self changeTheDateString:self.messageDate];
    }else{
        self.showDateLabel = NO;
    }
}

//语音处理
- (void)getSoundPath {
    if (self.messageType==2) {
        NSRange range = NSMakeRange(6, 14);
        NSString *fileName = [self.messageContent substringWithRange:range];
        if (self.messageFrom != [WQDataShare sharedService].userObj.userId){
            fileName = [fileName stringByAppendingString:@"from"];
            NSString *filePath = [self defaultFileNameWithVoice:fileName];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if (![fileManager fileExistsAtPath:filePath]) {
                NSString *dataStr = [self.messageContent substringFromIndex:22];
                
                NSData *nsdataFromBase64String = [[NSData alloc]
                                                  initWithBase64EncodedString:dataStr options:0];
                
                [fileManager createFileAtPath:filePath contents:nsdataFromBase64String attributes:nil];
                SafeRelease(dataStr);SafeRelease(nsdataFromBase64String);
            }
            self.messageVoicePath = fileName;
        }else {
            self.messageVoicePath = fileName;
        }
        
        NSRange timeRange = NSMakeRange(20, 2);
        NSString *timeStr = [self.messageContent substringWithRange:timeRange];
        self.messageContent = timeStr;
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
@end
