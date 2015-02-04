//
//  WQCustomerVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerVC.h"
#import "WQCustomBtn.h"

#import "WQCustomerCell.h"
#import "WQSubVC.h"

#import "WQCustomerObj.h"

@interface WQCustomerVC ()<UISearchBarDelegate>

@property (nonatomic, strong) WQSubVC *subVC;

//搜索框
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

//联系人数组
@property (nonatomic, strong) NSMutableArray *contactList;

//搜索
@property (nonatomic, strong) NSMutableDictionary *contactDic;
@property (nonatomic, strong) NSMutableArray *searchByName;
@property (nonatomic, strong) NSMutableArray *searchByPhone;

//索引
@property (nonatomic, strong) NSMutableDictionary *itemDic;
@property (nonatomic, strong) NSMutableArray *keys;
@property (nonatomic, strong) NSMutableDictionary *names;
@property (nonatomic, strong) NSMutableArray *sectionArray;

@end

@implementation WQCustomerVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"客户管理";
    
    [self setupSearchBarUI];
    
    //TODO:获取通讯录列表
    NSDictionary *aDic = [Utility returnDicByPath:@"CustomerList"];
    DLog(@"%@",aDic);
    NSArray *array = [aDic objectForKey:@"customerList"];
    
    __weak typeof(self) wself = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDic = (NSDictionary *)obj;
        WQCustomerObj *customer = [WQCustomerObj returnCustomerWithDic:aDic];
        [wself.contactList addObject:customer];
        SafeRelease(customer);
        SafeRelease(aDic);
    }];
    
    [self.tableView reloadData];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

-(NSMutableArray *)contactList {
    if (!_contactList) {
        _contactList = [NSMutableArray array];
    }
    return _contactList;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contactList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"customer_cell";
    
    WQCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[WQCustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WQCustomerObj *customer = self.contactList[indexPath.row];
    [cell setCustomerObj:customer];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.subVC = nil;
    self.subVC = LOADVC(@"WQSubVC");
    self.subVC.idxPath = indexPath;
    self.subVC.customerVC = self;
    
    self.tableView.scrollEnabled = NO;
    UIFolderTableView *folderTableView = (UIFolderTableView *)tableView;
    [folderTableView openFolderAtIndexPath:indexPath WithContentView:self.subVC.view
                                 openBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                     // opening actions
                                 }
                                closeBlock:^(UIView *subClassView, CFTimeInterval duration, CAMediaTimingFunction *timingFunction){
                                    // closing actions
                                }
                           completionBlock:^{
                               self.tableView.scrollEnabled = YES;
                           }];
    
}

-(CGFloat)tableView:(UIFolderTableView *)tableView xForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


#pragma mark - 搜索框设置

-(void)setupSearchBarUI {
    //去除SearchBar的背景
    if ([self.searchBar respondsToSelector:@selector (barTintColor)]){
        if (Platform>=7.1){
            [[[[self.searchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [self.searchBar setBackgroundColor:[UIColor lightGrayColor]];
        }else{//7.0
            [self.searchBar setBarTintColor :[UIColor clearColor]];
            [self.searchBar setBackgroundColor :[UIColor lightGrayColor]];
        }
    }else {//7.0以下
        [[self.searchBar.subviews objectAtIndex:0] removeFromSuperview];
        
        [self.searchBar setBackgroundColor:[UIColor lightGrayColor]];
    }
    
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

#pragma mark - searchBar协议

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
- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
    [self.searchBar resignFirstResponder];
    
    if (self.searchBar.text.length<=0) {
        [Utility errorAlert:@"搜索内容不能为空" dismiss:NO];
    }else {
        //TODO:搜索联系人
    }
}

#pragma mark - 子View事件 
//查看个人信息
-(void)subViewInfoBtnAction:(WQCustomBtn *)sender {
    
}
//进入往来记录
-(void)subViewMessageBtnAction:(WQCustomBtn *)sender {
    
}
@end
