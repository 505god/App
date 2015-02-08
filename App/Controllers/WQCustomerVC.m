//
//  WQCustomerVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerVC.h"

#import "WQIndexedCollationWithSearch.h"
#import "WQCustomerCell.h"

#import "WQCustomerObj.h"
#import "ChineseInclude.h"
#import "PinYinForObjc.h"

#import "WQCustomerInfoVC.h"
#import "WQNewCustomerVC.h"

#import "JKUtil.h"

@interface WQCustomerVC ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate,WQCustomerCellDelegate>

@property(nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UISearchDisplayController *strongSearchDisplayController;

//搜索结果
@property (nonatomic, strong) NSMutableArray *searchResults;
//客户列表
@property (nonatomic, strong) NSMutableArray *customerList;

@end

@implementation WQCustomerVC


#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户管理";

    [self setupSearchBar];

    
    //TODO:获取通讯录列表
    NSDictionary *aDic = [Utility returnDicByPath:@"CustomerList"];
    NSArray *array = [aDic objectForKey:@"customerList"];
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *aDic = (NSDictionary *)obj;
            WQCustomerObj *customer = [WQCustomerObj returnCustomerWithDic:aDic];
            [wself.customerList addObject:customer];
            SafeRelease(customer);
            SafeRelease(aDic);
        }];

        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.tableView reloadData];
        });
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(addNewCustomer)];
    
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
        if ([navBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
            [navBar setBackgroundImage:[Utility imageFileNamed:@"navBar.png"] forBarMetrics:UIBarMetricsDefault];
        }else {
            UIImageView *imageView = (UIImageView *)[navBar viewWithTag:10];
            if (imageView == nil) {
                imageView = [[UIImageView alloc] initWithImage:
                             [Utility imageFileNamed:@"navBar.png"]];
                [imageView setTag:10];
                [navBar insertSubview:imageView atIndex:0];
                SafeRelease(imageView);
            }
        }
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
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelBtn.frame = CGRectMake(0, 0, 50, 30);
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:[JKUtil getColor:@"828689"] forState:UIControlStateHighlighted];
        [cancelBtn addTarget:self action:@selector(cancelEventDidTouched) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
        [self.navigationItem setLeftBarButtonItem:cancelItem animated:NO];
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
-(NSMutableArray *)customerList {
    if (!_customerList) {
        _customerList = [NSMutableArray array];
    }
    return _customerList;
}

-(NSMutableArray *)selectedList {
    if (!_selectedList) {
        _selectedList = [NSMutableArray array];
    }
    return _selectedList;
}
#pragma mark - 设置searchBar

-(void)setupSearchBar {
    if (Platform>=7.0) {
        self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    }
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    self.searchBar.placeholder = @"搜索";
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;
    
    self.strongSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplayController.searchResultsDataSource = self;
    self.searchDisplayController.searchResultsDelegate = self;
    self.searchDisplayController.delegate = self;
}

#pragma mark - TableView Delegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    }
    else {
        return self.customerList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"customer_cell";
    
    WQCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[WQCustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WQCustomerObj *customer = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        customer = (WQCustomerObj *)self.searchResults[indexPath.row];
        [cell setCustomerObj:customer];
    }else {
        customer = (WQCustomerObj *)self.customerList[indexPath.row];
        [cell setCustomerObj:customer];
    }
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
    
    //判断
    if (indexPath.row==0) {
        [cell.notificationHub setCount:5];
        [cell.notificationHub bump];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
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
    self.searchBar.showsCancelButton = YES;
    if (Platform>=7.0) {
        for(id cc in [self.searchBar subviews]) {
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
        for(id cc in [self.searchBar subviews]){
            if([cc isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)cc;
                [btn setTitle:@"取消"  forState:UIControlStateNormal];
                [btn setTintColor:[UIColor blackColor]];
            }
        }
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)search{
    self.searchBar.showsCancelButton=NO;
    self.searchBar.text=nil;
    [self.searchBar resignFirstResponder];
    
}

- (void)searchBar:(UISearchBar *)aSearch textDidChange:(NSString *)searchText {
    self.searchResults = [[NSMutableArray alloc]init];
    
    if (aSearch.text.length>0 && ![ChineseInclude isIncludeChineseInString:aSearch.text]) {//英文或者数字搜素
        
        [self.customerList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            WQCustomerObj *customer = (WQCustomerObj *)obj;
            
            if ([ChineseInclude isIncludeChineseInString:customer.customerName]) {//名称含有中文
                //转换为拼音
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:customer.customerName];
                NSRange titleResult=[tempPinYinStr rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0 && ![self.searchResults containsObject:customer]) {
                    [self.searchResults addObject:customer];
                }
                
                //转换为拼音首字母
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:customer.customerName];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0 && ![self.searchResults containsObject:customer]) {
                    [self.searchResults addObject:customer];
                }
                
                //电话号码
                NSRange phoneResult=[customer.customerPhone rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (phoneResult.length>0 && ![self.searchResults containsObject:customer]) {
                    [self.searchResults addObject:customer];
                }
            }else {
                //昵称含有数字
                NSRange titleResult=[customer.customerName rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [self.searchResults addObject:customer];
                }
                
                //电话号码
                NSRange phoneResult=[customer.customerPhone rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
                if (phoneResult.length>0 && ![self.searchResults containsObject:customer]) {
                    [self.searchResults addObject:customer];
                }
            }
        }];
        
    } else if (aSearch.text.length>0&&[ChineseInclude isIncludeChineseInString:aSearch.text]) {//中文搜索
        for (WQCustomerObj *customer in self.customerList) {
            NSRange titleResult=[customer.customerName rangeOfString:aSearch.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [self.searchResults addObject:customer];
            }
        }
    }
    
    [self.tableView reloadData];
}
@end
