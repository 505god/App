//
//  WQCustomerGroupVC.m
//  App
//
//  Created by 邱成西 on 15/6/11.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerGroupVC.h"

#import "MJRefresh.h"
#import "WQClassHeader.h"
#import "WQCustomerCell.h"

#import "DXPopover.h"

#import "WQCusGroupCell.h"

@interface WQCustomerGroupVC ()<UITableViewDelegate,UITableViewDataSource,WQNavBarViewDelegate,WQSwipTableHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
///分类是否打开
@property (nonatomic, strong) NSMutableArray *arrSelSection;

@property (nonatomic, strong) UITableView *popTableView;
@property (nonatomic, strong) DXPopover *popover;

//popcell的indexPath
@property (nonatomic, strong) NSIndexPath *selectedIdxPath;
@property (nonatomic, assign) NSInteger selectedStar;

//变动的start
@property (nonatomic, assign) NSInteger starNum;
@end

@implementation WQCustomerGroupVC
-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_arrSelSection);
    SafeRelease(_popover);
    SafeRelease(_popTableView.delegate);
    SafeRelease(_popTableView.dataSource);
    SafeRelease(_popTableView);
}

#pragma mark - 用户群组

-(void)getCusGroupList {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [[WQAPIClient sharedClient] GET:@"/rest/user/getCustomersSort" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.dataArray = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *dic = (NSDictionary *)[jsonData objectForKey:@"returnObj"];
                
                for (int i=0; i<self.dataArray.count; i++) {
                    WQCusGroupObj *cusObj = (WQCusGroupObj *)self.dataArray[i];
                    
                    NSArray *array = dic[[NSString stringWithFormat:@"%d",i]];
                    cusObj.cusArray = [[NSMutableArray alloc]init];
                    for (NSDictionary *attributes in array) {
                        WQCustomerObj *customerObj = [[WQCustomerObj alloc] init];
                        [customerObj mts_setValuesForKeysWithDictionary:attributes];
                        [cusObj.cusArray addObject:customerObj];
                        SafeRelease(customerObj);
                    }
                }
            }else {
                [Utility interfaceWithStatus:[[jsonData objectForKey:@"status"]integerValue] msg:[jsonData objectForKey:@"msg"]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
    }];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.starNum = -1;
    self.selectedStar = -1;
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"cusGroupVC", @"")];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    //集成刷新控件
    [self addHeader];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableView headerBeginRefreshing];
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
        _dataArray = [[NSMutableArray alloc]initWithCapacity:4];
        
        for (int i=0; i<4; i++) {
            WQCusGroupObj *cusObj = [[WQCusGroupObj alloc]init];
            cusObj.cusGroupId = i;
            [_dataArray addObject:cusObj];
            SafeRelease(cusObj);
        }
    }
    return _dataArray;
}
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WQClassHeader class] forHeaderFooterViewReuseIdentifier:@"WQClassHeader"];
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

-(DXPopover *)popover {
    if (!_popover) {
        _popover = [DXPopover new];
    }
    return _popover;
}

-(UITableView *)popTableView {
    if (!_popTableView) {
        _popTableView = [[UITableView alloc] initWithFrame:(CGRect){0,0,150,44*5} style:UITableViewStylePlain];
        _popTableView.dataSource = self;
        _popTableView.delegate = self;
        _popTableView.scrollEnabled = NO;
        _popTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _popTableView;
}

#pragma mark - private
// 添加下拉刷新头部控件
- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addHeaderWithCallback:^{
        [weakSelf getCusGroupList];
    } dateKey:@"WQCustomerGroupVC"];
}


#pragma mark - 导航栏代理
//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.popTableView]) {
        return 44;
    }
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NavgationHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ([tableView isEqual:self.popTableView]) {
        UIView *customView = [[UIView alloc]initWithFrame:(CGRect){0,0,self.popTableView.width,44}];
        UILabel *lab = [[UILabel alloc] initWithFrame:(CGRect){5,7,self.popTableView.width-5,30}];
        lab.textColor = COLOR(251, 0, 41, 1);
        lab.text = NSLocalizedString(@"changeCusGroup", @"");
        [customView addSubview:lab];
        
        return customView;
    }else {
        WQClassHeader *header = (WQClassHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WQClassHeader"];
        header.delegate = self;
        header.revealDirection = WQSwipTableHeaderRevealDirectionNone;
        
        WQCusGroupObj *cusGroupObj = (WQCusGroupObj *)self.dataArray[section];
        [header setCusGroupObj:cusGroupObj];
        header.aSection = section;
        
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
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([tableView isEqual:self.popTableView]) {
        return 1;
    }
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:self.popTableView]) {
        return 4;
    }
    for (int i = 0; i < self.arrSelSection.count; i++) {
        if (section == [self.arrSelSection[i] integerValue]) {
            WQCusGroupObj *cusGroupObj = (WQCusGroupObj *)self.dataArray[section];
            return cusGroupObj.cusArray.count;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.popTableView]) {
        static NSString * identifier = @"WQCusGroupCell";
        
        WQCusGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[WQCusGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell setIdxPath:indexPath];
        
        if (indexPath.row == self.selectedStar) {
            [cell setIsSelected:YES];
        }else {
            [cell setIsSelected:NO];
        }
        
        return cell;
    }else {
        static NSString * CellIdentifier = @"customerr_cell";
        
        WQCustomerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[WQCustomerCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:CellIdentifier];
        }
        
        [cell setSelectedType:0];
        
        WQCusGroupObj *cusObj = (WQCusGroupObj *)self.dataArray[indexPath.section];
        
        WQCustomerObj *customer = (WQCustomerObj *)cusObj.cusArray[indexPath.row];
        
        [cell setCustomerObj:customer];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([tableView isEqual:self.popTableView]) {
        [self.popover dismiss];
        
        WQCusGroupObj *cusObj = (WQCusGroupObj *)self.dataArray[self.selectedIdxPath.section];
        WQCustomerObj *customer = (WQCustomerObj *)cusObj.cusArray[self.selectedIdxPath.row];
        
        if (customer.customerDegree == indexPath.row) {
            //无变动
            self.starNum = -1;
        }else {
            self.starNum = indexPath.row;
        }
    }else {
        WQCustomerCell *cell = (WQCustomerCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        CGRect convertRect = [cell.contentView convertRect:cell.contentView.frame toView:self.view];
        
        DXPopoverPosition dxP;
        if (convertRect.origin.y+34+44*5-self.view.height>0) {
            dxP = DXPopoverPositionUp;
        }else {
            dxP = DXPopoverPositionDown;
        }
        
        CGPoint startPoint = CGPointMake(self.view.width/2,convertRect.origin.y+34);
        
        [self.popover showAtPoint:startPoint popoverPostion:dxP withContentView:self.popTableView inView:self.view];
        
        self.selectedIdxPath = indexPath;
        
        WQCusGroupObj *cusObj = (WQCusGroupObj *)self.dataArray[indexPath.section];
        WQCustomerObj *customer = (WQCustomerObj *)cusObj.cusArray[indexPath.row];
        self.selectedStar = customer.customerDegree;
        [self.popTableView reloadData];
        
        __unsafe_unretained typeof(self) weakSelf = self;
        self.popover.didDismissHandler = ^{
            weakSelf.selectedStar = -1;
            
            if (weakSelf.starNum>=0) {
                [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
                weakSelf.interfaceTask = [[WQAPIClient sharedClient] POST:@"/rest/user/updateCustomerDegree" parameters:@{@"degree":[NSNumber numberWithInteger:weakSelf.starNum],@"userId":[NSNumber numberWithInteger:customer.customerId]} success:^(NSURLSessionDataTask *task, id responseObject) {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        NSDictionary *jsonData=(NSDictionary *)responseObject;
                        
                        if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                            customer.customerDegree = weakSelf.starNum;
                            [cusObj.cusArray removeObject:customer];
                            
                            WQCusGroupObj *cusObjNext = (WQCusGroupObj *)weakSelf.dataArray[weakSelf.starNum];
                            if (cusObjNext.cusArray) {
                                [cusObjNext.cusArray addObject:customer];
                            }else {
                                cusObjNext.cusArray = [NSMutableArray array];
                                [cusObjNext.cusArray addObject:customer];
                            }
                            [weakSelf.tableView reloadData];
                            
                            weakSelf.starNum = -1;
                            
                            if (self.delegate && [self.delegate respondsToSelector:@selector(changeCustomerInfo:)]) {
                                [self.delegate changeCustomerInfo:customer];
                            }
                        }else {
                            weakSelf.starNum = -1;
                            [Utility interfaceWithStatus:[[jsonData objectForKey:@"status"]integerValue] msg:[jsonData objectForKey:@"msg"]];
                        }
                    }
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
                    weakSelf.starNum = -1;
                }];
            }
        };
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isEqual:self.popTableView]){
        CGFloat sectionHeaderHeight = 44;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//展开分类
-(void)editDidTapPressedOption:(WQSwipTableHeader *)Header {
    WQClassHeader *header = (WQClassHeader *)Header;
    
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
        [self.arrSelSection addObject:[NSString stringWithFormat:@"%ld",header.aSection]];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }else {//打开状态
        [self.arrSelSection removeObject:[NSString stringWithFormat:@"%ld",header.aSection]];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}

@end
