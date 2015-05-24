//
//  WQOrderSearchVC.m
//  App
//
//  Created by 邱成西 on 15/4/18.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQOrderSearchVC.h"
#import "MJRefresh.h"

#import "WQOrderSearchObj.h"
#import "WQCustomerOrderObj.h"

#import "WQCustomerOrderCell.h"

#import "BlockAlertView.h"
#import "BlockTextPromptAlertView.h"

#import "WQCustomerTable.h"

/*
 * 待付款 1
 * 待发货 2
 * 待收货 3
 * 已完成 4
 */

@interface WQOrderSearchVC ()<WQNavBarViewDelegate,WQCustomerOrderCellDelegate,WQCustomerTableDelegate>

@property (nonatomic, strong) WQCustomerTable *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

//  0时间   1订单号
@property  (nonatomic, assign) BOOL orderType;
@end

@implementation WQOrderSearchVC

-(void)dealloc {
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
}
#pragma mark - 获取订单列表

-(void)getSearchOrderList {
    if (![Utility checkString:self.tableView.searchBar.text]) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"orderSearchPlace", @"")];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    NSDictionary *postDic = nil;
    NSRange range = [self.tableView.searchBar.text rangeOfString:@"."];
    if (range.location != NSNotFound && range.length>0) {//日期
        NSString *phoneRegex = @"((^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(10|12|0?[13578])([-\\/\\._])(3[01]|[12][0-9]|0?[1-9])$)|(^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(11|0?[469])([-\\/\\._])(30|[12][0-9]|0?[1-9])$)|(^((1[8-9]\\d{2})|([2-9]\\d{3}))([-\\/\\._])(0?2)([-\\/\\._])(2[0-8]|1[0-9]|0?[1-9])$)|(^([2468][048]00)([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([3579][26]00)([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([1][89][0][48])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][0][48])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([1][89][2468][048])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][2468][048])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([1][89][13579][26])([-\\/\\._])(0?2)([-\\/\\._])(29)$)|(^([2-9][0-9][13579][26])([-\\/\\._])(0?2)([-\\/\\._])(29)$))";
        NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        if (![phoneTest evaluateWithObject:self.tableView.searchBar.text]){
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"orderSearchError", @"")];
            return;
        }else {
            postDic = @{@"times":self.tableView.searchBar.text};
            self.orderType = 0;
        }
    }else {
        postDic = @{@"orderId":self.tableView.searchBar.text};
        self.orderType = 1;
    }
    
    self.interfaceTask = [[WQAPIClient sharedClient] GET:@"/rest/order/searchOrderList" parameters:postDic success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.dataArray = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                if (weakSelf.orderType==0) {
                    WQOrderSearchObj *orderObj = [[WQOrderSearchObj alloc]init];
                    [orderObj mts_setValuesForKeysWithDictionary:aDic];
                    
                    if (orderObj==nil) {
                        [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
                    }else {
                        if (orderObj.payArray.count>0) {
                            NSDictionary *dic = @{@"name":NSLocalizedString(@"orderPay", @""),@"status":@"1",@"object":orderObj.payArray};
                            [weakSelf.dataArray addObject:dic];
                        }
                        
                        if (orderObj.deliveryArray.count>0) {
                            NSDictionary *dic = @{@"name":NSLocalizedString(@"DeliveryVC", @""),@"status":@"2",@"object":orderObj.deliveryArray};
                            [weakSelf.dataArray addObject:dic];
                        }
                        
                        if (orderObj.receiveArray.count>0) {
                            NSDictionary *dic = @{@"name":NSLocalizedString(@"ReceivingVC", @""),@"status":@"3",@"object":orderObj.receiveArray};
                            [weakSelf.dataArray addObject:dic];
                        }
                        
                        if (orderObj.finishArray.count>0) {
                            NSDictionary *dic = @{@"name":NSLocalizedString(@"orderFinish", @""),@"status":@"4",@"object":orderObj.finishArray};
                            [weakSelf.dataArray addObject:dic];
                        }
                    }
                }else {
                    NSArray *array = (NSArray *)[aDic objectForKey:@"orderList"];
                    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        NSDictionary *dicc = (NSDictionary *)obj;
                        
                        WQCustomerOrderObj *orderObj = [[WQCustomerOrderObj alloc]init];
                        [orderObj mts_setValuesForKeysWithDictionary:dicc];
                        [weakSelf.dataArray addObject:orderObj];
                        SafeRelease(orderObj);
                    }];
                }
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf checkDataArray];
        [weakSelf.tableView.tableView headerEndRefreshing];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView.tableView removeHeader];
        [weakSelf.tableView.tableView headerEndRefreshing];
        [weakSelf checkDataArray];
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

-(void)checkDataArray {
    if (self.dataArray.count==0) {
        [self setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
    }else {
        [self setNoneText:nil animated:NO];
    }
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"orderSearch", @"")];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];

    [self addHeader];
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

-(WQCustomerTable *)tableView {
    if (!_tableView) {
        _tableView = [[WQCustomerTable alloc] initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height}];
        _tableView.delegate = self;
        _tableView.searchBar.placeholder = NSLocalizedString(@"orderSearchPlace", @"");
        _tableView.searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView setHeaderAnimated:YES];
        [self.view insertSubview:_tableView belowSubview:self.navBarView];
    }
    return _tableView;
}


#pragma mark - private
// 添加下拉刷新头部控件
-(void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView.tableView addHeaderWithCallback:^{
        [weakSelf getSearchOrderList];
    } dateKey:@"WQOrderSearchVC"];
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
    [self.tableView.tableView removeHeader];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)search {
    [search resignFirstResponder];
    self.dataArray = nil;
    [self getSearchOrderList];
}

#pragma mark - TQTableViewDataSource
- (NSArray *)sectionIndexTitlesForWQCustomerTable:(WQCustomerTable *)tableView {
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.orderType==0) {
        return self.dataArray.count;
    }else {
        return 1;
    }
}

-(UIView *)customViewWithString:(NSString *)string {
    UIView *customView = [[UIView alloc]initWithFrame:(CGRect){0,0,self.view.width,50}];
    customView.backgroundColor = COLOR(230, 230, 230, 1);;
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 0, self.tableView.width, 30}];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.text = [NSString stringWithFormat:@"  %@",string];
    
    [customView addSubview:headerLabel];
    SafeRelease(headerLabel);
    
    return customView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.orderType==0) {
        return 30;
    }else {
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.orderType==0) {
        NSDictionary *dic = (NSDictionary *)self.dataArray[section];
        
        UIView *header = [self customViewWithString:[dic objectForKey:@"name"]];
        
        return header;
    }else {
        return nil;
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.orderType==0) {
        NSDictionary *dic = (NSDictionary *)self.dataArray[section];
        NSArray *array = (NSArray *)[dic objectForKey:@"object"];
        return array.count;
    }else {
        return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orderType==0) {
        NSDictionary *dic = (NSDictionary *)self.dataArray[indexPath.section];
        NSInteger status = [[dic objectForKey:@"status"]integerValue];
        if (status==1 || status==2) {
            return 220;
        }
        return 185;
    }else {
        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[indexPath.row];
        if (orderObj.orderStatus==1 || orderObj.orderStatus==2) {
            return 220;
        }
        return 185;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQCustomerOrderSearchVCCell";
    
    WQCustomerOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQCustomerOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.delegate = self;
    [cell setIndexPath:indexPath];
    
    if (self.orderType==0) {
        NSDictionary *dic = (NSDictionary *)self.dataArray[indexPath.section];
        NSInteger status = [[dic objectForKey:@"status"] integerValue];
        [cell setType:status];
        
        NSArray *array = (NSArray *)[dic objectForKey:@"object"];
        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)array[indexPath.row];
        [cell setOrderObj:orderObj];
    }else {
        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)self.dataArray[indexPath.row];
        [cell setType:orderObj.orderStatus];
        [cell setOrderObj:orderObj];
    }
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    if (scrollView == self.tableView.tableView) {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
#pragma mark -

#pragma mark -

-(void)editPriceOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[cell.indexPath.section]];
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"object"]];
    WQCustomerOrderObj *orderObject = (WQCustomerOrderObj *)mutableArray[cell.indexPath.row];
    
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"orderChangePrice", @"") message:nil textField:&textField type:1 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        [[WQAPIClient sharedClient] POST:@"/rest/order/changeOrderPrice" parameters:@{@"orderId":orderObj.orderId,@"price":textField.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    orderObject.orderPrice = [textField.text floatValue];
                    
                    [self.tableView.tableView reloadData];
                }else {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        }];
    }];
    [alert show];
}
-(void)alertOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj {
    
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"orderRemind", @"") message:nil textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        
        [[WQAPIClient sharedClient] POST:@"/rest/order/noticeOrder" parameters:@{@"orderId":orderObj.orderId,@"message":textField.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"remindAlert", @"")];
                }else {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        }];
    }];
    [alert show];
}

-(void)deliveryOrderWithCell:(WQCustomerOrderCell *)cell orderObj:(WQCustomerOrderObj *)orderObj {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[cell.indexPath.section]];
    NSMutableArray *mutableArray = [[NSMutableArray alloc]initWithArray:[dic objectForKey:@"object"]];
    WQCustomerOrderObj *orderObject = (WQCustomerOrderObj *)mutableArray[cell.indexPath.row];
    
    [mutableArray removeObjectAtIndex:cell.indexPath.row];
    if (mutableArray.count==0) {
        [self.dataArray removeObjectAtIndex:cell.indexPath.section];
    }else {
        [dic setObject:mutableArray forKey:@"object"];
        [self.dataArray replaceObjectAtIndex:cell.indexPath.section withObject:dic];
    }
    
    BOOL isExit = NO;
    for (int i=0; i<self.dataArray.count; i++) {
        NSMutableDictionary *aDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[i]];
        NSInteger status = [[aDic objectForKey:@"status"]integerValue];
        if (status==4) {
            isExit = YES;
            
            NSMutableArray *aMutableArray = [[NSMutableArray alloc]initWithArray:[aDic objectForKey:@"object"]];
            orderObject.orderStatus = 4;
            [aMutableArray addObject:orderObject];
            [aDic setObject:aMutableArray forKey:@"object"];
            [self.dataArray replaceObjectAtIndex:i withObject:aDic];
            break;
        }
    }
    if (isExit==NO) {
        orderObject.orderStatus = 4;
        NSArray *array = @[orderObject];
        NSDictionary *dic = @{@"name":NSLocalizedString(@"orderFinish", @""),@"status":@"4",@"object":array};
        [self.dataArray addObject:dic];
    }
    
    [self.tableView reloadData];
    
    return;
    
    BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"deliveryOrder", @"")];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        [[WQAPIClient sharedClient] POST:@"/rest/order/delOrder" parameters:@{@"orderId":orderObj.orderId} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    [mutableArray removeObjectAtIndex:cell.indexPath.row];
                    if (mutableArray.count==0) {
                        [self.dataArray removeObjectAtIndex:cell.indexPath.section];
                    }else {
                        [dic setObject:mutableArray forKey:@"object"];
                        [self.dataArray replaceObjectAtIndex:cell.indexPath.section withObject:dic];
                    }
                    
                    BOOL isExit = NO;
                    for (int i=0; i<self.dataArray.count; i++) {
                        NSMutableDictionary *aDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[i]];
                        NSInteger status = [[aDic objectForKey:@"status"]integerValue];
                        if (status==4) {
                            isExit = YES;
                            
                            NSMutableArray *aMutableArray = [[NSMutableArray alloc]initWithArray:[aDic objectForKey:@"object"]];
                            orderObject.orderStatus = 4;
                            [aMutableArray addObject:orderObject];
                            [aDic setObject:aMutableArray forKey:@"object"];
                            [self.dataArray replaceObjectAtIndex:i withObject:aDic];
                            break;
                        }
                    }
                    if (isExit==NO) {
                        orderObject.orderStatus = 4;
                        NSArray *array = @[orderObject];
                        NSDictionary *dicc = @{@"name":NSLocalizedString(@"orderFinish", @""),@"status":@"4",@"object":array};
                        [self.dataArray addObject:dicc];
                    }
                    
                    [self.tableView reloadData];
                }else {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        }];
        
    }];
    [alert show];
}


#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
