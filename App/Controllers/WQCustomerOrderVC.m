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

///当前页开始索引
@property (nonatomic, assign) NSInteger start;
///分页基数---默认10
@property (nonatomic, assign) NSInteger limit;
@property (nonatomic, assign) NSInteger lastOrderId;
///总页数
@property (nonatomic, assign) NSInteger pageCount;
///成交额
@property (nonatomic, assign) CGFloat orderPrice;
@end

@implementation WQCustomerOrderVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
}

#pragma mark - 获取订单列表

-(void)getOrderList {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    self.interfaceTask = [[WQAPIClient sharedClient] GET:@"/rest/order/userOrderList" parameters:@{@"count":[NSNumber numberWithInteger:self.limit],@"lastOrderId":[NSNumber numberWithInteger:self.lastOrderId],@"userId":[NSNumber numberWithInteger:self.customerObj.customerId]} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"orderList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQCustomerOrderObj *orderObj = [[WQCustomerOrderObj alloc] init];
                    [orderObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:orderObj];
                    SafeRelease(orderObj);
                }
                
                NSInteger orderNumber = [[aDic objectForKey:@"pageCount"]integerValue];
                
                CGFloat price = [[aDic objectForKey:@"totalPrice"]floatValue];
                
                if (weakSelf.pageCount<0) {
                    weakSelf.pageCount = orderNumber;
                    weakSelf.orderPrice = price;
                }
                
                [weakSelf.dataArray addObjectsFromArray:mutablePosts];
                if (weakSelf.dataArray.count>0) {
                    [weakSelf.tableView reloadData];
                    [weakSelf setNoneText:nil animated:NO];
                }else {
                    [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
                }
                
                if ((weakSelf.start+weakSelf.limit)<weakSelf.pageCount) {
                    [weakSelf.tableView removeFooter];
                    [weakSelf addFooter];
                }else {
                    [weakSelf.tableView removeFooter];
                }
            }else {
                [weakSelf.tableView removeFooter];
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf.tableView footerEndRefreshing];
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
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
    
    
    self.limit = 10;
    
    //集成刷新控件
    [self addHeader];
    
    [self initHeaderView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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


-(void)initHeaderView {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.width, 40)];
    customView.backgroundColor = COLOR(235, 235, 241, 1);
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:(CGRect){10,10,20,20}];
    imageView.image = [UIImage imageNamed:@"customer"];
    [customView addSubview:imageView];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
    nameLab.backgroundColor = [UIColor clearColor];
    nameLab.font = [UIFont systemFontOfSize:16];
    nameLab.text = [NSString stringWithFormat:@"%@",self.customerObj.customerName];
    [nameLab sizeToFit];
    nameLab.frame = (CGRect){imageView.right+5,(40-nameLab.height)/2,nameLab.width,nameLab.height};
    [customView addSubview:nameLab];
    SafeRelease(nameLab);
    SafeRelease(imageView);
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = NSTextAlignmentRight;
    headerLabel.font = [UIFont systemFontOfSize:16];
    
    NSString *priceString = [NSString stringWithFormat:@"%.2f",self.orderPrice];
    headerLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ProTotalPrice", @""),priceString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:headerLabel.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251/255.0 green:0/255.0 blue:41/255.0 alpha:1] range:NSMakeRange(headerLabel.text.length-priceString.length, priceString.length)];
    headerLabel.attributedText = attributedString;
    SafeRelease(attributedString);
    SafeRelease(priceString);
    
    
    [headerLabel sizeToFit];
    headerLabel.frame = (CGRect){customView.width-headerLabel.width-10,(40-headerLabel.height)/2,headerLabel.width,headerLabel.height};
    [customView addSubview:headerLabel];
    SafeRelease(headerLabel);
    
    self.tableView.tableHeaderView = customView;
    customView=nil;
}
#pragma mark - private
// 添加下拉刷新头部控件
- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addHeaderWithCallback:^{
        weakSelf.dataArray = nil;
        weakSelf.start = 0;
        weakSelf.lastOrderId = 0;
        weakSelf.pageCount = -1;
        weakSelf.orderPrice = -1;
        [weakSelf getOrderList];
    } dateKey:@"WQCustomerOrderVC"];
    //自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}
// 添加上拉刷新尾部控件
- (void)addFooter {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addFooterWithCallback:^{
        
        weakSelf.start += weakSelf.limit;
        if (weakSelf.dataArray.count>0) {
            WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)[weakSelf.dataArray lastObject];
            weakSelf.lastOrderId = [orderObj.orderId integerValue];
        }
        
        [weakSelf getOrderList];
    }];
}

#pragma mark - 导航栏代理
//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 112;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQCustomerOrderVCCell";
    
    WQCustomerOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQCustomerOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.revealDirection = RMSwipeTableViewCellRevealDirectionNone;
    
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[indexPath.row];
    
    [cell setIndexPath:indexPath];
    [cell setType:0];
    [cell setOrderObj:orderObj];
    
    return cell;
}
@end
