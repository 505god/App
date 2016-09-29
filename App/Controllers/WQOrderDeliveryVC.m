//
//  WQOrderDeliveryVC.m
//  App
//
//  Created by 邱成西 on 15/5/22.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQOrderDeliveryVC.h"
#import "MJRefresh.h"
#import "WQCustomerOrderObj.h"

#import "WQCustomerOrderCell.h"

#import "BlockAlertView.h"
#import "BlockTextPromptAlertView.h"

static NSInteger showCount = 0;

@interface WQOrderDeliveryVC ()<UITableViewDelegate,UITableViewDataSource,WQCustomerOrderCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;


///分页基数---默认10
@property (nonatomic, assign) NSInteger limit;
///当前页开始索引
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger lastOrderId;
///总页数
@property (nonatomic, assign) NSInteger pageCount;
///加载更多
@property (nonatomic, assign) BOOL isLoadingMore;

@end

@implementation WQOrderDeliveryVC


-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
}
#pragma mark - 获取订单列表

-(void)getOrderList {
    __unsafe_unretained typeof(self) weakSelf = self;
    self.interfaceTask = [[WQAPIClient sharedClient] GET:@"/rest/order/orderList" parameters:@{@"lastOrderId":[NSNumber numberWithInteger:self.lastOrderId],@"count":[NSNumber numberWithInteger:self.limit],@"orderStatus":@"2"} success:^(NSURLSessionDataTask *task, id responseObject) {
        if (weakSelf.isLoadingMore==NO) {
        weakSelf.dataArray = nil;
        }
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"orderList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQCustomerOrderObj *orderObj = [[WQCustomerOrderObj alloc] init];
                    [orderObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:orderObj];
                    SafeRelease(orderObj);
                }
                NSInteger orderNumber = [[aDic objectForKey:@"totalOrder"]integerValue];
                
                if (weakSelf.pageCount<0) {
                    weakSelf.pageCount = orderNumber;
                }
                
                [weakSelf.dataArray addObjectsFromArray:mutablePosts];
                
                if ((weakSelf.start+weakSelf.limit)<weakSelf.pageCount) {
                    if (weakSelf.isLoadingMore == NO) {
                        [weakSelf addFooter];
                    }
                }else {
                    [weakSelf.tableView removeFooter];
                }
            }else {
                weakSelf.start = (weakSelf.start-weakSelf.limit)<0?0:weakSelf.start-weakSelf.limit;
                [Utility interfaceWithStatus:[[jsonData objectForKey:@"status"]integerValue] msg:[jsonData objectForKey:@"msg"]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf checkDataArray];
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        weakSelf.start = (weakSelf.start-weakSelf.limit)<0?0:weakSelf.start-weakSelf.limit;
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf checkDataArray];
    }];
}

-(void)checkDataArray {
    if (self.dataArray.count==0) {
        [self setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
    }else {
        [self setNoneText:nil animated:NO];
    }
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstShow = YES;
    self.limit = 10;
    //集成刷新控件
    [self addHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    if ([WQDataShare sharedService].pushType != WQPushTypeNone && self.isFirstShow) {
//        [self.tableView headerBeginRefreshing];
//        self.isFirstShow = NO;
//    }else {
        if (showCount>0 && self.isFirstShow) {
            self.isFirstShow = NO;
            [self.tableView headerBeginRefreshing];
        }
        showCount ++;
//    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [WQAPIClient cancelConnection];
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - private

// 添加下拉刷新头部控件
- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addHeaderWithCallback:^{
        
        weakSelf.start = 0;
        weakSelf.lastOrderId = 0;
        weakSelf.pageCount = -1;
        weakSelf.isLoadingMore = NO;
        [weakSelf.tableView removeFooter];
        
        [weakSelf getOrderList];
    } dateKey:@"WQOrderDeliveryVC"];
}
// 添加上拉刷新尾部控件
- (void)addFooter {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        weakSelf.start += weakSelf.limit;
        if (weakSelf.dataArray.count>0) {
            WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)[weakSelf.dataArray lastObject];
            weakSelf.lastOrderId = [orderObj.orderId integerValue];
        }
        weakSelf.isLoadingMore = YES;
        [weakSelf getOrderList];
    }];
}

#pragma mark - tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 235;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQCustomerOrderVCCell";
    
    WQCustomerOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQCustomerOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setIndexPath:indexPath];
    [cell setType:2];
    cell.delegate = self;
    if (self.dataArray.count>0) {
        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[indexPath.row];
        [cell setOrderObj:orderObj];
    }
    return cell;
}

#pragma mark -
//卖家发货后修改订单状态为发货
-(void)deliveryOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj {
     
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"" message:NSLocalizedString(@"deliveryOrder", @"")];
     
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:^{
         
    }];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
         
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[WQAPIClient sharedClient] POST:@"/rest/order/orderShipment" parameters:@{@"orderId":orderObj.orderId} success:^(NSURLSessionDataTask *task, id responseObject) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    [self.dataArray removeObjectAtIndex:cell.indexPath.row];
                    [self checkDataArray];
                    [self.tableView reloadData];
                }else {
                    [Utility interfaceWithStatus:[[jsonData objectForKey:@"status"]integerValue] msg:[jsonData objectForKey:@"msg"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
        
    }];
    [alert show];
}

@end
