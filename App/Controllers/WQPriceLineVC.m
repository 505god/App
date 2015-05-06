//
//  WQPriceLineVC.m
//  App
//
//  Created by 邱成西 on 15/4/21.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQPriceLineVC.h"
#import "MJRefresh.h"

#import "WQPricelineObj.h"
#import "WQPriceLineCell.h"

@interface WQPriceLineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger type;


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
@end

@implementation WQPriceLineVC

-(void)testData {
    NSDictionary *aDic = [Utility returnDicByPath:@"priceLine"];
    NSArray *array = [aDic objectForKey:@"pricelineList"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDic = (NSDictionary *)obj;
        WQPricelineObj *lineObj = [[WQPricelineObj alloc]init];
        [lineObj mts_setValuesForKeysWithDictionary:aDic];
        [weakSelf.dataArray addObject:lineObj];
        SafeRelease(lineObj);
        SafeRelease(aDic);
    }];
    
    //判断数据源
    if (self.dataArray.count>0) {
        [self.tableView reloadData];
        [self setNoneText:nil animated:NO];
    }else {
        [self setNoneText:NSLocalizedString(@"NoneProducts", @"") animated:YES];
    }
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
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
    } dateKey:@"WQPriceLineVC"];
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
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NavgationHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQPriceLineCell";
    
    WQPriceLineCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQPriceLineCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setIndexPath:indexPath];
    WQPricelineObj *priceObj = (WQPricelineObj *)self.dataArray[indexPath.row];
    
    [cell setPriceLineObj:priceObj];
    
    return cell;
}
@end
