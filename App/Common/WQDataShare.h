//
//  WQDataShare.h
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CompleteBlock)(NSArray *array);

@interface WQDataShare : NSObject {
    CompleteBlock completeBlock;
}

@property (nonatomic, strong) AppDelegate *appDel;

//区分6、7statusBar高度
@property (nonatomic, assign) NSInteger statusHeight;

//TODO:分类、颜色、尺码 放到单列里面
//分类
@property (nonatomic, strong) NSMutableArray *classArray;
//颜色
@property (nonatomic, strong) NSMutableArray *colorArray;
//尺码
@property (nonatomic, strong) NSMutableArray *sizeArray;

//客户户列表
@property (nonatomic, strong) NSMutableArray *customerArray;//用于搜索



+ (WQDataShare *)sharedService;

-(void)sortCustomers:(NSArray *)customers CompleteBlock:(CompleteBlock)complet;

@end
