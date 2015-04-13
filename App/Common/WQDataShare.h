//
//  WQDataShare.h
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteBlock)(BOOL finished);

@interface WQDataShare : NSObject {
    CompleteBlock completeBlock;
}

@property (nonatomic, strong) AppDelegate *appDel;

//区分6、7statusBar高度
@property (nonatomic, assign) NSInteger statusHeight;

#pragma mark - 用户列表
@property (nonatomic, strong) NSMutableArray *customerArray;//用于搜索
@property (nonatomic, strong) NSMutableArray *customerList;//用于显示cell


+ (WQDataShare *)sharedService;

//获取客户列表
- (void)sortCustomers:(NSArray *)customers CompleteBlock:(CompleteBlock)complet;

@end
