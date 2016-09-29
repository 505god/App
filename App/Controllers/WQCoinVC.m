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
#import "WQLocalDB.h"

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
    
    self.selectedIndex = -1;
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isPresentVC) {
        [self setToolImage:@"" text:NSLocalizedString(@"Finish", @"") animated:YES];
        [self.navBarView.rightBtn setHidden:YES];
    }
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
        _tableView = [[UITableView alloc]initWithFrame:self.isPresentVC?(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-20-self.navBarView.height*2}:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height} style:UITableViewStylePlain];
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
    self.interfaceTask = [[WQAPIClient sharedClient] POST:@"/rest/store/updateCoinType" parameters:@{@"coinType":[NSNumber numberWithInteger:self.selectedIndex]} success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                [WQDataShare sharedService].userObj.moneyType = self.selectedIndex;
                
                [[WQLocalDB sharedWQLocalDB] saveUserDataToLocal:[WQDataShare sharedService].userObj completeBlock:^(BOOL finished) {
                    if (finished) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
                
            }else {
                [Utility interfaceWithStatus:[[jsonData objectForKey:@"status"]integerValue] msg:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    if (self.isPresentVC) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        if (self.selectedIndex != [WQDataShare sharedService].userObj.moneyType && self.selectedIndex>=0) {
             
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"" message:NSLocalizedString(@"SaveEdit", @"")];
             
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
}
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    [self changeTheCoin];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    if (self.selectedIndex>=0) {
        if (self.selectedIndex==self.coinType) {
            self.toolControl.enabled = NO;
        }else {
            self.toolControl.enabled = YES;
        }
    }else {
        self.toolControl.enabled = NO;
    }
}
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NavgationHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"classVCCell";
    
    WQRightCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQRightCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    //判断用户对应的货币
    cell.revealDirection = RMSwipeTableViewCellRevealDirectionNone;
    
    if (self.isPresentVC) {
        if (indexPath.row == self.coinType-1) {
            [cell setSelectedType:2];
            self.selectedIndex = self.coinType;
        }else {
            [cell setSelectedType:1];
        }
    }else {
        if (indexPath.row == [WQDataShare sharedService].userObj.moneyType-1) {
            [cell setSelectedType:2];
            self.selectedIndex = [WQDataShare sharedService].userObj.moneyType;
        }else {
            [cell setSelectedType:0];
        }
    }
    
    if (indexPath.row== 0) {
        cell.titleLab.text = NSLocalizedString(@"USD", @"");
    }else if (indexPath.row== 1) {
        cell.titleLab.text = NSLocalizedString(@"EUR", @"");
    }else if (indexPath.row== 2) {
        cell.titleLab.text = NSLocalizedString(@"EUR", @"");
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.isPresentVC) {
        if (indexPath.row == self.selectedIndex-1) {
            [cell setSelectedType:1];
            self.selectedIndex = -1;
        }else {
            [cell setSelectedType:2];
            
            if (self.selectedIndex>=0) {
                WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex-1 inSection:0]];
                [cellOld setSelectedType:1];
            }
            
            self.selectedIndex = indexPath.row+1;
        }
    }else {
        if (indexPath.row == self.selectedIndex-1) {
            
        }else {
            [cell setSelectedType:2];
            
            WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex-1 inSection:0]];
            [cellOld setSelectedType:0];
            
            self.selectedIndex = indexPath.row+1;
            
            if (self.selectedIndex == [WQDataShare sharedService].userObj.moneyType) {
                [self.navBarView.rightBtn setEnabled:NO];
            }else {
                [self.navBarView.rightBtn setEnabled:YES];
            }
        }
    }
}


//确认选择
-(void)toolControlPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(coinVC:selectedCoin:name:)]) {
        WQRightCell *cell = (WQRightCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex-1 inSection:0]];
        [self.delegate coinVC:self selectedCoin:self.selectedIndex name:cell.titleLab.text];
    }
}
@end
