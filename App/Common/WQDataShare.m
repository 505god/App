//
//  WQDataShare.m
//  App
//
//  Created by 邱成西 on 15/2/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQDataShare.h"

#import "WQCustomerObj.h"
#import "WQIndexedCollationWithSearch.h"//检索
#import "PinYinForObjc.h"

@implementation WQDataShare

- (id)init{
    self = [super init];
    if (self) {
        self.appDel = [AppDelegate shareIntance];
    }
    return self;
}
+ (WQDataShare *)sharedService {
    static dispatch_once_t once;
    static WQDataShare *dataService = nil;
    
    dispatch_once(&once, ^{
        dataService = [[super alloc] init];
    });
    return dataService;
}

#pragma mark -property

-(NSMutableArray *)customerArray {
    if (!_customerArray) {
        _customerArray = [[NSMutableArray alloc]init];
    }
    return _customerArray;
}
-(NSMutableArray *)classArray {
    if (!_classArray) {
        _classArray = [[NSMutableArray alloc]init];
    }
    return _classArray;
}
-(NSMutableArray *)colorArray {
    if (!_colorArray) {
        _colorArray = [[NSMutableArray alloc]init];
    }
    return _colorArray;
}
-(NSMutableArray *)sizeArray {
    if (!_sizeArray) {
        _sizeArray = [[NSMutableArray alloc]init];
    }
    return _sizeArray;
}


#pragma mark -
/**
 *  @author 邱成西, 15-02-12 14:02:19
 *
 *  A-Z，按照姓名进行排序
 *
 *  @return 27个空数组
 */
- (NSMutableArray *)emptyPartitionedArray {
    NSUInteger sectionCount = [[[WQIndexedCollationWithSearch currentCollation] sectionTitles] count];
    NSMutableArray *sections = [NSMutableArray arrayWithCapacity:sectionCount];
    for (int i = 0; i < sectionCount; i++) {
        [sections addObject:[NSMutableArray array]];
    }
    return sections;
}

/**
 *  @author 邱成西, 15-02-12 14:02:25
 *
 *  对客户列表进行自定义，方便页面排版
 *
 *  @param customers 按照A－Z排好序的客户列表
 */
-(void)setupCustomerList:(NSArray *)customers {
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc]init];
    
    [customers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSArray *array = (NSArray *)obj;
        
        if (array.count>0) {
            NSMutableDictionary *aDic = [NSMutableDictionary dictionary];
            [aDic setObject:array forKey:@"data"];
            
            WQCustomerObj *customer = (WQCustomerObj *)array[0];
            
            NSString *nameSection = [[NSString stringWithFormat:@"%c",[[PinYinForObjc chineseConvertToPinYin:customer.customerName] characterAtIndex:0]]uppercaseString];
            
            NSString *nameRegex = @"^[a-zA-Z]+$";
            NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
            if ([nameTest evaluateWithObject:nameSection]) {//字母
                [aDic setObject:nameSection forKey:@"indexTitle"];
            }else {
                [aDic setObject:@"#" forKey:@"indexTitle"];
            }
            
            [mutableArray addObject:aDic];
        }
    }];
    
    if (completeBlock) {
        completeBlock(mutableArray);
        SafeRelease(mutableArray);
    }
}

/**
 *  @author 邱成西, 15-02-12 14:02:40
 *
 *  对客户列表按照A－Z进行排序
 *
 *  @param customers 客户列表
 */
- (void)sortCustomers:(NSArray *)customers CompleteBlock:(CompleteBlock)complet{
    completeBlock = [complet copy];
    
    NSMutableArray *mutableArray = [[self emptyPartitionedArray] mutableCopy];
    //添加分类
    for (WQCustomerObj *customer in customers) {
        SEL selector = @selector(customerName);
        NSInteger index = [[WQIndexedCollationWithSearch currentCollation]
                           sectionForObject:customer
                           collationStringSelector:selector];
        [mutableArray[index] addObject:customer];
    }
    
    [self setupCustomerList:mutableArray];
}

@end
