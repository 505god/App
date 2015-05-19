//
//  WQCoinVC.m
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCoinVC.h"
#import "BlockAlertView.h"
#import "WQRightCell.h"

@interface WQCoinVC ()<WQNavBarViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger selectedIndex;

@end


@implementation WQCoinVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"CurrencySetup", @"")];
    
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveAct"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveNor"] forState:UIControlStateHighlighted];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveNor"] forState:UIControlStateDisabled];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    [self.navBarView.rightBtn setEnabled:NO];
    
    [self.tableView reloadData];
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
    self.interfaceTask= nil;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - property
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

#pragma mark - 导航栏代理
-(void)changeTheCoin {
    self.interfaceTask = [[WQAPIClient sharedClient] POST:@"/rest/store/updateSize" parameters:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                [WQDataShare sharedService].userObj.moneyType = self.selectedIndex;
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}
//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    if (self.selectedIndex != [WQDataShare sharedService].userObj.moneyType) {
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"SaveEdit", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"DontSave", @"") block:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            [self changeTheCoin];
        }];
        [alert show];
    }else {
       [self.navigationController popViewControllerAnimated:YES];
    }
}
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    [self changeTheCoin];
}
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NavgationHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"classVCCell";
    
    WQRightCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQRightCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    //判断用户对应的货币
    cell.revealDirection = RMSwipeTableViewCellRevealDirectionNone;
    
    if (indexPath.row == [WQDataShare sharedService].userObj.moneyType) {
        [cell setSelectedType:2];
        self.selectedIndex = indexPath.row;
    }else {
        [cell setSelectedType:0];
    }
    
    if (indexPath.row== 0) {
        cell.titleLab.text = NSLocalizedString(@"CNY", @"");
    }else if (indexPath.row== 1) {
        cell.titleLab.text = NSLocalizedString(@"USD", @"");
    }else if (indexPath.row== 2) {
        cell.titleLab.text = NSLocalizedString(@"EUR", @"");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == self.selectedIndex) {
        
    }else {
        WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setSelectedType:2];
        
        WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
        [cellOld setSelectedType:0];
        
        self.selectedIndex = indexPath.row;
        
        if (self.selectedIndex == [WQDataShare sharedService].userObj.moneyType) {
            [self.navBarView.rightBtn setEnabled:NO];
        }else {
            [self.navBarView.rightBtn setEnabled:YES];
        }
    }
}

@end
