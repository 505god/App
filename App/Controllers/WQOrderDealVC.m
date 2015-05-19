//
//  WQOrderDealVC.m
//  App
//
//  Created by 邱成西 on 15/4/16.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQOrderDealVC.h"
#import "MJRefresh.h"
#import "WQCustomerOrderObj.h"
#import "WQCustomerOrderCell.h"

#import "BlockAlertView.h"
#import "BlockTextPromptAlertView.h"


@interface WQOrderDealVC ()<UITableViewDelegate,UITableViewDataSource,RMSwipeTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;


///当前页开始索引
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger lastOrderId;
///分页基数---默认10
@property (nonatomic, assign) NSInteger limit;
///总页数
@property (nonatomic, assign) NSInteger pageCount;
@end

@implementation WQOrderDealVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
}

#pragma mark - 获取订单列表

-(void)getOrderList {
    __unsafe_unretained typeof(self) weakSelf = self;
    self.interfaceTask = [[WQAPIClient sharedClient] GET:@"/rest/order/orderList" parameters:@{@"lastOrderId":[NSNumber numberWithInteger:self.lastOrderId],@"count":[NSNumber numberWithInteger:self.limit],@"orderStatus":@"1"} success:^(NSURLSessionDataTask *task, id responseObject) {
        
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
                NSInteger orderNumber = [[aDic objectForKey:@"pageCount"]integerValue];
                
                if (weakSelf.pageCount<0) {
                    weakSelf.pageCount = orderNumber;
                }
                
                [weakSelf.dataArray addObjectsFromArray:mutablePosts];
                if (weakSelf.dataArray.count>0) {
                    [weakSelf.tableView reloadData];
                    [weakSelf setNoneText:nil animated:NO];
                }else {
                    [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
                }
                
                if ((weakSelf.start+weakSelf.limit)<weakSelf.pageCount) {
                    [weakSelf.tableView removeFooter];
                    [weakSelf addFooter];
                }else {
                    [weakSelf.tableView removeFooter];
                }
            }else {
                [weakSelf.tableView removeFooter];
                [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.limit = 10;
    
    //集成刷新控件
    [self addHeader];
    [self.tableView headerBeginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
            weakSelf.lastOrderId = [orderObj.orderId integerValue];
        }
        
        [weakSelf getOrderList];
    }];
}

#pragma mark - tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQCustomerOrderVCCell";
    
    WQCustomerOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQCustomerOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.revealDirection = RMSwipeTableViewCellRevealDirectionBoth;
    cell.delegate = self;
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[indexPath.row];
    
    [cell setIndexPath:indexPath];
    [cell setType:1];
    [cell setOrderObj:orderObj];
    
    return cell;
}

#pragma mark -
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[indexPath.row];
    
    if (point.x >= 50) {
        UITextField *textField;
        BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"orderChangePrice", @"") message:nil textField:&textField type:1 block:^(BlockTextPromptAlertView *alert){
            [alert.textField resignFirstResponder];
            return YES;
        }];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            [[WQAPIClient sharedClient] POST:@"/rest/order/changeOrderPrice" parameters:@{@"orderId":orderObj.orderId,@"price":textField.text} success:^(NSURLSessionDataTask *task, id responseObject) {
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *jsonData=(NSDictionary *)responseObject;
                    
                    if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                        orderObj.orderPrice = [textField.text floatValue];
                        
                        [self.tableView beginUpdates];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView endUpdates];
                    }else {
                        [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                    }
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
            }];
        }];
        [alert show];
    }else if (point.x < 0 && -point.x >= 50) {
        swipeTableViewCell.shouldAnimateCellReset = YES;
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            swipeTableViewCell.shouldAnimateCellReset = NO;
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 swipeTableViewCell.contentView.frame = CGRectOffset(swipeTableViewCell.contentView.bounds, swipeTableViewCell.contentView.frame.size.width, 0);
                             }completion:^(BOOL finished) {
                                 
                                 [[WQAPIClient sharedClient] POST:@"/rest/order/delOrder" parameters:@{@"orderId":orderObj.orderId} success:^(NSURLSessionDataTask *task, id responseObject) {
                                     
                                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         NSDictionary *jsonData=(NSDictionary *)responseObject;
                                         
                                         if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                                             [self.dataArray removeObjectAtIndex:indexPath.row];
                                             if (self.dataArray.count==0) {
                                                 [self setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
                                             }
                                             [self.tableView reloadData];
                                         }else {
                                             [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                                         }
                                     }
                                     
                                 } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                     [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
                                 }];
                             }];
        }];
        [alert show];
    }
}

@end
