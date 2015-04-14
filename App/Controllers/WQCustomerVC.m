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

#import "WQCustomerInfoVC.h"
#import "WQNewCustomerVC.h"

#import "MJRefresh.h"
#import "BlockAlertView.h"

#import "WQCustomerDetailVC.h"

@interface WQCustomerVC ()<WQCustomerTableDelegate,UISearchDisplayDelegate,WQNavBarViewDelegate>

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

-(void)testData {
    NSDictionary *aDic = [Utility returnDicByPath:@"CustomerList"];
    NSArray *array = [aDic objectForKey:@"customerList"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDic = (NSDictionary *)obj;
        WQCustomerObj *customerObj = [[WQCustomerObj alloc]init];
        [customerObj mts_setValuesForKeysWithDictionary:aDic];
        [weakSelf.customerList addObject:customerObj];
        SafeRelease(customerObj);
        SafeRelease(aDic);
    }];
    
    [WQDataShare sharedService].customerArray = [NSMutableArray arrayWithArray:self.customerList];
    
    if (self.customerList.count>0) {
        [[WQDataShare sharedService] sortCustomers:[WQDataShare sharedService].customerArray CompleteBlock:^(NSArray *array) {
            weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
            [weakSelf.tableView setHeaderAnimated:YES];
            [weakSelf.tableView reloadData];
            [weakSelf setNoneText:nil animated:NO];
        }];
    }else {
        [weakSelf.tableView setHeaderAnimated:NO];
        [weakSelf setNoneText:NSLocalizedString(@"NoneCustomer", @"") animated:YES];
    }
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    self.navBarView.titleLab.text = NSLocalizedString(@"CustomerVC", @"");
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addProperty"] forState:UIControlStateNormal];
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
        self.navBarView.titleLab.text = NSLocalizedString(@"SelectedProCustomers", @"");
        [self.navBarView.leftBtn setHidden:NO];
        
        [self setToolImage:@"compose_photograph_highlighted" text:NSLocalizedString(@"Finish", @"") animated:YES];
    }
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

#pragma mark - private

- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    [self.tableView.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf testData];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            // 结束刷新
            [weakSelf.tableView.tableView headerEndRefreshing];
        });
    } dateKey:@"WQCustomerVC"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
    //自动刷新(一进入程序就下拉刷新)
    [self.tableView.tableView headerBeginRefreshing];
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
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    //添加客户
}
#pragma mark - property

-(WQCustomerTable *)tableView {
    if (!_tableView) {
        _tableView = [[WQCustomerTable alloc] initWithFrame:self.isPresentVC?(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-20-self.navBarView.height*2}:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height}];
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
    return [self.dataArray[section][@"data"] count];
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
        //详细信息页面
        WQCustomerDetailVC *detailVC = [[WQCustomerDetailVC alloc]init];
        detailVC.customerObj = (WQCustomerObj *)self.dataArray[indexPath.section][@"data"][indexPath.row];
        [self.navigationController pushViewController:detailVC animated:YES];
        SafeRelease(detailVC);
    }
}

//确认选择
-(void)toolControlPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customerVC:didSelectCustomers:)]) {
        [self.delegate customerVC:self didSelectCustomers:self.selectedList];
    }
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

@end
