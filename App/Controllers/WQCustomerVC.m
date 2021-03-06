//
//  WQCustomerVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerVC.h"

#import "WQIndexedCollationWithSearch.h"//检索
#import "WQCustomerTable.h"

#import "WQCustomerCell.h"

#import "WQCustomerObj.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

#import "MJRefresh.h"
#import "BlockAlertView.h"

#import "WQCustomerDetailVC.h"

#import "WQNewCustomerVC.h"
#import <MessageUI/MFMessageComposeViewController.h>

#import "WQCustomerGroupVC.h"

#import "DXPopover.h"
#import "WQCusFunctionCell.h"

@interface WQCustomerVC ()<WQCustomerTableDelegate,WQNavBarViewDelegate,WQCustomerDetailVCDelegate,WQNewCustomerVCDelegate,MFMessageComposeViewControllerDelegate,WQCusGroupVCDelegate,RMSwipeTableViewCellDelegate>

//通讯录列表
@property (nonatomic, strong) WQCustomerTable *tableView;
@property (nonatomic, strong) NSMutableArray *customerList;
@property (nonatomic, strong) NSMutableArray *dataArray;


@property (nonatomic, strong) UITableView *popTableView;
@property (nonatomic, strong) DXPopover *popover;
@end

@implementation WQCustomerVC

-(void)dealloc {
    SafeRelease(_delegate);
    SafeRelease(_selectedList);
    SafeRelease(_selectedIndexPath);
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView);
    SafeRelease(_customerList);
    SafeRelease(_dataArray);
    SafeRelease(_popover);
    SafeRelease(_popTableView.delegate);
    SafeRelease(_popTableView.dataSource);
    SafeRelease(_popTableView);
}

#pragma mark - 获取客户列表
-(void)getCustomerList {
    __unsafe_unretained typeof(self) weakSelf = self;
    self.interfaceTask = [[WQAPIClient sharedClient] GET:@"/rest/user/getStoreCustomers" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.customerList = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSArray *postsFromResponse = [jsonData objectForKey:@"returnObj"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQCustomerObj *customerObj = [[WQCustomerObj alloc] init];
                    [customerObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:customerObj];
                    SafeRelease(customerObj);
                }
                
                [weakSelf.customerList addObjectsFromArray:mutablePosts];
                [WQDataShare sharedService].customerArray = [NSMutableArray arrayWithArray:weakSelf.customerList];
                
                if (weakSelf.customerList.count>0) {
                    [[WQDataShare sharedService] sortCustomers:[WQDataShare sharedService].customerArray CompleteBlock:^(NSArray *array) {
                        weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
                        [weakSelf.tableView setHeaderAnimated:YES];
                    }];
                }
            }else {
                [Utility interfaceWithStatus:[[jsonData objectForKey:@"status"]integerValue] msg:[jsonData objectForKey:@"msg"]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf checkDataArray];
        [weakSelf.tableView.tableView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView.tableView headerEndRefreshing];
        [weakSelf checkDataArray];
    }];
}

-(void)checkDataArray {
    if (self.dataArray.count==0) {
        [self setNoneText:NSLocalizedString(@"NoneCustomer", @"") animated:YES];
    }else {
        [self setNoneText:nil animated:NO];
    }
}


#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"CustomerVC", @"")];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"customerMore"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"customerMoreNormal"] forState:UIControlStateHighlighted];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"customerMoreNormal"] forState:UIControlStateDisabled];
    
    [self.navBarView.leftBtn setHidden:YES];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    //集成刷新控件
    [self addHeader];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isPresentVC) {
        [self.navBarView setTitleString:NSLocalizedString(@"SelectedProCustomers", @"")];
        [self.navBarView.leftBtn setHidden:NO];
        [self.navBarView.rightBtn setHidden:YES];
        [self setToolImage:@"" text:NSLocalizedString(@"Finish", @"") animated:YES];
        
        self.toolControl.enabled = self.selectedList.count>0?YES:NO;
    }
    
    //数据
    if ([WQDataShare sharedService].customerArray.count>0) {
        self.customerList = [NSMutableArray arrayWithArray:[WQDataShare sharedService].customerArray];
        
        [[WQDataShare sharedService] sortCustomers:[WQDataShare sharedService].customerArray CompleteBlock:^(NSArray *array) {
            self.dataArray = [NSMutableArray arrayWithArray:array];
            [self.tableView setHeaderAnimated:YES];
            [self.tableView reloadData];
        }];
    }else {
        //自动刷新(一进入程序就下拉刷新)
        [self.tableView.tableView headerBeginRefreshing];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newMessage:) name:@"newMessage" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [WQAPIClient cancelConnection];
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"newMessage" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.tableView.tableView addHeaderWithCallback:^{
        
        [weakSelf getCustomerList];

    } dateKey:@"WQCustomerVC"];
}

#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    if (self.isPresentVC) {
        /*
        if (self.selectedList.count>0) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmCancelSelected", @"")];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert show];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
         */
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
//右侧边栏的代理---添加客户
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    self.navBarView.rightBtn.enabled = NO;
    CGPoint startPoint = CGPointMake(self.navBarView.rightBtn.right-15,self.navBarView.rightBtn.bottom+10);
    
    [self.popover showAtPoint:startPoint popoverPostion:DXPopoverPositionDown withContentView:self.popTableView inView:self.view];
    
    __weak typeof(self)weakSelf = self;
    self.popover.didDismissHandler = ^{
        weakSelf.navBarView.rightBtn.enabled = YES;
        [weakSelf bounceTargetView:weakSelf.navBarView.rightBtn];
    };
}


#pragma mark - property

-(WQCustomerTable *)tableView {
    if (!_tableView) {
        _tableView = [[WQCustomerTable alloc] initWithFrame:self.isPresentVC?(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-self.navBarView.height*2}:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height}];
        _tableView.delegate = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(NSMutableArray *)customerList {
    if (!_customerList) {
        _customerList = [[NSMutableArray alloc]init];
    }
    return _customerList;
}
-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    _selectedIndexPath = selectedIndexPath;
}

-(DXPopover *)popover {
    if (!_popover) {
        _popover = [DXPopover new];
    }
    return _popover;
}

-(UITableView *)popTableView {
    if (!_popTableView) {
        _popTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,120,88} style:UITableViewStylePlain];
        _popTableView.dataSource = self;
        _popTableView.delegate = self;
        _popTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _popTableView;
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.popTableView]) {
        return 0;
    }
    return 15;
}
- (NSArray *)sectionIndexTitlesForWQCustomerTable:(WQCustomerTable *)tableView {
    NSMutableArray * indexTitles = [NSMutableArray array];
    for (NSDictionary * sectionDictionary in self.dataArray) {
        [indexTitles addObject:sectionDictionary[@"indexTitle"]];
    }
    return indexTitles;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.popTableView]) {
        return nil;
    }
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.width, 15)];
    customView.backgroundColor = COLOR(230, 230, 230, 1);
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:(CGRect){10, 0.0, self.tableView.width-20, 15}];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.font = [UIFont systemFontOfSize:13];
    headerLabel.text = self.dataArray[section][@"indexTitle"];
    
    [customView addSubview:headerLabel];
    SafeRelease(headerLabel);
    
    return customView;
}


- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.popTableView]){
        return 1;
    }
    return self.dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.popTableView]) {
        return 2;
    }
    NSDictionary *aDic = (NSDictionary *)self.dataArray[section];
    NSArray *array = (NSArray *)aDic[@"data"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.popTableView]) {
        static NSString * identifier = @"WQCusFunctionViewCell";
        
        WQCusFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[WQCusFunctionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if (indexPath.row==0) {
            cell.textLabel.text = NSLocalizedString(@"selectedStar", @"");
        }else if (indexPath.row==1) {
            cell.textLabel.text = NSLocalizedString(@"CustomerNew", @"");
        }

        return cell;
    }else {
        static NSString * CellIdentifier = @"customer_cell";
        
        WQCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WQCustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:CellIdentifier];
        }
        
        [cell setSelectedType:0];
        
        WQCustomerObj *customer = nil;
        customer = (WQCustomerObj *)self.dataArray[indexPath.section][@"data"][indexPath.row];
        [cell setCustomerObj:customer];
        
        cell.delegate = self;
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
        
        //判断选择客户列表
        if (self.isPresentVC) {
            if ([self.selectedList containsObject:[NSString stringWithFormat:@"%ld",customer.customerId]]) {
                [cell setSelectedType:2];
            }else {
                [cell setSelectedType:1];
            }
        }
        
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.popTableView]) {
        return 44;
    }
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.popTableView]) {
        [self.popover dismiss];
        if (indexPath.row==0) {
            WQCustomerGroupVC *groupVC = [[WQCustomerGroupVC alloc]init];
            groupVC.delegate = self;
            [self.navigationController pushViewController:groupVC animated:YES];
            SafeRelease(groupVC);
        }else {
            WQNewCustomerVC *customerVC = [[WQNewCustomerVC alloc]init];
            customerVC.delegate = self;
            [self.navigationController pushViewController:customerVC animated:YES];
            SafeRelease(customerVC);
        }
    }else {
        if (self.isPresentVC) {
            //选择客户
            WQCustomerCell *cell = (WQCustomerCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            WQCustomerObj *customer = nil;
            customer = (WQCustomerObj *)self.dataArray[indexPath.section][@"data"][indexPath.row];
            if ([self.selectedList containsObject:[NSString stringWithFormat:@"%ld",customer.customerId]]) {
                [cell setSelectedType:1];
                [self.selectedList removeObject:[NSString stringWithFormat:@"%ld",customer.customerId]];
            }else {
                [cell setSelectedType:2];
                [self.selectedList addObject:[NSString stringWithFormat:@"%ld",customer.customerId]];
            }
            self.toolControl.enabled = self.selectedList.count>0?YES:NO;
        }else {
            WQCustomerObj *customerObj = (WQCustomerObj *)self.dataArray[indexPath.section][@"data"][indexPath.row];
            if (customerObj.customerResign) {//详细信息页面
                customerObj.regsinRedPoint = 0;
                
                [self.tableView.tableView beginUpdates];
                [self.tableView.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView.tableView endUpdates];
                
                WQCustomerDetailVC *detailVC = [[WQCustomerDetailVC alloc]init];
                detailVC.indexPath = indexPath;
                detailVC.delegate = self;
                detailVC.customerVC = self;
                detailVC.customerObj = customerObj;
                [self.navigationController pushViewController:detailVC animated:YES];
                SafeRelease(detailVC);
            }else {//发短信
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
                if([MFMessageComposeViewController canSendText])
                {
                    controller.body = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(@"customerCode",nil),customerObj.customerCode];
                    controller.recipients = @[customerObj.customerPhone];
                    controller.messageComposeDelegate = self;
                    [self presentViewController:controller animated:YES completion:^{
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    }];
                }
            }
        }
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    if (result == MessageComposeResultCancelled){
        DLog(@"Message cancelled");
    }else if (result == MessageComposeResultSent) {
        
    }
}
//确认选择
-(void)toolControlPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customerVC:didSelectCustomers:)]) {
        [self.delegate customerVC:self didSelectCustomers:self.selectedList];
    }
}

///客户信息被修改
-(void)customerDetailVC:(WQCustomerDetailVC *)detail customer:(WQCustomerObj *)customer {
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[detail.indexPath.section]];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:mutableDic[@"data"]];
    
    [mutableArray replaceObjectAtIndex:detail.indexPath.row withObject:customer];
    [mutableDic setObject:mutableArray forKey:@"data"];
    [self.dataArray replaceObjectAtIndex:detail.indexPath.section withObject:mutableDic];
    
    [self.tableView.tableView beginUpdates];
    [self.tableView.tableView reloadRowsAtIndexPaths:@[detail.indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView.tableView endUpdates];
    
    for (int i=0; i<self.customerList.count; i++) {
        WQCustomerObj *customerObj = (WQCustomerObj *)self.customerList[i];
        if (customerObj.customerId == customer.customerId) {
            [self.customerList replaceObjectAtIndex:i withObject:customer];
            [[WQDataShare sharedService].customerArray replaceObjectAtIndex:i withObject:customer];
            break;
        }
    }
    
    SafeRelease(mutableDic);SafeRelease(mutableArray);
}

//删除客户
-(void)deleteCustomer:(WQCustomerObj *)customer index:(NSIndexPath *)indexPath {
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[indexPath.section]];
    
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:mutableDic[@"data"]];
    
    [mutableArray removeObjectAtIndex:indexPath.row];
    
    if (mutableArray.count==0) {
        [self.dataArray removeObjectAtIndex:indexPath.section];
    }else {
        [mutableDic setObject:mutableArray forKey:@"data"];
        
        [self.dataArray replaceObjectAtIndex:indexPath.section withObject:mutableDic];
    }
    [self.tableView reloadData];
    
    
    for (int i=0; i<self.customerList.count; i++) {
        WQCustomerObj *customerObj = (WQCustomerObj *)self.customerList[i];
        if (customerObj.customerId == customer.customerId) {
            [self.customerList removeObjectAtIndex:i];
            [[WQDataShare sharedService].customerArray removeObjectAtIndex:i];
            break;
        }
    }
    
    SafeRelease(mutableDic);SafeRelease(mutableArray);
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [self.tableView.searchBar resignFirstResponder];
}
#pragma mark - search代理

- (void)searchBarTextDidBeginEditing:(UISearchBar *)search{
    search.showsCancelButton = YES;
    if (Platform>=7.0) {
        for(id cc in [search subviews]) {
            if([cc isKindOfClass:[UIView class]]) {
                UIView *cc_view = (UIView *)cc;
                for (id vv in [cc_view subviews]){
                    if([vv isKindOfClass:[UIButton class]]){
                        UIButton *btn = (UIButton *)vv;
                        [btn setTitle:@"取消"  forState:UIControlStateNormal];
                        [btn setTintColor:[UIColor lightGrayColor]];
                    }
                }
            }
        }
    }else {
        for(id cc in [search subviews]){
            if([cc isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTintColor:[UIColor lightGrayColor]];
            }
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)search{
    search.showsCancelButton=NO;
    search.text=nil;
    [search resignFirstResponder];
    
    [[WQDataShare sharedService] sortCustomers:self.customerList CompleteBlock:^(NSArray *array) {
        self.dataArray = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
    }];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *searchResults = [NSMutableArray array];
    
    if (searchBar.text.length>0 && ![ChineseInclude isIncludeChineseInString:searchBar.text]) {//英文或者数字搜素
        
        [self.customerList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WQCustomerObj *customer = (WQCustomerObj *)obj;
            
            if ([ChineseInclude isIncludeChineseInString:customer.customerName]) {//名称含有中文
                //转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:customer.customerName];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0 && ![searchResults containsObject:customer]) {
                    [searchResults addObject:customer];
                }
                
                //转换为拼音首字母
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:customer.customerName];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0 && ![searchResults containsObject:customer]) {
                    [searchResults addObject:customer];
                }
                
                //电话号码
                NSRange phoneResult=[customer.customerPhone rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (phoneResult.length>0 && ![searchResults containsObject:customer]) {
                    [searchResults addObject:customer];
                }
            }else {
                //昵称含有数字
                NSRange titleResult=[customer.customerName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:customer];
                }
                
                //电话号码
                NSRange phoneResult=[customer.customerPhone rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (phoneResult.length>0 && ![searchResults containsObject:customer]) {
                    [searchResults addObject:customer];
                }
            }
        }];
        
    } else if (searchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:searchBar.text]) {//中文搜索
        for (WQCustomerObj *customer in self.customerList) {
            NSRange titleResult=[customer.customerName rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:customer];
            }
        }
    }else if (searchBar.text.length == 0){
        [searchResults addObjectsFromArray:self.customerList];
    }
    
    [[WQDataShare sharedService] sortCustomers:searchResults CompleteBlock:^(NSArray *array) {
        self.dataArray = [NSMutableArray arrayWithArray:array];
        [self.tableView reloadData];
    }];
}

-(void)newMessage:(NSNotification *)notification  {    
    [self.tableView reloadData];
}

#pragma mark - 事件
- (void)bounceTargetView:(UIView *)targetView {
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        targetView.transform = CGAffineTransformIdentity;
    } completion:nil];
}
#pragma mark - 新客户代理

-(void)addNewCustomer:(WQCustomerObj *)customerObj {
    [self.customerList addObject:customerObj];
    [WQDataShare sharedService].customerArray = [NSMutableArray arrayWithArray:self.customerList];
    
    if (self.customerList.count>0) {
        [[WQDataShare sharedService] sortCustomers:[WQDataShare sharedService].customerArray CompleteBlock:^(NSArray *array) {
            self.dataArray = [NSMutableArray arrayWithArray:array];
            [self.tableView setHeaderAnimated:YES];
        }];
    }
    [self.tableView reloadData];
}

#pragma mark - 分星级显示客户  客户信息被修改

-(void)changeCustomerInfo:(WQCustomerObj *)customer {
    
    for (int i=0; i<self.customerList.count; i++) {
        WQCustomerObj *cusObj = (WQCustomerObj *)self.customerList[i];
        
        if (cusObj.customerId==customer.customerId) {
            
            [self.customerList replaceObjectAtIndex:i withObject:customer];
            [WQDataShare sharedService].customerArray = nil;
            [WQDataShare sharedService].customerArray = [NSMutableArray arrayWithArray:self.customerList];
            
            [[WQDataShare sharedService] sortCustomers:[WQDataShare sharedService].customerArray CompleteBlock:^(NSArray *array) {
                self.dataArray = [NSMutableArray arrayWithArray:array];
                [self.tableView reloadData];
            }];
        }
    }
}



//删除颜色
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewCell.contentView.height) {
        
        NSIndexPath *indexPath = [self.tableView.tableView indexPathForCell:swipeTableViewCell];
        
        WQCustomerObj *customer = nil;
        customer = (WQCustomerObj *)self.dataArray[indexPath.section][@"data"][indexPath.row];
        
        swipeTableViewCell.shouldAnimateCellReset = YES;
        
        __unsafe_unretained typeof(self) weakSelf = self;
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"" message:NSLocalizedString(@"DeleteCustomer", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:^{
            
        }];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 swipeTableViewCell.contentView.frame = CGRectOffset(swipeTableViewCell.contentView.bounds, swipeTableViewCell.contentView.frame.size.width, 0);
                             }
                             completion:^(BOOL finished) {
                                 [[WQAPIClient sharedClient] POST:@"/rest/user/delCustomer" parameters:@{@"userId":[NSNumber numberWithInteger:customer.customerId]} success:^(NSURLSessionDataTask *task, id responseObject) {
                                     
                                     if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                         NSDictionary *jsonData=(NSDictionary *)responseObject;
                                         
                                         if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                                             NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:weakSelf.dataArray[indexPath.section]];
                                             
                                             NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:mutableDic[@"data"]];
                                             
                                             [mutableArray removeObjectAtIndex:indexPath.row];
                                             
                                             if (mutableArray.count==0) {
                                                 [weakSelf.dataArray removeObjectAtIndex:indexPath.section];
                                             }else {
                                                 [mutableDic setObject:mutableArray forKey:@"data"];
                                                 
                                                 [weakSelf.dataArray replaceObjectAtIndex:indexPath.section withObject:mutableDic];
                                             }
                                             [weakSelf.tableView reloadData];
                                             
                                             
                                             for (int i=0; i<weakSelf.customerList.count; i++) {
                                                 WQCustomerObj *customerObj = (WQCustomerObj *)weakSelf.customerList[i];
                                                 if (customerObj.customerId == customer.customerId) {
                                                     [weakSelf.customerList removeObjectAtIndex:i];
                                                     [[WQDataShare sharedService].customerArray removeObjectAtIndex:i];
                                                     break;
                                                 }
                                             }
                                             
                                             SafeRelease(mutableDic);SafeRelease(mutableArray);
                                             
                                         }else {
                                             [Utility interfaceWithStatus:[[jsonData objectForKey:@"status"]integerValue] msg:[jsonData objectForKey:@"msg"]];
                                         }
                                     }
                                     
                                 } failure:^(NSURLSessionDataTask *task, NSError *error) {

                                 }];
                             }];
        }];
        [alert show];
    }
}

@end
