//
//  WQClassVC.m
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassVC.h"

#import "WQClassObj.h"

#import "MJRefresh.h"

#import "WQRightCell.h"

#import "UIViewController+MJPopupViewController.h"
#import "WQTextVC.h"

@interface WQClassVC ()<WQNavBarViewDelegate,UITableViewDataSource,UITableViewDelegate,RMSwipeTableViewCellDelegate,WQTextVCDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WQTextVC *textVC;

@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation WQClassVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_delegate);
    SafeRelease(_textVC);
    SafeRelease(_selectedClassObj);
}

-(void)testData {
    NSDictionary *aDic = [Utility returnDicByPath:@"ClassList"];
    NSArray *array = [aDic objectForKey:@"classList"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDic = (NSDictionary *)obj;
        WQClassObj *class = [[WQClassObj alloc]init];
        [class mts_setValuesForKeysWithDictionary:aDic];
        [weakSelf.dataArray addObject:class];
        SafeRelease(class);
        SafeRelease(aDic);
    }];
    
    //判断数据源
    if (self.dataArray.count>0) {
        [self.tableView reloadData];
        [self setNoneText:nil animated:NO];
    }else {
        [self setNoneText:NSLocalizedString(@"NoneClass", @"") animated:YES];
    }
}


#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    self.navBarView.titleLab.text = NSLocalizedString(@"ClassifySetup", @"");
    [self.navBarView.rightBtn setTitle:NSLocalizedString(@"Add", @"") forState:UIControlStateNormal];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];

    self.selectedIndex = -1;
    //集成刷新控件
    [self addHeader];
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
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

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
    } dateKey:@"WQClassVC"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
    //自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    self.toolControl.enabled = self.selectedIndex>=0?YES:NO;
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
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    self.textVC = LOADVC(@"WQTextVC");
    self.textVC.delegate = self;
    self.textVC.type = 0;
    
    [self presentPopupViewController:self.textVC animationType:MJPopupViewAnimationSlideBottomTop];
}
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NavgationHeight;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"classVCCell";
    
    WQRightCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQRightCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.row];
    
    if (self.isPresentVC) {//弹出选择分类
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionNone;
        
        if (self.selectedClassObj) {
            if (classObj.classId==self.selectedClassObj.classId) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.selectedIndex = indexPath.row;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else {
        cell.delegate = self;
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
    }
    
    
    [cell setClassObj:classObj];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isPresentVC) {
        WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
        if (indexPath.row == self.selectedIndex) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.selectedIndex = -1;
            self.selectedClassObj = nil;
        }else {
            if (self.selectedIndex>=0) {
                WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
                cellOld.accessoryType = UITableViewCellAccessoryNone;
                
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.selectedIndex = indexPath.row;
                self.selectedClassObj = (WQClassObj *)self.dataArray[indexPath.row];
            }else {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.selectedIndex = indexPath.row;
                self.selectedClassObj = (WQClassObj *)self.dataArray[indexPath.row];
            }
        }
    }
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewCell.contentView.height) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.row];
        if (classObj.productCount>0) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ClassDelete", @"")];
        }else {
            swipeTableViewCell.shouldAnimateCellReset = NO;
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 swipeTableViewCell.contentView.frame = CGRectOffset(swipeTableViewCell.contentView.bounds, swipeTableViewCell.contentView.frame.size.width, 0);
                             }
                             completion:^(BOOL finished) {
                                 
                                 [self.dataArray removeObjectAtIndex:indexPath.row];
                                 [self.tableView beginUpdates];
                                 [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                 [self.tableView endUpdates];
                             }
             ];
        }
    }
}

//确认选择
-(void)toolControlPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedClass:)]) {
        [self.delegate selectedClass:(WQClassObj *)self.dataArray[self.selectedIndex]];
    }
}
#pragma mark - WQTextVCDelegate
-(void)dismissTextVC:(WQTextVC *)textVC {
    WQClassObj *classObj = [[WQClassObj alloc]init];
    classObj.className = textVC.text.text;
    [self.dataArray addObject:classObj];
    
    [self.tableView reloadData];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
}
@end
