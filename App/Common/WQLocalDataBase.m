//
//  WQLocalDataBase.m
//  App
//
//  Created by 邱成西 on 15/4/22.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQLocalDataBase.h"

#import <sys/xattr.h>

@implementation WQLocalDataBase
-(id)init {
    if (self = [super init]) {
        //paths： ios下Document路径，Document为ios中可读写的文件夹
        NSFileManager *filemgr =[NSFileManager defaultManager];
        if (Platform>5.0) {
            //如果系统是5.0.1及其以上这么干
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"Application"];
            
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO){
            }
            
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:newDir]];
            
            //dbPath： 数据库路径，在Document中。
            NSString *dbPath = [newDir stringByAppendingPathComponent:@"WQApp.db"];
            //创建数据库实例 db  这里说明下:如果路径中不存在"AiMeiYue.db"的文件,sqlite会自动创建"AiMeiYue.db"
            self.db = [FMDatabase databaseWithPath:dbPath] ;
            
        }else{
            
            //如果系统是5.0及其以上这么干
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"Application"];
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO){
            }
            
            //dbPath： 数据库路径，在Document中。
            NSString *dbPath = [newDir stringByAppendingPathComponent:@"WQApp.db"];
            //创建数据库实例 db  这里说明下:如果路径中不存在"AiMeiYue.db"的文件,sqlite会自动创建"AiMeiYue.db"
            self.db = [FMDatabase databaseWithPath:dbPath] ;
        }
        
        if (![self.db open]) {
            self.db = nil;
        }else
            [self.db open];
        
        //用户
        FMResultSet *rs = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'WQUser'"];
        
        if (![rs next]) {
            [rs close];
            [self.db executeUpdate:@"CREATE TABLE WQUser (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE ,userId VARCHAR,userName VARCHAR,userHead VARCHAR,moneyType VARCHAR,password VARCHAR,userPhone VARCHAR)"];
        }
        [rs close];
        rs = nil;
        
        //最近联系人
        FMResultSet *rsCustomer = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'WQCustomer'"];
        
        if (![rsCustomer next]) {
            [rsCustomer close];
            [self.db executeUpdate:@"CREATE TABLE WQCustomer (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE ,customerId VARCHAR,customerName VARCHAR,customerPhone VARCHAR,customerHeader VARCHAR,customerArea VARCHAR,customerDegree VARCHAR,customerCode VARCHAR,customerRemark VARCHAR,customerShield VARCHAR)"];
        }
        [rsCustomer close];
        rsCustomer = nil;
        
        //消息
        FMResultSet *rsMessage = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'WQMessage'"];
        
        if (![rsMessage next]) {
            [rsMessage close];
            [self.db executeUpdate:@"CREATE TABLE WQMessage (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE ,messageFrom VARCHAR,messageTo VARCHAR,messageContent VARCHAR,messageDate VARCHAR,messageType VARCHAR)"];
        }
        [rsMessage close];
        rsMessage = nil;
    }
    return self;
}
//添加不用备份的属性5.0.1
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL {
    
    if (Platform>=5.1) {//5.1的阻止备份
        
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
        }
        return success;
    }else if (Platform>5.0 && Platform<5.1){//5.0.1的阻止备份
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }else {
        return 0;
    }
    return YES;
}
-(void)dealloc{
    SafeRelease(_db);
}
@end
