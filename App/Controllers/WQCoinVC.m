//
//  WQCoinVC.m
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCoinVC.h"

#import "WQRightCell.h"

@interface WQCoinVC ()<WQNavBarViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation WQCoinVC
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    self.navBarView.titleLab.text = NSLocalizedString(@"CurrencySetup", @"");
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isPresentVC) {
        [self setToolImage:@"compose_photograph_highlighted" text:NSLocalizedString(@"Finish", @"") animated:YES];
    }
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
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.isPresentVC?(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-20-self.navBarView.height*2}:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    if (self.isPresentVC) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
    
//    if (self.isPresentVC) {
//        WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
//        if (indexPath.row == self.selectedIndex) {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//            self.selectedIndex = -1;
//            self.selectedClassObj = nil;
//        }else {
//            if (self.selectedIndex>=0) {
//                WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
//                cellOld.accessoryType = UITableViewCellAccessoryNone;
//                
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                self.selectedIndex = indexPath.row;
//                self.selectedClassObj = (WQClassObj *)self.dataArray[indexPath.row];
//            }else {
//                cell.accessoryType = UITableViewCellAccessoryCheckmark;
//                self.selectedIndex = indexPath.row;
//                self.selectedClassObj = (WQClassObj *)self.dataArray[indexPath.row];
//            }
//        }
//    }
}

@end
