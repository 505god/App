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

#import "JKUtil.h"


@interface WQCustomerVC ()<WQCustomerTableDelegate,UISearchDisplayDelegate,WQCustomerCellDelegate>

//通讯录列表
@property (nonatomic, strong) WQCustomerTable *tableView;

@property (nonatomic, assign) BOOL isSearching;
@property (nonatomic, strong) UISearchDisplayController *searchController;

@end

@implementation WQCustomerVC

-(void)dealloc {
}

// 创建tableView
- (void) createTableView {
    self.tableView = [[WQCustomerTable alloc] initWithFrame:(CGRect){0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height-64}];
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = NSLocalizedString(@"CustomerVC", @"");
    
    //导航栏设置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(addNewCustomer)];
    
    if ([WQDataShare sharedService].customerList.count>0) {
        if (!self.tableView) {
            [self createTableView];
            
            [self setupSearchBar];
        }else
            [self.tableView reloadData];
    }else {
//        [[WQDataShare sharedService] getCustomerListCompleteBlock:^(BOOL finished) {
//            if (!self.tableView) {
//                [self createTableView];
//                
//                [self setupSearchBar];
//            }else
//                [self.tableView reloadData];
//        }];
    }
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupNavBar];
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

//present出的view设置navbar
-(void)setupNavBar {
    if (self.isPresentVC) {        
        UINavigationBar *navBar = self.navigationController.navigationBar;
        [navBar setBarTintColor:COLOR(57, 164, 247, 1)];
        
        navBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,nil];
        
        self.navigationItem.title = @"选择客户";
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0, 0, 50, 30);
        [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [rightBtn setTitleColor:[JKUtil getColor:@"828689"] forState:UIControlStateHighlighted];
        [rightBtn setTitleColor:[JKUtil getColor:@"828689"] forState:UIControlStateDisabled];
        [rightBtn addTarget:self action:@selector(finishSelectedCustomers) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        [self.navigationItem setRightBarButtonItem:rightItem animated:NO];
        self.navigationItem.rightBarButtonItem.enabled = (self.selectedList.count>0);
        SafeRelease(rightBtn);
        SafeRelease(rightItem);
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 50, 30);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[JKUtil getColor:@"828689"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelEventDidTouched) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        [self.navigationItem setLeftBarButtonItem:cancelItem animated:NO];
        SafeRelease(cancelBtn);
        SafeRelease(cancelItem);
    }
}

-(void)finishSelectedCustomers {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customerVC:didSelectCustomers:)]) {
        [self.delegate customerVC:self didSelectCustomers:self.selectedList];
    }
}

-(void)cancelEventDidTouched {
    if (self.delegate && [self.delegate respondsToSelector:@selector(customerVCDidCancel:)]) {
        [self.delegate customerVCDidCancel:self];
    }
}
//添加客户
- (void)addNewCustomer {
    WQNewCustomerVC *newVC = LOADVC(@"WQNewCustomerVC");
    [self.navigationController pushViewController:newVC animated:YES];
     
    SafeRelease(newVC);
}
#pragma mark - property

#pragma mark - 设置searchBar

-(void)setupSearchBar {    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.tableView.searchBar contentsController:self];
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.delegate = self;
    
    if ([self.searchController.searchBar respondsToSelector : @selector (barTintColor)]){
        if (Platform>=7.1){
            [[[[self.searchController.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [self.searchController.searchBar setBackgroundColor:[UIColor lightGrayColor]];
        }else{//7.0
            [self.searchController.searchBar setBarTintColor :[UIColor clearColor]];
            [self.searchController.searchBar setBackgroundColor :[UIColor lightGrayColor]];
        }
    }else {//7.0以下
        [[self.searchController.searchBar.subviews objectAtIndex:0] removeFromSuperview];
        
        [self.searchController.searchBar setBackgroundColor:[UIColor lightGrayColor]];
    }
}

#pragma mark - UITableViewDataSource

- (NSArray *)sectionIndexTitlesForWQCustomerTable:(WQCustomerTable *)tableView {
    NSMutableArray * indexTitles = [NSMutableArray array];
    for (NSDictionary * sectionDictionary in [WQDataShare sharedService].customerList) {
        [indexTitles addObject:sectionDictionary[@"indexTitle"]];
    }
    return indexTitles;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [WQDataShare sharedService].customerList[section][@"indexTitle"];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [WQDataShare sharedService].customerList.count;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[WQDataShare sharedService].customerList[section][@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = @"customer_cell";
    
    WQCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WQCustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WQCustomerObj *customer = nil;
    customer = (WQCustomerObj *)[WQDataShare sharedService].customerList[indexPath.section][@"data"][indexPath.row];
    [cell setCustomerObj:customer];
    cell.delegate = self;
    
    //判断选择客户列表
    if (self.isPresentVC) {
        [cell.checkButton setHidden:NO];
        
        if ([self.selectedList containsObject:[NSString stringWithFormat:@"%d",customer.customerId]]) {
            [cell setIsSelected:YES];
        }else {
            [cell setIsSelected:NO];
        }
    }
    
//    //判断
//    if (indexPath.row==0) {
//        [cell.notificationHub setCount:5];
//        [cell.notificationHub bump];
//    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - WQCustomerCellDelegate

//点击头像浏览客户信息
-(void)tapCellWithCustomer:(WQCustomerObj *)customer {
    WQCustomerInfoVC *infoVC = LOADVC(@"WQCustomerInfoVC");
    infoVC.customerObj = customer;
    [self.navigationController pushViewController:infoVC animated:YES];
     
    SafeRelease(infoVC);
}

//选中客户
-(void)selectedCustomer:(WQCustomerObj *)customer animated:(BOOL)animated {
    if (animated) {
        [self.selectedList addObject:[NSString stringWithFormat:@"%d",customer.customerId]];
    }else {
        [self.selectedList removeObject:[NSString stringWithFormat:@"%d",customer.customerId]];
    }
    self.navigationItem.rightBarButtonItem.enabled = (self.selectedList.count>0);
}
#pragma mark - search代理

- (void)searchBarTextDidBeginEditing:(UISearchBar *)search{
    self.isSearching = YES;
    search.showsCancelButton = YES;
    if (Platform>=7.0) {
        for(id cc in [search subviews]) {
            if([cc isKindOfClass:[UIView class]]) {
                UIView *cc_view = (UIView *)cc;
                for (id vv in [cc_view subviews]){
                    if([vv isKindOfClass:[UIButton class]]){
                        UIButton *btn = (UIButton *)vv;
                        [btn setTitle:@"取消"  forState:UIControlStateNormal];
                        [btn setTintColor:[UIColor whiteColor]];
                    }
                }
            }
        }
    }else {
        for(id cc in [search subviews]){
            if([cc isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTintColor:[UIColor blackColor]];
            }
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)search{
    self.isSearching = NO;
    search.showsCancelButton=NO;
    search.text=nil;
    [search resignFirstResponder];
    
    [[WQDataShare sharedService] sortCustomers:[WQDataShare sharedService].customerArray CompleteBlock:^(BOOL finished) {
        [self.tableView reloadData];
    }];
    
}
- (void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    
}
- (void) searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    self.isSearching = NO;
    
    self.tableView.searchBar.showsCancelButton=NO;
    self.tableView.searchBar.text=nil;
    [self.tableView.searchBar resignFirstResponder];
    
    [[WQDataShare sharedService] sortCustomers:[WQDataShare sharedService].customerArray CompleteBlock:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    return YES;
}
- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller{
    
}
- (void)searchBar:(UISearchBar *)aSearch textDidChange:(NSString *)searchText {
    NSMutableArray *searchResults = [NSMutableArray array];
    
    if (aSearch.text.length>0 && ![ChineseInclude isIncludeChineseInString:aSearch.text]) {//英文或者数字搜素
        
        [[WQDataShare sharedService].customerArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WQCustomerObj *customer = (WQCustomerObj *)obj;
            
            if ([ChineseInclude isIncludeChineseInString:customer.customerName]) {//名称含有中文
                //转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:customer.customerName];
                NSRange titleResult=[tempPinYinStr rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0 && ![searchResults containsObject:customer]) {
                    [searchResults addObject:customer];
                }
                
                //转换为拼音首字母
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:customer.customerName];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0 && ![searchResults containsObject:customer]) {
                    [searchResults addObject:customer];
                }
                
                //电话号码
                NSRange phoneResult=[customer.customerPhone rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (phoneResult.length>0 && ![searchResults containsObject:customer]) {
                    [searchResults addObject:customer];
                }
            }else {
                //昵称含有数字
                NSRange titleResult=[customer.customerName rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:customer];
                }
                
                //电话号码
                NSRange phoneResult=[customer.customerPhone rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (phoneResult.length>0 && ![searchResults containsObject:customer]) {
                    [searchResults addObject:customer];
                }
            }
        }];
        
    } else if (aSearch.text.length>0&&[ChineseInclude isIncludeChineseInString:aSearch.text]) {//中文搜索
        for (WQCustomerObj *customer in [WQDataShare sharedService].customerArray) {
            NSRange titleResult=[customer.customerName rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:customer];
            }
        }
    }
    
    [[WQDataShare sharedService] sortCustomers:searchResults CompleteBlock:^(BOOL finished) {
        [self.tableView reloadData];
    }];
}

@end
