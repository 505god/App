//
//  WQClassVC.m
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassVC.h"

#import "MJRefresh.h"

#import "WQClassObj.h"
#import "WQClassLevelObj.h"

#import "WQClassHeader.h"
#import "WQRightCell.h"

#import "BlockTextPromptAlertView.h"
#import "BlockAlertView.h"

@interface WQClassVC ()<WQNavBarViewDelegate,UITableViewDataSource,UITableViewDelegate,RMSwipeTableViewCellDelegate,WQSwipTableHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

///选择分类
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSIndexPath *selectedIdx;

///分类是否打开
@property (nonatomic, strong) NSMutableArray *arrSelSection;
@end

@implementation WQClassVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_delegate);
    SafeRelease(_selectedClassBObj);
    SafeRelease(_arrSelSection);
    SafeRelease(_selectedIdx);
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
    [self.navBarView setTitleString:NSLocalizedString(@"ClassifySetup", @"")];
    [self.navBarView.rightBtn setTitle:NSLocalizedString(@"Add", @"") forState:UIControlStateNormal];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    self.isSelected = NO;
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
        _tableView.backgroundColor = [UIColor clearColor];
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

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    self.toolControl.enabled = self.isSelected?YES:NO;
}

-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    _selectedIndexPath = selectedIndexPath;
}
#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    if (self.isPresentVC) {
        /*
        if (self.selectedClassBObj) {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmCancelSelected", @"")];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert show];
        }else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
         */
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {//添加一级分类
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"CreatClass", @"") message:nil textField:&textField block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        DLog(@"Text: %@", textField.text);
        
        WQClassObj *classObj = [[WQClassObj alloc]init];
        classObj.className = textField.text;
        [self.dataArray addObject:classObj];
        
        [self.tableView beginUpdates];
        [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.dataArray.count-1] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
    [alert show];
}
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NavgationHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WQClassHeader *header = (WQClassHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WQClassHeader"];
    header.delegate = self;
    header.revealDirection = WQSwipTableHeaderRevealDirectionRight;
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
            return classObj.levelClassList.count+1;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"rightClassVCCell";
    
    WQRightCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQRightCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell setIsLevel:YES];
    [cell setIndexPath:indexPath];
    
    [cell setSelectedType:0];
    
    WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
    
    if (indexPath.row==classObj.levelClassList.count) {
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionNone;
        cell.textLabel.text = NSLocalizedString(@"AddMoreLevelClass", @"");
    }else {
        WQClassLevelObj *levelClassObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
        
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
        cell.delegate = self;
        
        
        if (self.isPresentVC) {//弹出选择分类
            if (self.selectedClassBObj) {
                if (levelClassObj.levelClassId==self.selectedClassBObj.levelClassId) {
                    [cell setSelectedType:2];
                    self.selectedIdx = indexPath;
                }else {
                    [cell setSelectedType:1];
                }
            }else {
                [cell setSelectedType:1];
            }
        }
        [cell setLevelClassObj:levelClassObj];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
    
    if (self.isPresentVC) {
        if (indexPath.row==classObj.levelClassList.count) {//添加更多子分类
            UITextField *textField;
            BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"CreatClass", @"") message:nil textField:&textField block:^(BlockTextPromptAlertView *alert){
                [alert.textField resignFirstResponder];
                return YES;
            }];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                DLog(@"Text: %@", textField.text);
                
                WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
                
                WQClassLevelObj *levelClassObj = [[WQClassLevelObj alloc]init];
                levelClassObj.levelClassName = textField.text;
                
                if (classObj.levelClassList) {
                }else {
                    classObj.levelClassList = [[NSMutableArray alloc]init];
                }
                [classObj.levelClassList addObject:levelClassObj];
                classObj.levelClassCount ++;
                
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }];
            [alert show];
        }else {
            WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (!self.isSelected) {
                [cell setSelectedType:2];

                self.selectedIdx = indexPath;
                self.isSelected = YES;
                WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
                self.selectedClassBObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
            }else {
                if (indexPath.row==self.selectedIdx.row && indexPath.section==self.selectedIdx.section) {
                    [cell setSelectedType:1];

                    self.selectedIdx = nil;
                    self.selectedClassBObj = nil;
                    self.isSelected = NO;
                }else {
                    if (self.selectedIdx.section>=0 && self.selectedIdx.row>=0) {
                        WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx.row inSection:self.selectedIdx.section]];
                        [cellOld setSelectedType:1];
                        
                        [cell setSelectedType:2];

                        self.selectedIdx = indexPath;
                        
                        WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
                        self.selectedClassBObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
                    }
                }
            }
        }
    }else {
        WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
        if (indexPath.row == classObj.levelClassList.count) {//添加更多子分类
            UITextField *textField;
            BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"CreatClass", @"") message:nil textField:&textField block:^(BlockTextPromptAlertView *alert){
                [alert.textField resignFirstResponder];
                return YES;
            }];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                DLog(@"Text: %@", textField.text);
                
                WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
                
                WQClassLevelObj *levelClassObj = [[WQClassLevelObj alloc]init];
                levelClassObj.levelClassName = textField.text;
                
                if (classObj.levelClassList) {
                }else {
                    classObj.levelClassList = [[NSMutableArray alloc]init];
                }
                [classObj.levelClassList addObject:levelClassObj];
                classObj.levelClassCount ++;
                
                [self.tableView beginUpdates];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                [self.tableView endUpdates];
            }];
            [alert show];
        }
    }
}

-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewCell.contentView.height) {
        
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
                                     [classObj.levelClassList removeObjectAtIndex:indexPath.row];
                                     classObj.levelClassCount --;
                                     [swipeTableViewCell setHidden:YES];
                                     
                                     [self.tableView beginUpdates];
                                     [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     [self.tableView endUpdates];
                                 }
                 ];
            }];
            [alert show];
        }
    }
}
-(void)swipeTableViewHeaderWillResetState:(WQSwipTableHeader*)swipeTableViewHeader fromPoint:(CGPoint)point animation:(WQSwipTableHeaderAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewHeader.height) {
        
        WQClassHeader *header = (WQClassHeader *)swipeTableViewHeader;
        DLog(@"section = %d",header.aSection);
        WQClassObj *classObj = (WQClassObj *)self.dataArray[header.aSection];
        
        if (classObj.levelClassList.count>0) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ClassDelete", @"")];
        }else {
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                header.shouldAnimateCellReset = NO;
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     header.frame = CGRectOffset(header.bounds, header.frame.size.width, 0);
                                 }completion:^(BOOL finished) {
                                     [self.dataArray removeObjectAtIndex:header.aSection];
                                     
                                     if ([self.arrSelSection containsObject:[NSString stringWithFormat:@"%d",header.aSection]]) {
                                         [self.arrSelSection removeObject:[NSString stringWithFormat:@"%d",header.aSection]];
                                     }
                                     
                                     [header setHidden:YES];
                                     
                                     [self.tableView beginUpdates];
                                     [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     [self.tableView endUpdates];
                                 }];
            }];
            [alert show];
        }
    }
}
-(void)editDidLongPressedOption:(RMSwipeTableViewCell *)cell {//修改子分类
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"EditClass", @"") message:nil defaultText:[(WQRightCell *)cell levelClassObj].levelClassName textField:&textField block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        DLog(@"Text: %@", textField.text);
        
        WQClassObj *classObj = (WQClassObj *)self.dataArray[[[(WQRightCell *)cell indexPath] section]];
        WQClassLevelObj *levelClassObj = (WQClassLevelObj *)classObj.levelClassList[[[(WQRightCell *)cell indexPath] row]];
        levelClassObj.levelClassName = textField.text;
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[(WQRightCell *)cell indexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
    [alert show];
}

//确认选择
-(void)toolControlPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(classVC:selectedClass:)]) {
        WQClassObj *classObj = (WQClassObj *)self.dataArray[self.selectedIdx.section];
        [self.delegate classVC:self selectedClass:(WQClassLevelObj *)classObj.levelClassList[self.selectedIdx.row]];
    }
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
        [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",header.aSection]];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }else {//打开状态
        [self.arrSelSection removeObject:[NSString stringWithFormat:@"%d",header.aSection]];
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}
-(void)editDidLongPressedHeaderOption:(WQSwipTableHeader *)Header {
    WQClassHeader *header = (WQClassHeader *)Header;
    
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"EditClass", @"") message:nil defaultText:header.classObj.className textField:&textField block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
         DLog(@"Text: %@", textField.text);
        
        WQClassObj *classObj = (WQClassObj *)self.dataArray[header.aSection];
        classObj.className = textField.text;
        
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
    [alert show];
}

@end
