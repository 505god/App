//
//  WQCustomerDetailVC.m
//  App
//
//  Created by 邱成西 on 15/4/14.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerDetailVC.h"
#import "WQCustomerDetailHeader.h"
#import "WQCustomerDetailCell.h"

#import "BlockAlertView.h"

@interface WQCustomerDetailVC ()<WQNavBarViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation WQCustomerDetailVC
-(void)dealloc {
    
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    self.navBarView.titleLab.text = NSLocalizedString(@"CustomerInfoDetail", @"");
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addProperty"] forState:UIControlStateNormal];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self dealData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self initFooterView];
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

-(void)dealData {
    NSInteger rowCount = 0;
    self.dataArray = [NSMutableArray array];
    
    ///手机
    if ([Utility checkString:self.customerObj.customerPhone]) {
        rowCount ++;
        NSDictionary *dic = @{NSLocalizedString(@"CustomerPhone", @""):self.customerObj.customerPhone};
        [self.dataArray addObject:dic];
    }
    ///备注
    if ([Utility checkString:self.customerObj.customerRemark]) {
        rowCount ++;
        NSDictionary *dic = @{NSLocalizedString(@"CustomerRemark", @""):self.customerObj.customerRemark};
        [self.dataArray addObject:dic];
    }
    ///地区
    if ([Utility checkString:self.customerObj.customerArea]) {
        rowCount ++;
        NSDictionary *dic = @{NSLocalizedString(@"customerArea", @""):self.customerObj.customerArea};
        [self.dataArray addObject:dic];
    }
    NSDictionary *dic = @{NSLocalizedString(@"customerCode", @""):self.customerObj.customerCode};
    [self.dataArray addObject:dic];
    
    NSDictionary *dic2 = @{NSLocalizedString(@"customerOrder", @""):@""};
    [self.dataArray addObject:dic2];
    
    [self.tableView reloadData];
}
#pragma mark - property

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WQCustomerDetailHeader class] forHeaderFooterViewReuseIdentifier:@"WQCustomerDetailHeader"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)initFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    quitBtn.frame = CGRectMake((self.view.width-250)/2, 10, 250, 40);
    [quitBtn setTitle:NSLocalizedString(@"customerChat", @"") forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [quitBtn addTarget:self action:@selector(chatWithCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setBackgroundColor:COLOR(215, 0, 41, 1)];
    [footerView addSubview:quitBtn];
    self.tableView.tableFooterView = footerView;
    footerView=nil;quitBtn = nil;
}

#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 70;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WQCustomerDetailHeader *header = (WQCustomerDetailHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WQCustomerDetailHeader"];
    [header setCustomerObj:self.customerObj];
    return header;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"customerDetailCell";
    
    WQCustomerDetailCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQCustomerDetailCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSDictionary *dic = (NSDictionary *)self.dataArray[indexPath.row];
    
    NSArray *array = [dic allKeys];
    NSString *title = array[0];
    
    if ([title isEqualToString:NSLocalizedString(@"CustomerPhone", @"")] || [title isEqualToString:NSLocalizedString(@"customerOrder", @"")]) {
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [cell setDictionary:dic];
    return cell;
}
//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = NavgationHeight;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *dic = (NSDictionary *)self.dataArray[indexPath.row];
    
    NSArray *array = [dic allKeys];
    NSString *title = array[0];
    
    if ([title isEqualToString:NSLocalizedString(@"CustomerPhone", @"")]) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"customerPhoneCall", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            NSString *telStr = [NSString stringWithFormat:@"tel:%@",self.customerObj.customerPhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
        }];
        [alert show];
    }else if ([title isEqualToString:NSLocalizedString(@"customerOrder", @"")]){
    }
    
}
#pragma mark - 发起消息

-(void)chatWithCustomer:(id)sender {
    
}
@end
