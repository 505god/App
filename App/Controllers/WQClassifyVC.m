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
#import "WQClassLevelObj.h"

#import "WQClassHeader.h"
#import "WQClassCell.h"

#import "BlockAlertView.h"

@interface WQClassifyVC ()<UITableViewDataSource, UITableViewDelegate,RMSwipeTableViewCellDelegate,WQSwipTableHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;
///分类是否打开
@property (nonatomic, strong) NSMutableArray *arrSelSection;

@end

@implementation WQClassifyVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_arrSelSection);
}
-(void)testData {
    NSDictionary *aDic = [Utility returnDicByPath:@"ClassList"];
    NSArray *array = [aDic objectForKey:@"classList"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDic = (NSDictionary *)obj;
        WQClassObj *product = [[WQClassObj alloc]init];
        [product mts_setValuesForKeysWithDictionary:aDic];
        [weakSelf.dataArray addObject:product];
        SafeRelease(product);
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
#pragma mark - 获取分类数据

-(void)getClassList {
    __unsafe_unretained typeof(self) weakSelf = self;
    [WQAPIClient getClassListWithBlock:^(NSArray *array, NSError *error) {
        weakSelf.dataArray = nil;
        weakSelf.dataArray = [NSMutableArray arrayWithArray:array];
        
        //判断数据源
        if (weakSelf.dataArray.count>0) {
            [weakSelf.tableView reloadData];
            [weakSelf setNoneText:nil animated:NO];
        }else {
            [weakSelf setNoneText:NSLocalizedString(@"NoneClass", @"") animated:YES];
        }
        [weakSelf.tableView headerEndRefreshing];
    }];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isFirstShow = YES;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.isFirstShow) {
        //集成刷新控件
        [self addHeader];
        self.isFirstShow = NO;
        
        //自动刷新(一进入程序就下拉刷新)
        [self.tableView headerBeginRefreshing];
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
        [weakSelf testData];
    } dateKey:@"WQClassifyVC"];
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
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
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
    WQClassObj *classObj = (WQClassObj *)self.dataArray[section];
    [header setClassObj:classObj];
    header.aSection = section;
    header.revealDirection = WQSwipTableHeaderRevealDirectionNone;
    header.delegate = self;
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
            return classObj.levelClassList.count;
        }
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"classCell";
    
    WQClassCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQClassCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
    
    WQClassLevelObj *levelClassObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
    
    [cell setLevelClassObj:levelClassObj];
    cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.delegate = self;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = NavgationHeight;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
#pragma mark - Swipe Table View Cell Delegate
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    
    if (point.x < 0 && -point.x >= CGRectGetHeight(swipeTableViewCell.frame)) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
        WQClassLevelObj *levelClassObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
        
        if (levelClassObj.productCount>0) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ClassBDelete", @"")];
        }else {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                swipeTableViewCell.shouldAnimateCellReset = NO;
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     swipeTableViewCell.contentView.frame = CGRectOffset(swipeTableViewCell.contentView.bounds, swipeTableViewCell.contentView.frame.size.width, 0);
                                 }
                                 completion:^(BOOL finished) {
                                     [self.dataArray removeObjectAtIndex:indexPath.row];
                                     [swipeTableViewCell setHidden:YES];
                                     
                                     [self.tableView beginUpdates];
                                     [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     [self.tableView endUpdates];
                                 }
                 ];
            }];
            [alert show];
        }
    }
}


#pragma mark - section事件
//展开分类
-(void)editDidTapPressedOption:(WQSwipTableHeader *)Header {
    WQClassHeader *header = (WQClassHeader *)Header;
    
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
        if (classObj.levelClassList.count>0) {
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

#pragma mark - toolBar事件
-(void)toolControlPressed {
    
}

@end
