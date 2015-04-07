//
//  WQSizeVC.m
//  App
//
//  Created by 邱成西 on 15/2/12.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSizeVC.h"

#import "WQSizeObj.h"

#import "MJRefresh.h"

#import "WQRightCell.h"

#import "UIViewController+MJPopupViewController.h"
#import "WQTextVC.h"

@interface WQSizeVC ()<UITableViewDelegate,UITableViewDataSource,WQNavBarViewDelegate,RMSwipeTableViewCellDelegate,WQTextVCDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) WQTextVC *textVC;
@end

@implementation WQSizeVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_textVC);
    SafeRelease(_selectedList);
    SafeRelease(_delegate);
}

-(void)testData {
    NSDictionary *aDic = [Utility returnDicByPath:@"SizeList"];
    NSArray *array = [aDic objectForKey:@"sizeList"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDic = (NSDictionary *)obj;
        WQSizeObj *class = [[WQSizeObj alloc]init];
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
        [self setNoneText:NSLocalizedString(@"NoneSize", @"") animated:YES];
    }
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    self.navBarView.titleLab.text = NSLocalizedString(@"SizeSetup", @"");
    [self.navBarView.rightBtn setTitle:NSLocalizedString(@"Add", @"") forState:UIControlStateNormal];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
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
    } dateKey:@"WQColorVC"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
    //自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
}

-(void)setSelectedList:(NSMutableArray *)selectedList {
    _selectedList = selectedList;
    
    self.toolControl.enabled = selectedList.count>0?YES:NO;
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
    self.textVC.type = 1;
    
    [self presentPopupViewController:self.textVC animationType:MJPopupViewAnimationSlideBottomTop];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NavgationHeight;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = @"size_cell";
    
    WQRightCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WQRightCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
    }
    
    WQSizeObj *size = (WQSizeObj *)self.dataArray[indexPath.row];
    
    if (self.isPresentVC) {//弹出选择分类
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionNone;
        
        BOOL isExit = NO;
        for (int i=0; i<self.selectedList.count; i++) {
            WQSizeObj *sizeTemp = self.selectedList[i];
            
            if (size.sizeId == sizeTemp.sizeId) {
                isExit = YES;
                break;
            }
        }
        
        cell.accessoryType = isExit?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
        
        cell.accessoryType = isExit?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    }else {
        cell.delegate = self;
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
    }
    
    [cell setSizeObj:size];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isPresentVC) {
        WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        WQSizeObj *size = (WQSizeObj *)self.dataArray[indexPath.row];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            for (int i=0; i<self.selectedList.count; i++) {
                 WQSizeObj *sizeTemp = self.selectedList[i];
                
                if (size.sizeId == sizeTemp.sizeId) {
                    [self.selectedList removeObject:sizeTemp];
                    
                    self.toolControl.enabled = self.selectedList.count>0?YES:NO;
                    break;
                }
            }
        }else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            size.stockCount = 0;
            [self.selectedList addObject:size];
            self.toolControl.enabled = self.selectedList.count>0?YES:NO;
        }
    }
}
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewCell.contentView.height) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        WQSizeObj *sizeObj = (WQSizeObj *)self.dataArray[indexPath.row];
        
        if (sizeObj.productCount>0) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"SizeDelete", @"")];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeVC:didSelectSize:)]) {
        [self.delegate sizeVC:self didSelectSize:self.selectedList];
    }
}

#pragma mark - WQTextVCDelegate
-(void)dismissTextVC:(WQTextVC *)textVC {
    WQSizeObj *colorObj = [[WQSizeObj alloc]init];
    colorObj.sizeName = textVC.text.text;
    [self.dataArray addObject:colorObj];
    
    [self.tableView reloadData];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
}

@end
