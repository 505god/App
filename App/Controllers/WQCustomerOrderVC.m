//
//  WQCustomerOrderVC.m
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerOrderVC.h"

#import "MJRefresh.h"
#import "WQCustomerOrderObj.h"

#import "WQCustomerOrderCell.h"

@interface WQCustomerOrderVC ()<WQNavBarViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;


///刷新
@property (nonatomic, assign) BOOL isRefreshing;
///加载
@property (nonatomic, assign) BOOL isLoadingMore;
///分页基数---默认10
@property (nonatomic, assign) NSInteger limit;
///当前页开始索引
@property (nonatomic, assign) NSInteger pageIndex;
///总页数
@property (nonatomic, assign) NSInteger pageCount;
///成交额
@property (nonatomic, assign) CGFloat orderPrice;
@end

@implementation WQCustomerOrderVC

-(void)testData {
    NSDictionary *aDic = [Utility returnDicByPath:@"OrderList"];
    NSArray *array = [aDic objectForKey:@"orderList"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDic = (NSDictionary *)obj;
        WQCustomerOrderObj *product = [[WQCustomerOrderObj alloc]init];
        [product mts_setValuesForKeysWithDictionary:aDic];
        [weakSelf.dataArray addObject:product];
        SafeRelease(product);
        SafeRelease(aDic);
    }];
    
    //判断数据源
    if (self.dataArray.count>0) {
        [self.tableView reloadData];
        [self setNoneText:nil animated:NO];
        [self setToolImage:nil text:nil animated:NO];
    }else {
        [self setNoneText:NSLocalizedString(@"NoneProducts", @"") animated:YES];
        [self setToolImage:@"compose_photograph_highlighted" text:NSLocalizedString(@"NewProductVC", @"") animated:YES];
    }
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"customerOrder", @"")];
    [self.navBarView.rightBtn setHidden:YES];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    //集成刷新控件
    [self addHeader];
    [self addFooter];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark - private

- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf testData];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            // 结束刷新
            [weakSelf.tableView headerEndRefreshing];
        });
    } dateKey:@"WQCustomerOrderVC"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
    //自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

- (void)addFooter {
    __unsafe_unretained typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [self.tableView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf testData];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            //结束刷新
            [weakSelf.tableView footerEndRefreshing];
        });
    }];
}

#pragma mark - 导航栏代理
//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.width, 40)];
    customView.backgroundColor = COLOR(235, 235, 241, 1);
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.textColor = [UIColor lightGrayColor];
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.text = [NSString stringWithFormat:@"%@",self.customerObj.customerName];
    [nameLab sizeToFit];
    nameLab.frame = (CGRect){10,(40-nameLab.height)/2,nameLab.width,nameLab.height};
    [customView addSubview:nameLab];
    SafeRelease(nameLab);
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.textAlignment = NSTextAlignmentRight;
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ProTotalPrice", @""),self.orderPrice];
    [headerLabel sizeToFit];
    headerLabel.frame = (CGRect){customView.width-headerLabel.width-10,(40-headerLabel.height)/2,headerLabel.width,headerLabel.height};
    [customView addSubview:headerLabel];
    SafeRelease(headerLabel);
    
    return customView;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQCustomerOrderVCCell";
    
    WQCustomerOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQCustomerOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[indexPath.row];
    
    [cell setOrderObj:orderObj];
    
    return cell;
}
@end
