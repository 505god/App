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

#import "BlockTextPromptAlertView.h"

@interface WQSizeVC ()<UITableViewDelegate,UITableViewDataSource,WQNavBarViewDelegate,RMSwipeTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation WQSizeVC

-(void)dealloc {
    SafeRelease(_tableView.delegate);
    SafeRelease(_tableView.dataSource);
    SafeRelease(_tableView);
    SafeRelease(_dataArray);
    SafeRelease(_selectedSizeObj);
    SafeRelease(_delegate);
}

#pragma mark - 颜色列表
-(void)getSizeList {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [[WQAPIClient sharedClient] GET:@"/rest/store/sizeList" parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        weakSelf.dataArray = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                NSArray *postsFromResponse = [aDic objectForKey:@"sizeList"];
                
                NSMutableArray *mutablePosts = [NSMutableArray arrayWithCapacity:[postsFromResponse count]];
                
                for (NSDictionary *attributes in postsFromResponse) {
                    WQSizeObj *sizeObj = [[WQSizeObj alloc] init];
                    [sizeObj mts_setValuesForKeysWithDictionary:attributes];
                    [mutablePosts addObject:sizeObj];
                    SafeRelease(sizeObj);
                }
                
                [weakSelf.dataArray addObjectsFromArray:mutablePosts];
                
                [WQDataShare sharedService].sizeArray = [[NSMutableArray alloc]initWithArray:weakSelf.dataArray];
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
        [self setNoneText:NSLocalizedString(@"NoneSize", @"") animated:YES];
    }else {
        [self setNoneText:nil animated:NO];
    }
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"SizeSetup", @"")];
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
    
    if ([WQDataShare sharedService].sizeArray.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:[WQDataShare sharedService].sizeArray];
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
-(void)setSelectedSizeObj:(WQSizeObj *)selectedSizeObj {
    _selectedSizeObj = selectedSizeObj;
}
#pragma mark - private
// 添加下拉刷新头部控件
- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    
    [self.tableView addHeaderWithCallback:^{
        
        [weakSelf getSizeList];
    } dateKey:@"WQColorVC"];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    
    self.toolControl.enabled = self.selectedIndex>=0?YES:NO;
}
#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    if (self.isPresentVC) {
        /*
        if (self.selectedSizeObj) {
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
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"CreatSize", @"") message:nil textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        [[WQAPIClient sharedClient] POST:@"/rest/store/addSize" parameters:@{@"sizeName":textField.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    NSDictionary *aDic = [jsonData objectForKey:@"returnObj"];
                    
                    if ([aDic allKeys].count>0) {
                        WQSizeObj *sizeObj = [[WQSizeObj alloc] init];
                        [sizeObj mts_setValuesForKeysWithDictionary:aDic];
                        
                        [self.dataArray addObject:sizeObj];
                        [[WQDataShare sharedService].sizeArray addObject:sizeObj];
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
    
    cell.delegate = self;
    cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
    [cell setSelectedType:0];
    
    WQSizeObj *size = (WQSizeObj *)self.dataArray[indexPath.row];
    
    if (self.isPresentVC) {//弹出选择分类
        if (self.selectedSizeObj) {
            if (size.sizeId==self.selectedSizeObj.sizeId) {
                [cell setSelectedType:2];
                self.selectedIndex = indexPath.row;
            }else {
                [cell setSelectedType:1];
            }
        }else {
            [cell setSelectedType:1];
        }
        
        if ([self.hasSelectedSize containsObject:[NSString stringWithFormat:@"%d",size.sizeId]]) {
            [cell setIsCanSelected:NO];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }else {
            [cell setIsCanSelected:YES];
            [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        }
        
    }
    
    [cell setSizeObj:size];
    [cell setIndexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isPresentVC) {
        
        WQSizeObj *sizeObj = (WQSizeObj *)self.dataArray[indexPath.row];
        if ([self.hasSelectedSize containsObject:[NSString stringWithFormat:@"%d",sizeObj.sizeId]]) {
            
        }else {
            WQRightCell *cell = (WQRightCell *)[tableView cellForRowAtIndexPath:indexPath];
            
            if (indexPath.row == self.selectedIndex) {
                [cell setSelectedType:1];
                self.selectedIndex = -1;
                self.selectedSizeObj = nil;
            }else {
                if (self.selectedIndex>=0) {
                    WQRightCell *cellOld = (WQRightCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectedIndex inSection:0]];
                    [cellOld setSelectedType:1];
                    
                    [cell setSelectedType:2];
                    self.selectedIndex = indexPath.row;
                    self.selectedSizeObj = sizeObj;
                }else {
                    [cell setSelectedType:2];
                    self.selectedIndex = indexPath.row;
                    self.selectedSizeObj = sizeObj;
                }
            }
        }
    }
}
//删除尺码
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= swipeTableViewCell.contentView.height) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        WQSizeObj *sizeObj = (WQSizeObj *)self.dataArray[indexPath.row];
        
        if (sizeObj.productCount>0) {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"SizeDelete", @"")];
        }else {
            swipeTableViewCell.shouldAnimateCellReset = YES;
            BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
            
            [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
            [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
                [UIView animateWithDuration:0.25
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     swipeTableViewCell.contentView.frame = CGRectOffset(swipeTableViewCell.contentView.bounds, swipeTableViewCell.contentView.frame.size.width, 0);
                                 }
                                 completion:^(BOOL finished) {
                                     [[WQAPIClient sharedClient] POST:@"/rest/store/delSize" parameters:@{@"sizeId":[NSNumber numberWithInteger:sizeObj.sizeId]} success:^(NSURLSessionDataTask *task, id responseObject) {
                                         
                                         if ([responseObject isKindOfClass:[NSDictionary class]]) {
                                             NSDictionary *jsonData=(NSDictionary *)responseObject;
                                             
                                             if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                                                 [self.dataArray removeObjectAtIndex:indexPath.row];
                                                 [[WQDataShare sharedService].sizeArray removeObjectAtIndex:indexPath.row];
                                                 
                                                 if (self.dataArray.count==0) {
                                                     [self setNoneText:NSLocalizedString(@"NoneSize", @"") animated:YES];
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
        }
    }
}
//修改尺码
-(void)editDidLongPressedOption:(RMSwipeTableViewCell *)cell {
    UITextField *textField;
    BlockTextPromptAlertView *alert = [BlockTextPromptAlertView promptWithTitle:NSLocalizedString(@"EditSize", @"") message:nil defaultText:[(WQRightCell *)cell sizeObj].sizeName textField:&textField type:0 block:^(BlockTextPromptAlertView *alert){
        [alert.textField resignFirstResponder];
        return YES;
    }];
    
    [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
    [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
        WQSizeObj *sizeObj = (WQSizeObj *)self.dataArray[[[(WQRightCell *)cell indexPath] row]];
        
        [[WQAPIClient sharedClient] POST:@"/rest/store/updateSize" parameters:@{@"sizeId":[NSNumber numberWithInteger:sizeObj.sizeId],@"sizeName":textField.text} success:^(NSURLSessionDataTask *task, id responseObject) {
            
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    sizeObj.sizeName = textField.text;
                    
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
}
//确认选择
-(void)toolControlPressed {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sizeVC:selectedSize:)]) {
        [self.delegate sizeVC:self selectedSize:(WQSizeObj *)self.dataArray[self.selectedIndex]];
    }
}

@end
