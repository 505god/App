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
#import "WQCustomerOrderProObj.h"

#import "WQOrderHeader.h"
#import "WQCustomerOrderCell.h"

#import "BlockAlertView.h"
#import "BlockTextPromptAlertView.h"

#import "WQCustomerTable.h"

/*
 * 待处理 1
 * 待付款 2
 * 已完成 3
 */

@interface WQOrderSearchVC ()<WQNavBarViewDelegate,WQSwipTableHeaderDelegate,WQCustomerTableDelegate>

@property (nonatomic, strong) WQCustomerTable *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *arrSelSection;

@end

@implementation WQOrderSearchVC

#pragma mark - 获取订单列表

-(void)getSearchOrderList {
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
        }
    }else {
        postDic = @{@"orderId":self.tableView.searchBar.text};
    }
    
    
    self.interfaceTask = [WQAPIClient getSearchOrderListWithParameters:postDic block:^(WQOrderSearchObj *orderSearchObj, NSError *error) {
        if (!error) {
            if (orderSearchObj==nil) {
                [weakSelf.tableView setHeaderAnimated:NO];
                [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
            }else {
                if (orderSearchObj.dealArray.count>0) {
                    NSDictionary *dic = @{@"name":NSLocalizedString(@"orderDeal", @""),@"status":@"0"};
                    [weakSelf.dataArray addObject:dic];
                    
                    [orderSearchObj.dealArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)obj;
                        NSDictionary *dic = @{@"object":orderObj,@"status":@"1"};
                        [weakSelf.dataArray addObject:dic];
                    }];
                }
                
                if (orderSearchObj.payArray.count>0) {
                    NSDictionary *dic = @{@"name":NSLocalizedString(@"orderPay", @""),@"status":@"0"};
                    [weakSelf.dataArray addObject:dic];
                    
                    [orderSearchObj.payArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)obj;
                        NSDictionary *dic = @{@"object":orderObj,@"status":@"2"};
                        [weakSelf.dataArray addObject:dic];
                    }];
                }
                
                if (orderSearchObj.finishArray.count>0) {
                    NSDictionary *dic = @{@"name":NSLocalizedString(@"orderFinish", @""),@"status":@"0"};
                    [weakSelf.dataArray addObject:dic];
                    
                    [orderSearchObj.finishArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)obj;
                        NSDictionary *dic = @{@"object":orderObj,@"status":@"3"};
                        [weakSelf.dataArray addObject:dic];
                    }];
                }
                
                //判断数据源
                if (weakSelf.dataArray.count>0) {
                    [weakSelf.tableView reloadData];
                    [weakSelf setNoneText:nil animated:NO];
                    [weakSelf.tableView setHeaderAnimated:YES];
                    [weakSelf addHeader];
                }else {
                    [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
                }
            }
        }else {
            [weakSelf setNoneText:NSLocalizedString(@"NoneOrder", @"") animated:YES];
        }
    }];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"orderSearch", @"")];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self.tableView setHeaderAnimated:YES];
    [self.view addSubview:self.tableView];
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

-(WQCustomerTable *)tableView {
    if (!_tableView) {
        _tableView = [[WQCustomerTable alloc] initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height}];
        _tableView.delegate = self;
        _tableView.searchBar.placeholder = NSLocalizedString(@"orderSearchPlace", @"");
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_tableView.tableView registerClass:[WQOrderHeader class] forHeaderFooterViewReuseIdentifier:@"WQOrderHeader"];
    }
    return _tableView;
}
-(NSMutableArray *)arrSelSection {
    if (!_arrSelSection) {
        _arrSelSection = [[NSMutableArray alloc]init];
    }
    return _arrSelSection;
}

#pragma mark - private
// 添加下拉刷新头部控件
- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView.tableView addHeaderWithCallback:^{
        
        weakSelf.dataArray = nil;
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

#pragma mark - TQTableViewDataSource
- (NSArray *)sectionIndexTitlesForWQCustomerTable:(WQCustomerTable *)tableView {
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = (NSDictionary *)self.dataArray[section];
    if ([[dic objectForKey:@"status"]integerValue]==0) {
        return 50;
    }
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSDictionary *dic = (NSDictionary *)self.dataArray[section];
    if ([[dic objectForKey:@"status"]integerValue]==0) {
        return [self customViewWithString:[dic objectForKey:@"name"]];
    }else {
        WQOrderHeader *header = (WQOrderHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WQOrderHeader"];
        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)[dic objectForKey:@"object"];
        [header setOrderObj:orderObj];
        header.delegate = self;
        header.aSection = section;
        header.type=[[dic objectForKey:@"status"]integerValue];
        if ([[dic objectForKey:@"status"]integerValue]==3){
            header.revealDirection = WQSwipTableHeaderRevealDirectionRight;
        }else {
            header.revealDirection = WQSwipTableHeaderRevealDirectionBoth;
        }
        
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

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

-(UIView *)customViewWithString:(NSString *)string {
    UIView *customView = [[UIView alloc]initWithFrame:(CGRect){0,0,self.view.width,50}];
    customView.backgroundColor = COLOR(235, 235, 241, 1);;
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:(CGRect){0, 20, self.tableView.width, 30}];
    headerLabel.backgroundColor = [UIColor whiteColor];
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.font = [UIFont systemFontOfSize:18];
    headerLabel.text = [NSString stringWithFormat:@"   %@",string];
    
    [customView addSubview:headerLabel];
    SafeRelease(headerLabel);
    
    return customView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (int i = 0; i < self.arrSelSection.count; i++) {
        if (section == [self.arrSelSection[i] integerValue]) {
            NSDictionary *dic = (NSDictionary *)self.dataArray[section];
            WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)[dic objectForKey:@"object"];
            return orderObj.productList.count;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQCustomerOrderSearchVCCell";
    
    WQCustomerOrderCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQCustomerOrderCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic = (NSDictionary *)self.dataArray[indexPath.section];
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)[dic objectForKey:@"object"];
    WQCustomerOrderProObj *proObj = (WQCustomerOrderProObj *)orderObj.productList[indexPath.row];
    
    [cell setOrderProductObj:proObj];
    
    return cell;
}
#pragma mark -

-(void)editDidTapPressedOption:(WQSwipTableHeader *)Header {
    WQOrderHeader *header = (WQOrderHeader *)Header;
    
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
        NSDictionary *dic = (NSDictionary *)self.dataArray[header.aSection];
        WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)[dic objectForKey:@"object"];
        if (orderObj.productList.count>0) {
            [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",header.aSection]];
            [self.tableView.tableView beginUpdates];
            [self.tableView.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView.tableView endUpdates];
        }
    }else {//打开状态
        [self.arrSelSection removeObject:[NSString stringWithFormat:@"%d",header.aSection]];
        [self.tableView.tableView beginUpdates];
        [self.tableView.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView.tableView endUpdates];
    }
}

-(void)swipeTableViewHeaderWillResetState:(WQSwipTableHeader*)swipeTableViewHeader fromPoint:(CGPoint)point animation:(WQSwipTableHeaderAnimationType)animation velocity:(CGPoint)velocity  {
    
    WQOrderHeader *header = (WQOrderHeader *)swipeTableViewHeader;
    NSDictionary *dic = (NSDictionary *)self.dataArray[header.aSection];
    WQCustomerOrderObj *orderObj = (WQCustomerOrderObj *)[dic objectForKey:@"object"];
    
    if (point.x >= 50) {
        if ([[dic objectForKey:@"status"]integerValue]==1) {
            UITextField *textField;
            BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"orderChangePrice", @"") message:nil textField:&textField type:1 block:^(BlockTextPromptAlertView *alert){
                [alert.textField resignFirstResponder];
                return YES;
            }];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                DLog(@"Text: %@", textField.text);
            }];
            [alert show];
        }else {
            UITextField *textField;
            BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"orderRemind", @"") message:nil textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
                [alert.textField resignFirstResponder];
                return YES;
            }];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                DLog(@"Text: %@", textField.text);
            }];
            [alert show];
        }
    }else if (point.x < 0 && -point.x >= 50) {
        swipeTableViewHeader.shouldAnimateCellReset = NO;
        
        header.shouldAnimateCellReset = YES;
        
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            header.shouldAnimateCellReset = NO;
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 header.frame = CGRectOffset(header.bounds, header.width, 0);
                             }completion:^(BOOL finished) {
//                                 [header setHidden:YES];
                                 [self.dataArray removeObjectAtIndex:header.aSection];
                                 
                                 if ([self.arrSelSection containsObject:[NSString stringWithFormat:@"%d",header.aSection]]) {
                                     [self.arrSelSection removeObject:[NSString stringWithFormat:@"%d",header.aSection]];
                                 }
                                 [self.tableView.tableView reloadData];
                             }];
        }];
        [alert show];
    }
}

#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
