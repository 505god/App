//
//  WQProductClassifyVC.m
//  App
//
//  Created by 邱成西 on 15/3/25.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassifyVC.h"

#import "MJRefresh.h"

#import "WQClassObj.h"
#import "WQProductObj.h"

#import "WQClassHeader.h"
#import "WQClassCell.h"

@interface WQClassifyVC ()<UITableViewDataSource, UITableViewDelegate,WQClassHeaderDelegate,RMSwipeTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
///分类是否打开
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@end

@implementation WQClassifyVC

-(void)dealloc {
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_arrSelSection);
}

#pragma mark - 获取分类数据

-(void)getClassList {
    __unsafe_unretained typeof(self) weakSelf = self;
    [WQAPIClient getClassListWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            weakSelf.dataArray = nil;
            weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
            
            //判断数据源
            if (weakSelf.dataArray.count>0) {
                [weakSelf.tableView reloadData];
                [weakSelf setNoneText:nil animated:NO];
                [weakSelf setToolImage:nil text:nil animated:NO];
            }else {
                [weakSelf setNoneText:NSLocalizedString(@"NoneClass", @"") animated:YES];
                [weakSelf setToolImage:@"compose_photograph_highlighted" text:NSLocalizedString(@"NewClass", @"") animated:YES];
            }
        }else {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        }
    }];
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
        [self setToolImage:nil text:nil animated:NO];
    }else {
        [self setNoneText:NSLocalizedString(@"NoneClass", @"") animated:YES];
        [self setToolImage:@"compose_photograph_highlighted" text:NSLocalizedString(@"NewClass", @"") animated:YES];
    }
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstShow = YES;
    
    //KVO监测view的frame变化
    [self.view addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:Nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirstShow) {
        //集成刷新控件
        [self addHeader];
        self.isFirstShow = NO;
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

#pragma mark - private

- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    // 添加下拉刷新头部控件
    [self.tableView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf getClassList];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            // 结束刷新
            [weakSelf.tableView headerEndRefreshing];
        });
    } dateKey:@"WQClassifyVC"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
    //自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
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
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WQClassHeader class] forHeaderFooterViewReuseIdentifier:@"WQClassHeader"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSMutableArray *)arrSelSection {
    if (!_arrSelSection) {
        _arrSelSection = [[NSMutableArray alloc]init];
    }
    return _arrSelSection;
}
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NavgationHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WQClassHeader *header = (WQClassHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WQClassHeader"];
    header.classDelegate = self;
    WQClassObj *classObj = (WQClassObj *)self.dataArray[section];
    [header setClassObj:classObj];
    header.aSection = section;
    
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (int i = 0; i < self.arrSelSection.count; i++) {
        if (section == [self.arrSelSection[i] integerValue]) {
            WQClassObj *classObj = (WQClassObj *)self.dataArray[section];
            return classObj.productList.count;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"classCell";
    
    WQClassCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQClassCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
    
    WQProductObj *productObj = (WQProductObj *)classObj.productList[indexPath.row];
    
    [cell setProductObj:productObj];
    
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Swipe Table View Cell Delegate
-(void)swipeTableViewCellDidStartSwiping:(RMSwipeTableViewCell *)swipeTableViewCell {
}
-(void)swipeTableViewCell:(RMSwipeTableViewCell *)swipeTableViewCell didSwipeToPoint:(CGPoint)point velocity:(CGPoint)velocity {
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {

    if (point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
        WQProductObj *productObj = (WQProductObj *)classObj.productList[indexPath.row];
        
        if (productObj.productIsHot==1) {
            productObj.productIsHot = 0;
            //TODO:接口
        } else {
            productObj.productIsHot = 1;
            //TODO:接口
        }
        WQClassCell *cell = (WQClassCell*)swipeTableViewCell;
        [cell setIsHotSale:productObj.productIsHot];
    } else if (point.x < 0 && -point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
        WQProductObj *productObj = (WQProductObj *)classObj.productList[indexPath.row];
        
        if (productObj.productIsSale==1) {
            productObj.productIsSale = 0;
            //TODO:接口
        } else {
            productObj.productIsSale = 1;
            //TODO:接口
        }
        WQClassCell *cell = (WQClassCell*)swipeTableViewCell;
        [cell setIsToSale:productObj.productIsSale];
    }
}

-(void)swipeTableViewCellDidResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
}

#pragma mark - section事件
//展开分类
-(void)headerDidSelectCoverOption:(WQClassHeader *)header {
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
        WQClassObj *classObj = (WQClassObj *)self.dataArray[header.aSection];
        if (classObj.productList.count>0) {
            [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",header.aSection]];
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }else {//打开状态
        [self.arrSelSection removeObject:[NSString stringWithFormat:@"%d",header.aSection]];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}
//修改分类
-(void)headerDidLongPressedOption:(WQClassHeader *)header {
    
}

#pragma mark - toolBar事件
-(void)toolControlPressed {
    
}
#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self updateSubViews];
}
-(void)updateSubViews {
    self.tableView.frame = (CGRect){0, 0, self.view.width, self.view.height};
    self.noneView.frame = (CGRect){0, 0, self.view.width, self.view.height};
    self.noneLabel.frame = (CGRect){(self.view.width-60)/2,(self.view.height-20)/2-30,60,20};
    
    self.toolControl.frame = (CGRect){0,self.view.height-NavgationHeight,self.view.width,NavgationHeight};
}
@end
