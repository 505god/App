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

@interface WQCustomerVC ()<WQCustomerTableDelegate,WQNavBarViewDelegate,WQCustomerDetailVCDelegate,WQNewCustomerVCDelegate,MFMessageComposeViewControllerDelegate>

//通讯录列表
@property (nonatomic, strong) WQCustomerTable *tableView;
@property (nonatomic, strong) NSMutableArray *customerList;
@property (nonatomic, strong) NSMutableArray *dataArray;


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
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf checkDataArray];
        [weakSelf.tableView.tableView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView.tableView headerEndRefreshing];
        [weakSelf checkDataArray];
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

-(void)checkDataArray {
    if (self.dataArray.count==0) {
        [self setNoneText:NSLocalizedString(@"NoneCustomer", @"") animated:YES];
    }else {
        [self setNoneText:nil animated:NO];
    }
}

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
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"CustomerVC", @"")];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addProperty"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addPropertyNormal"] forState:UIControlStateHighlighted];
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
    WQNewCustomerVC *customerVC = [[WQNewCustomerVC alloc]init];
    customerVC.delegate = self;
    [self.navigationController pushViewController:customerVC animated:YES];
    SafeRelease(customerVC);
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
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
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
    return self.dataArray.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *aDic = (NSDictionary *)self.dataArray[section];
    NSArray *array = (NSArray *)aDic[@"data"];
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = @"customer_cell";
    
    WQCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WQCustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
    }
    
    [cell setSelectedType:0];
    
    WQCustomerObj *customer = nil;
    customer = (WQCustomerObj *)self.dataArray[indexPath.section][@"data"][indexPath.row];
    [cell setCustomerObj:customer];
    
    
    //判断选择客户列表
    if (self.isPresentVC) {
        if ([self.selectedList containsObject:[NSString stringWithFormat:@"%d",customer.customerId]]) {
            [cell setSelectedType:2];
        }else {
            [cell setSelectedType:1];
        }
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isPresentVC) {
        //选择客户
        WQCustomerCell *cell = (WQCustomerCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        WQCustomerObj *customer = nil;
        customer = (WQCustomerObj *)self.dataArray[indexPath.section][@"data"][indexPath.row];
        if ([self.selectedList containsObject:[NSString stringWithFormat:@"%d",customer.customerId]]) {
            [cell setSelectedType:1];
            [self.selectedList removeObject:[NSString stringWithFormat:@"%d",customer.customerId]];
        }else {
            [cell setSelectedType:2];
            [self.selectedList addObject:[NSString stringWithFormat:@"%d",customer.customerId]];
        }
        self.toolControl.enabled = self.selectedList.count>0?YES:NO;
    }else {
        WQCustomerObj *customerObj = (WQCustomerObj *)self.dataArray[indexPath.section][@"data"][indexPath.row];
        if (customerObj.customerResign) {//详细信息页面
            WQCustomerDetailVC *detailVC = [[WQCustomerDetailVC alloc]init];
            detailVC.indexPath = indexPath;
            detailVC.delegate = self;
            detailVC.customerVC = self;
            detailVC.customerObj = customerObj;
            [self.navigationController pushViewController:detailVC animated:YES];
            SafeRelease(detailVC);
        }else {//发短信
            MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
            if([MFMessageComposeViewController canSendText])
            {
                controller.body = @"hi";
                controller.recipients = @[customerObj.customerPhone];
                controller.messageComposeDelegate = self;
                [self presentViewController:controller animated:YES completion:nil];
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

@end
