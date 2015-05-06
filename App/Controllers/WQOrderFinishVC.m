//
//  WQOrderFinishVC.m
//  App
//
//  Created by 邱成西 on 15/4/16.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQOrderFinishVC.h"
#import "MJRefresh.h"
#import "WQCustomerOrderObj.h"
#import "WQCustomerOrderProObj.h"
#import "WQOrderHeader.h"
#import "WQCustomerOrderCell.h"

#import "BlockAlertView.h"

static NSInteger showCount = 0;

@interface WQOrderFinishVC ()<UITableViewDelegate,UITableViewDataSource,WQSwipTableHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arrSelSection;

///分页基数---默认10
@property (nonatomic, assign) NSInteger limit;
///当前页开始索引
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger lastOrderId;
///总页数
@property (nonatomic, assign) NSInteger pageCount;
@end

@implementation WQOrderFinishVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_arrSelSection);
}
#pragma mark - 获取订单列表

-(void)getOrderList {
    __unsafe_unretained typeof(self) weakSelf = self;
    self.interfaceTask = [WQAPIClient getOrderListWithParameters:@{@"lastOrderId":[NSNumber numberWithInteger:self.lastOrderId],@"count":[NSNumber numberWithInteger:self.limit],@"orderStatus":@"3"} block:^(NSArray *array, NSInteger pageCount, NSError *error) {
        
        if (!error) {
            if (weakSelf.pageCount<0) {
                weakSelf.pageCount = pageCount;
            }
            
            [weakSelf.dataArray addObjectsFromArray:array];
            if (weakSelf.dataArray.count>0) {
                [weakSelf.tableView reloadData];
                [weakSelf setNoneText:nil animated:NO];
            }else {
                [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
            }
            
            if ((weakSelf.start/10+1)<self.pageCount) {
                [weakSelf.tableView removeFooter];
                [weakSelf addFooter];
            }else {
                [weakSelf.tableView removeFooter];
            }
        }else {
            [weakSelf.tableView removeFooter];
        }
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    }];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstShow = YES;
    
    //集成刷新控件
    [self addHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (showCount>0 && self.isFirstShow) {
        self.isFirstShow = NO;
        [self.tableView headerBeginRefreshing];
    }
    showCount ++;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WQOrderHeader class] forHeaderFooterViewReuseIdentifier:@"WQOrderHeader"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSMutableArray *)arrSelSection {
    if (!_arrSelSection) {
        _arrSelSection = [[NSMutableArray alloc]init];
    }
    return _arrSelSection;
}
#pragma mark - private

// 添加下拉刷新头部控件
- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addHeaderWithCallback:^{
        weakSelf.dataArray = nil;
        weakSelf.start = 0;
        weakSelf.lastOrderId = 0;
        weakSelf.pageCount = -1;
        
        
        [weakSelf getOrderList];
    } dateKey:@"WQOrderDealVC"];
}
// 添加上拉刷新尾部控件
- (void)addFooter {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        weakSelf.start += weakSelf.limit;
        if (weakSelf.dataArray.count>0) {
            WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)[weakSelf.dataArray lastObject];
            weakSelf.lastOrderId = orderObj.orderId;
        }
        
        [weakSelf getOrderList];
    }];
}


#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==self.dataArray.count-1) {
        return 0;
    }
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WQOrderHeader *header = (WQOrderHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WQOrderHeader"];
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[section];
    [header setOrderObj:orderObj];
    header.delegate = self;
    header.aSection = section;
    header.type=3;
    header.revealDirection = WQSwipTableHeaderRevealDirectionRight;
    BOOL isSelSection = NO;
    for (int i = 0; i < self.arrSelSection.count; i++) {
        if (section == [self.arrSelSection[i] integerValue]) {
            isSelSection = YES;
            break;
        }
    }
    header.isSelected = isSelSection;
    
    return header;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.width, 10)];
    customView.backgroundColor = COLOR(235, 235, 241, 1);
    
    return customView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (int i = 0; i < self.arrSelSection.count; i++) {
        if (section == [self.arrSelSection[i] integerValue]) {
            WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[section];
            return orderObj.productList.count;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQCustomerOrderVCCell";
    
    WQCustomerOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQCustomerOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[indexPath.section];
    
    WQCustomerOrderProObj *proObj = (WQCustomerOrderProObj *)orderObj.productList[indexPath.row];
    
    [cell setOrderProductObj:proObj];
    
    return cell;
}

#pragma mark -

-(void)editDidTapPressedOption:(WQSwipTableHeader *)Header {
    WQOrderHeader *header = (WQOrderHeader *)Header;
    
    //判断打开还是关闭
    BOOL isSelSection = NO;
    if (self.arrSelSection.count>0) {
        
        for (int i=0; i<self.arrSelSection.count; i++) {
            if ([self.arrSelSection[i] integerValue]==header.aSection) {//包含
                isSelSection = YES;
                break;
            }
        }
    }
    
    if (!isSelSection) {//关闭状态
        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[header.aSection];
        if (orderObj.productList.count>0) {
            [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",header.aSection]];
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }else {//打开状态
        [self.arrSelSection removeObject:[NSString stringWithFormat:@"%d",header.aSection]];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

-(void)swipeTableViewHeaderWillResetState:(WQSwipTableHeader*)swipeTableViewHeader fromPoint:(CGPoint)point animation:(WQSwipTableHeaderAnimationType)animation velocity:(CGPoint)velocity  {
    
    WQOrderHeader *header = (WQOrderHeader *)swipeTableViewHeader;
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[header.aSection];
    
    if (point.x < 0 && -point.x >= 50) {
        header.shouldAnimateCellReset = YES;
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            header.shouldAnimateCellReset = NO;
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 header.frame = CGRectOffset(header.bounds, header.width, 0);
                             }completion:^(BOOL finished) {
                                 [WQAPIClient deleteOrderWithParameters:@{@"orderId":orderObj.orderCode} block:^(NSInteger finished, NSError *error) {
                                     [self.dataArray removeObjectAtIndex:header.aSection];
                                     if ([self.arrSelSection containsObject:[NSString stringWithFormat:@"%d",header.aSection]]) {
                                         [self.arrSelSection removeObject:[NSString stringWithFormat:@"%d",header.aSection]];
                                     }
                                     if (self.dataArray.count==0) {
                                         [self setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
                                     }
                                     [self.tableView reloadData];
                                 }];
                             }];
        }];
        [alert show];
    }
}
@end
