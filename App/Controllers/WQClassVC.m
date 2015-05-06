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
    SafeRelease(_selectedClassAObj);
    SafeRelease(_arrSelSection);
    SafeRelease(_selectedIdx);
}

#pragma mark - 获取分类列表

-(void)getClassList {
    __unsafe_unretained typeof(self) weakSelf = self;
    self.interfaceTask = [WQAPIClient getClassListWithBlock:^(NSArray *array, NSError *error) {
        [weakSelf.dataArray addObjectsFromArray:array];
        
        [WQDataShare sharedService].classArray = [[NSMutableArray alloc]initWithArray:weakSelf.dataArray];
        
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
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"ClassifySetup", @"")];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addProperty"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addPropertyNormal"] forState:UIControlStateHighlighted];
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
    
    if ([WQDataShare sharedService].classArray.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:[WQDataShare sharedService].classArray];
        [self.tableView reloadData];
    }else {
        //自动刷新(一进入程序就下拉刷新)
        [self.tableView headerBeginRefreshing];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
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
        _tableView = [[UITableView alloc]initWithFrame:self.isPresentVC?(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-self.navBarView.height*2}:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height} style:UITableViewStylePlain];
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
// 添加下拉刷新头部控件
- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        weakSelf.dataArray = nil;
        [weakSelf getClassList];
    } dateKey:@"WQClassVC"];
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
//右侧边栏的代理 ---------//添加一级分类
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"CreatClass", @"") message:nil textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        weakSelf.interfaceTask = [WQAPIClient addClassAWithParameters:@{@"classAName":textField.text} block:^(WQClassObj *classObject, NSError *error) {
            [weakSelf.dataArray addObject:classObject];
            
            [[WQDataShare sharedService].classArray addObject:classObject];
            [self setNoneText:nil animated:NO];
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView insertSections:[NSIndexSet indexSetWithIndex:self.dataArray.count-1] withRowAnimation:UITableViewRowAnimationAutomatic];
            [weakSelf.tableView endUpdates];
        }];
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
        cell.imageView.image = [UIImage imageNamed:@"addProImg"];
        cell.textLabel.text = NSLocalizedString(@"AddMoreLevelClass", @"");
    }else {
        WQClassLevelObj *levelClassObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
        
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
        cell.delegate = self;
        
        
        if (self.isPresentVC) {//弹出选择分类
            if (self.selectedClassBObj && self.selectedClassAObj) {
                if (levelClassObj.levelClassId==self.selectedClassBObj.levelClassId && self.selectedClassAObj.classId==classObj.classId) {
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
//增加二级分类
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
    
    if (self.isPresentVC) {
        if (indexPath.row==classObj.levelClassList.count) {//添加更多子分类
            UITextField *textField;
            BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"CreatClass", @"") message:nil textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
                [alert.textField resignFirstResponder];
                return YES;
            }];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                [WQAPIClient addClassBWithParameters:@{@"classBName":textField.text,@"classAId":[NSNumber numberWithInteger:classObj.classId]} block:^(WQClassLevelObj *classObject, NSError *error) {
                    if (classObj.levelClassList) {
                    }else {
                        classObj.levelClassList = [[NSMutableArray alloc]init];
                    }
                    [classObj.levelClassList addObject:classObject];
                    classObj.levelClassCount ++;
                    [self.tableView beginUpdates];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                    
                }];
            }];
            [alert show];
        }else {
            WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (!self.isSelected) {
                [cell setSelectedType:2];

                self.selectedIdx = indexPath;
                self.isSelected = YES;
                self.selectedClassBObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
                self.selectedClassAObj = classObj;
            }else {
                if (indexPath.row==self.selectedIdx.row && indexPath.section==self.selectedIdx.section) {
                    [cell setSelectedType:1];

                    self.selectedIdx = nil;
                    self.selectedClassBObj = nil;
                    self.isSelected = NO;
                    self.selectedClassAObj = nil;
                }else {
                    if (self.selectedIdx.section>=0 && self.selectedIdx.row>=0) {
                        WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIdx.row inSection:self.selectedIdx.section]];
                        [cellOld setSelectedType:1];
                        
                        [cell setSelectedType:2];

                        self.selectedIdx = indexPath;
                        
                        self.selectedClassBObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
                        self.selectedClassAObj = classObj;
                    }
                }
            }
        }
    }else {
        if (indexPath.row == classObj.levelClassList.count) {//添加更多子分类
            UITextField *textField;
            BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"CreatClass", @"") message:nil textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
                [alert.textField resignFirstResponder];
                return YES;
            }];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                DLog(@"Text: %@", textField.text);
                
                [WQAPIClient addClassBWithParameters:@{@"classBName":textField.text,@"classAId":[NSNumber numberWithInteger:classObj.classId]} block:^(WQClassLevelObj *classObject, NSError *error) {
                    if (classObj.levelClassList) {
                    }else {
                        classObj.levelClassList = [[NSMutableArray alloc]init];
                    }
                    [classObj.levelClassList addObject:classObject];
                    classObj.levelClassCount ++;
                    
                    [self.tableView beginUpdates];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                    
                }];
            }];
            [alert show];
        }
    }
}
//删除二级分类
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewCell.contentView.height) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        WQClassObj *classObj = (WQClassObj *)self.dataArray[indexPath.section];
        WQClassLevelObj *levelClassObj = (WQClassLevelObj *)classObj.levelClassList[indexPath.row];
        if (levelClassObj.productCount>0) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ClassBDelete", @"")];
        }else {
            swipeTableViewCell.shouldAnimateCellReset = YES;
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
                                     
                                     [WQAPIClient deleteClassBWithParameters:@{@"classBId":[NSNumber numberWithInteger:levelClassObj.levelClassId]} block:^(NSInteger finished, NSError *error) {
                                         [classObj.levelClassList removeObjectAtIndex:indexPath.row];
                                         classObj.levelClassCount --;
                                         [swipeTableViewCell setHidden:YES];
                                         
                                         [self.tableView reloadData];
                                     }];
                                 }
                 ];
            }];
            [alert show];
        }
    }
}

//删除一级分类
-(void)swipeTableViewHeaderWillResetState:(WQSwipTableHeader*)swipeTableViewHeader fromPoint:(CGPoint)point animation:(WQSwipTableHeaderAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewHeader.height) {
        
        WQClassHeader *header = (WQClassHeader *)swipeTableViewHeader;

        WQClassObj *classObj = (WQClassObj *)self.dataArray[header.aSection];
        
        if (classObj.levelClassList.count>0) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ClassDelete", @"")];
        }else {
            header.shouldAnimateCellReset = YES;
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
                                     [WQAPIClient deleteClassAWithParameters:@{@"classAId":[NSNumber numberWithInteger:classObj.classId]} block:^(NSInteger finished, NSError *error) {
                                         [self.dataArray removeObjectAtIndex:header.aSection];
                                         
                                         if (self.dataArray.count==0) {
                                             [self setNoneText:NSLocalizedString(@"NoneClass", @"") animated:YES];
                                         }
                                         
                                         [[WQDataShare sharedService].classArray removeObjectAtIndex:header.aSection];
                                         
                                         if ([self.arrSelSection containsObject:[NSString stringWithFormat:@"%d",header.aSection]]) {
                                             [self.arrSelSection removeObject:[NSString stringWithFormat:@"%d",header.aSection]];
                                         }
                                         [self.tableView reloadData];
                                     }];
                                 }];
            }];
            [alert show];
        }
    }
}
//修改二级分类
-(void)editDidLongPressedOption:(RMSwipeTableViewCell *)cell {//修改子分类
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"EditClass", @"") message:nil defaultText:[(WQRightCell *)cell levelClassObj].levelClassName textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        DLog(@"Text: %@", textField.text);
        
        WQClassObj *classObj = (WQClassObj *)self.dataArray[[[(WQRightCell *)cell indexPath] section]];
        WQClassLevelObj *levelClassObj = (WQClassLevelObj *)classObj.levelClassList[[[(WQRightCell *)cell indexPath] row]];
        
        [WQAPIClient editClassBWithParameters:@{@"classBId":[NSNumber numberWithInteger:levelClassObj.levelClassId],@"classBName":textField.text} block:^(NSInteger finished, NSError *error) {
            levelClassObj.levelClassName = textField.text;
            
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[(WQRightCell *)cell indexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }];
    }];
    [alert show];
}

//确认选择
-(void)toolControlPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(classVC:classA:classB:)]) {
        WQClassObj *classObj = (WQClassObj *)self.dataArray[self.selectedIdx.section];
        [self.delegate classVC:self classA:classObj classB:(WQClassLevelObj *)classObj.levelClassList[self.selectedIdx.row]];
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
//修改一级分类
-(void)editDidLongPressedHeaderOption:(WQSwipTableHeader *)Header {
    WQClassHeader *header = (WQClassHeader *)Header;
    
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"EditClass", @"") message:nil defaultText:header.classObj.className textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        WQClassObj *classObj = (WQClassObj *)self.dataArray[header.aSection];
        
        [WQAPIClient editClassAWithParameters:@{@"classAId":[NSNumber numberWithInteger:classObj.classId ],@"classAName":textField.text} block:^(NSInteger finished, NSError *error) {
            classObj.className = textField.text;
            
            [self.tableView beginUpdates];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:header.aSection] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }];
    }];
    [alert show];
}

@end
