//
//  WQCustomerDetailEditVC.m
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerDetailEditVC.h"
#import "BlockAlertView.h"

#import "WQProductText.h"

#import "WQCustomerDetailEditCell.h"

#import "WQCustomerVC.h"

@interface WQCustomerDetailEditVC ()<WQNavBarViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation WQCustomerDetailEditVC

-(void)dealloc {
    SafeRelease(_customerObj);
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_dataArray);
    SafeRelease(_indexPath);
    SafeRelease(_delegate);
    SafeRelease(_customerVC);
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"CustomerInfoDetailEdit", @"")];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveAct"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveNor"] forState:UIControlStateHighlighted];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveNor"] forState:UIControlStateDisabled];
    self.navBarView.rightBtn.enabled = NO;
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    

    [self initFooterView];
    [self setArrayData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [WQAPIClient cancelConnection];
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 status:
 0=备注
 1=评级
 2=屏蔽
 
 isEdit:判断有没有编辑
 */
-(void)setArrayData {
    self.dataArray = [[NSMutableArray alloc]init];
    
    ///备注
    NSDictionary *aDic1 = @{@"title":NSLocalizedString(@"CustomerRemark", @""),@"detail":([Utility checkString:[NSString stringWithFormat:@"%@",self.customerObj.customerRemark]]?self.customerObj.customerRemark:@""),@"status":@"0",@"isEdit":@"0"};
    [self.dataArray addObject:aDic1];
    
    ///评级
    NSDictionary *aDic2 = @{@"title":NSLocalizedString(@"CustomerLevel", @""),@"detail":[NSNumber numberWithInteger:self.customerObj.customerDegree],@"status":@"1",@"isEdit":@"0"};
    [self.dataArray addObject:aDic2];
    
    ///屏蔽
    NSDictionary *aDic3 = @{@"title":NSLocalizedString(@"CustomerShield", @""),@"detail":[NSNumber numberWithInteger:self.customerObj.customerShield],@"status":@"2",@"isEdit":@"0"};
    [self.dataArray addObject:aDic3];
    
    [self.tableView reloadData];
    
    SafeRelease(aDic1);
    SafeRelease(aDic2);
    SafeRelease(aDic3);
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
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

-(void)initFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
    UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    quitBtn.frame = CGRectMake((self.view.width-250)/2, 10, 250, 40);
    [quitBtn setTitle:NSLocalizedString(@"DeleteCustomer", @"") forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [quitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [quitBtn addTarget:self action:@selector(deleteCustomer:) forControlEvents:UIControlEventTouchUpInside];
    [quitBtn setBackgroundColor:COLOR(215, 0, 41, 1)];
    [footerView addSubview:quitBtn];
    self.tableView.tableFooterView = footerView;
    footerView=nil;quitBtn = nil;
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    BOOL res = [self checkNavRight];
    if (res) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"SaveEdit", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"DontSave", @"") block:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            [self saveCustomerInfo];
        }];
        [alert show];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    [self saveCustomerInfo];
}
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQCustomerDetailEditCell";
    
    WQCustomerDetailEditCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQCustomerDetailEditCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setIdxPath:indexPath];
    [cell setDetailEditVC:self];
    
    NSDictionary *dic = (NSDictionary *)self.dataArray[indexPath.section];
    [cell setDictionary:dic];
    return cell;
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
}
#pragma mark -

-(void)switchChanged:(WQSwitch *)sender {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[sender.idxPath.section]];
    
    [mutableDic setObject:[NSNumber numberWithBool:sender.on] forKey:@"detail"];
    
    if (sender.on==self.customerObj.customerShield) {
        [mutableDic setObject:@"0" forKey:@"isEdit"];
    }else{
        [mutableDic setObject:@"1" forKey:@"isEdit"];
    }
    [self.dataArray replaceObjectAtIndex:sender.idxPath.section withObject:mutableDic];
    self.navBarView.rightBtn.enabled = [self checkNavRight];
}

-(void)startView:(WQStarView *)startView number:(NSInteger)start {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[startView.idxPath.section]];
    
    [mutableDic setObject:[NSNumber numberWithInteger:start] forKey:@"detail"];
    
    if (start==self.customerObj.customerDegree) {
        [mutableDic setObject:@"0" forKey:@"isEdit"];
    }else{
        [mutableDic setObject:@"1" forKey:@"isEdit"];
    }
    [self.dataArray replaceObjectAtIndex:startView.idxPath.section withObject:mutableDic];
    self.navBarView.rightBtn.enabled = [self checkNavRight];
}

-(void)textFieldDidChange:(NSNotification *)notification {
    WQProductText *text = (WQProductText *)notification.object;

    //数据更新
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[text.idxPath.section]];
    
    [mutableDic setObject:text.text forKey:@"detail"];
    
    if ([text.text isEqualToString:[NSString stringWithFormat:@"%@",self.customerObj.customerRemark]]) {
        [mutableDic setObject:@"0" forKey:@"isEdit"];
    }else {
        [mutableDic setObject:@"1" forKey:@"isEdit"];
    }
    [self.dataArray replaceObjectAtIndex:text.idxPath.section withObject:mutableDic];
    
    self.navBarView.rightBtn.enabled = [self checkNavRight];
    
    //字数限制
    NSInteger kMaxLength = 10;
    
    NSString *toBeString = text.text;
    NSString *lang = text.textInputMode.primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入
        UITextRange *selectedRange = [text markedTextRange];
        UITextPosition *position = [text positionFromPosition:selectedRange.start offset:0];
        if (!position) {
            if (toBeString.length > kMaxLength) {
                text.text = [toBeString substringToIndex:kMaxLength];
            }
        }
    }else {
        if (toBeString.length > kMaxLength) {
            text.text = [toBeString substringToIndex:kMaxLength];
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isKindOfClass:[WQProductText class]]) {
        WQProductText *text = (WQProductText *)textField;
        [text resignFirstResponder];
    }
    return YES;
}

-(BOOL)checkNavRight {
    BOOL isEditing = NO;
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dic = (NSDictionary *)self.dataArray[i];
        NSInteger isEdit = [[dic objectForKey:@"isEdit"]integerValue];
        if (isEdit==1) {
            isEditing = YES;
            break;
        }
    }
    return isEditing;
}

#pragma mark - 保存客户信息

-(void)saveCustomerInfo {
    
    __block NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *dic = (NSDictionary *)self.dataArray[i];
        NSInteger status = [[dic objectForKey:@"status"]integerValue];
        if (status==0) {
            [mutableDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"detail"]] forKey:@"remark"];
        }else if(status==1){
            [mutableDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"detail"]] forKey:@"degree"];
        }else if(status==2){
            [mutableDic setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"detail"]] forKey:@"shield"];
        }
    }
    
    [mutableDic setObject:[NSNumber numberWithInteger:self.customerObj.customerId] forKey:@"userId"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    self.interfaceTask = [[WQAPIClient sharedClient] POST:@"/rest/user/updateCustomer" parameters:mutableDic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                
                WQCustomerObj *customerObj = [[WQCustomerObj alloc] init];
                [customerObj mts_setValuesForKeysWithDictionary:aDic];
                
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(saveCustomerInfo:)]) {
                    [weakSelf.delegate saveCustomerInfo:customerObj];
                }
                [weakSelf.navigationController popViewControllerAnimated:YES];
                SafeRelease(mutableDic);
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

#pragma mark - 删除客户

-(void)deleteCustomer:(id)sender {
    self.delegate = self.customerVC;
    __unsafe_unretained typeof(self) weakSelf = self;
    NSDictionary *dic = @{@"userId":[NSNumber numberWithInteger:self.customerObj.customerId]};
    self.interfaceTask = [[WQAPIClient sharedClient] POST:@"/rest/user/delCustomer" parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                weakSelf.delegate = weakSelf.customerVC;
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(deleteCustomer:index:)]) {
                    [weakSelf.delegate deleteCustomer:weakSelf.customerObj index:self.indexPath];
                }
                
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
@end
