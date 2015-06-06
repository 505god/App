//
//  WQColorVC.m
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQColorVC.h"

#import "WQColorObj.h"

#import "MJRefresh.h"

#import "WQRightCell.h"


#import "BlockTextPromptAlertView.h"

@interface WQColorVC ()<UITableViewDelegate,UITableViewDataSource,WQNavBarViewDelegate,RMSwipeTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation WQColorVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_selectedColorObj);
    SafeRelease(_delegate);
}

#pragma mark - 颜色列表
-(void)getColorList {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [[WQAPIClient sharedClient] GET:@"/rest/store/colorList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.dataArray = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"colorList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQColorObj *colorObj = [[WQColorObj alloc] init];
                    [colorObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:colorObj];
                    SafeRelease(colorObj);
                }
                
                [weakSelf.dataArray addObjectsFromArray:mutablePosts];
                
                [WQDataShare sharedService].colorArray = [[NSMutableArray alloc]initWithArray:weakSelf.dataArray];
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        [weakSelf.tableView reloadData];
        [weakSelf checkDataArray];
        [weakSelf.tableView headerEndRefreshing];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [weakSelf.tableView headerEndRefreshing];
        [weakSelf checkDataArray];
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

-(void)checkDataArray {
    if (self.dataArray.count==0) {
        [self setNoneText:NSLocalizedString(@"NoneColor", @"") animated:YES];
    }else {
        [self setNoneText:nil animated:NO];
    }
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"ColorSetup", @"")];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addProperty"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"addPropertyNormal"] forState:UIControlStateHighlighted];
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
        [self setToolImage:@"" text:NSLocalizedString(@"Finish", @"") animated:YES];
    }
    
    if ([WQDataShare sharedService].colorArray.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:[WQDataShare sharedService].colorArray];
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
    [WQAPIClient cancelConnection];
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
        _tableView = [[UITableView alloc]initWithFrame:self.isPresentVC?(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-20-self.navBarView.height*2}:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - private
// 添加下拉刷新头部控件
- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addHeaderWithCallback:^{
        [weakSelf getColorList];
    } dateKey:@"WQColorVC"];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    self.toolControl.enabled = self.selectedIndex>=0?YES:NO;
}
-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    _selectedIndexPath = selectedIndexPath;
}
#pragma mark - 导航栏代理
//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    if (self.isPresentVC) {
        /*
        if (self.selectedColorObj) {
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
//右侧边栏的代理-------增加颜色
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    [Utility checkAlert];
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"CreatColor", @"") message:nil textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:^{
        [[WQDataShare sharedService].alertArray removeAllObjects];
    }];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        [[WQDataShare sharedService].alertArray removeAllObjects];
        [[WQAPIClient sharedClient] POST:@"/rest/store/addColor" parameters:@{@"colorName":textField.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                    if ([aDic allKeys].count>0) {
                        WQColorObj *colorObj = [[WQColorObj alloc] init];
                        [colorObj mts_setValuesForKeysWithDictionary:aDic];
                        
                        [self.dataArray addObject:colorObj];
                        [[WQDataShare sharedService].colorArray addObject:colorObj];
                        [self setNoneText:nil animated:NO];
                        NSIndexPath *idx = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
                        
                        [self.tableView beginUpdates];
                        [self.tableView insertRowsAtIndexPaths:@[idx] withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView endUpdates];
                    }
                }else {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        }];
    }];
    [alert show];
    [[WQDataShare sharedService].alertArray addObject:alert];
}
#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NavgationHeight;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = @"colorVCCell";
    
    WQRightCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WQRightCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
    [cell setSelectedType:0];
    
    if (self.dataArray.count>0) {
        
    }
    WQColorObj *color = (WQColorObj *)self.dataArray[indexPath.row];
    
    if (self.isPresentVC) {//弹出选择分类
        if (self.selectedColorObj) {
            if (color.colorId==self.selectedColorObj.colorId) {
                [cell setSelectedType:2];
                self.selectedIndex = indexPath.row;
            }else {
                [cell setSelectedType:1];
            }
        }else {
            [cell setSelectedType:1];
        }
        
        if ([self.hasSelectedColor containsObject:[NSString stringWithFormat:@"%d",color.colorId]]) {
            [cell setIsCanSelected:NO];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }else {
            [cell setIsCanSelected:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
    }
    
    [cell setColorObj:color];
    [cell setIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isPresentVC) {
        WQColorObj *colorObj = (WQColorObj *)self.dataArray[indexPath.row];
        if ([self.hasSelectedColor containsObject:[NSString stringWithFormat:@"%d",colorObj.colorId]]) {
            
        }else {
            WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (indexPath.row == self.selectedIndex) {
                [cell setSelectedType:1];
                self.selectedIndex = -1;
                self.selectedColorObj = nil;
            }else {
                if (self.selectedIndex>=0) {
                    WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
                    [cellOld setSelectedType:1];
                    
                    [cell setSelectedType:2];
                    self.selectedIndex = indexPath.row;
                    self.selectedColorObj = colorObj;
                }else {
                    [cell setSelectedType:2];
                    self.selectedIndex = indexPath.row;
                    self.selectedColorObj = colorObj;
                }
            }
        }
    }
}
//删除颜色
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewCell.contentView.height) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        WQColorObj *color = (WQColorObj *)self.dataArray[indexPath.row];
        
        if (color.productCount>0) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ColorDelete", @"")];
        }else {
            swipeTableViewCell.shouldAnimateCellReset = YES;
            
            [Utility checkAlert];
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:^{
                [[WQDataShare sharedService].alertArray removeAllObjects];
            }];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                [[WQDataShare sharedService].alertArray removeAllObjects];
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     swipeTableViewCell.contentView.frame = CGRectOffset(swipeTableViewCell.contentView.bounds, swipeTableViewCell.contentView.frame.size.width, 0);
                                 }
                                 completion:^(BOOL finished) {
                                     [[WQAPIClient sharedClient] POST:@"/rest/store/delColor" parameters:@{@"colorId":[NSNumber numberWithInteger:color.colorId]} success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                             NSDictionary *jsonData=(NSDictionary *)responseObject;
                                             
                                             if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                                                 [self.dataArray removeObjectAtIndex:indexPath.row];
                                                 
                                                 [[WQDataShare sharedService].colorArray removeObjectAtIndex:indexPath.row];
                                                 
                                                 if (self.dataArray.count==0) {
                                                     [self setNoneText:NSLocalizedString(@"NoneColor", @"") animated:YES];
                                                 }
                                                 
                                                 [swipeTableViewCell setHidden:YES];
                                                 
                                                 [self.tableView reloadData];
                                             }else {
                                                 [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                                             }
                                         }
                                         
                                     } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                         [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
                                     }];
                                 }
                 ];
            }];
            [alert show];
            [[WQDataShare sharedService].alertArray addObject:alert];
        }
    }
}
//修改颜色
-(void)editDidLongPressedOption:(RMSwipeTableViewCell *)cell {
    [Utility checkAlert];
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"EditColor", @"") message:nil defaultText:[(WQRightCell *)cell colorObj].colorName textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:^{
        [[WQDataShare sharedService].alertArray removeAllObjects];
    }];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        [[WQDataShare sharedService].alertArray removeAllObjects];
        WQColorObj *colorObj = (WQColorObj *)self.dataArray[[[(WQRightCell *)cell indexPath] row]];
        
        [[WQAPIClient sharedClient] POST:@"/rest/store/updateColor" parameters:@{@"colorId":[NSNumber numberWithInteger:colorObj.colorId],@"colorName":textField.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    colorObj.colorName = textField.text;
                    
                    [self.tableView beginUpdates];
                    [self.tableView reloadRowsAtIndexPaths:@[[(WQRightCell *)cell indexPath]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self.tableView endUpdates];
                }else {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                }
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        }];
    }];
    [alert show];
    [[WQDataShare sharedService].alertArray addObject:alert];
}
//确认选择
-(void)toolControlPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(colorVC:selectedColor:)]) {
        [self.delegate colorVC:self selectedColor:(WQColorObj *)self.dataArray[self.selectedIndex]];
    }
}

@end
