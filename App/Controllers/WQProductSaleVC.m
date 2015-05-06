//
//  WQProductSaleVC.m
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductSaleVC.h"

#import "WQProductSaleHeader.h"

#import "WQProductSaleTypeCell.h"

#import "WQProductText.h"

@interface WQProductSaleVC ()<UITableViewDelegate,UITableViewDataSource,WQNavBarViewDelegate,WQSwipTableHeaderDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;

@property (nonatomic, strong) UIToolbar *accessoryView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) UIDatePicker *datePicker;

@property (nonatomic, assign) CGFloat keyboardHeight;
@end

@implementation WQProductSaleVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"ProductSaleType", @"")];
    [self.navBarView.rightBtn setTitle:NSLocalizedString(@"Add", @"") forState:UIControlStateNormal];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    self.selectedIndex = [[self.objectDic objectForKey:@"type"]integerValue]+1;
    
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//右侧边栏的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    
    if (self.selectedIndex==0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectedSale:object:)]) {
            [self.delegate selectedSale:self object:self.objectDic];
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        if ([Utility checkString:[self.objectDic objectForKey:@"details"]]){
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectedSale:object:)]) {
                [self.delegate selectedSale:self object:self.objectDic];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [WQPopView showWithImageName:@"PriceConfirmError" message:NSLocalizedString(@"PriceError", @"")];
        }
    }
}

#pragma mark - property

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-self.navBarView.height-10} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WQProductSaleHeader class] forHeaderFooterViewReuseIdentifier:@"WQProductSaleHeader"];
    }
    return _tableView;
}

-(UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] initWithFrame:(CGRect){0,self.accessoryView.bottom,self.view.width,216}];
        [_datePicker setDatePickerMode:UIDatePickerModeDateAndTime];
        [_datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        [self.view insertSubview:_datePicker aboveSubview:self.tableView];
    }
    return _datePicker;
}
-(NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
        [_dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    }
    return _dateFormatter;
}
- (UIView *)accessoryView {
    if (!_accessoryView) {
        _accessoryView = [[UIToolbar alloc] initWithFrame:(CGRect){0,self.view.height,self.view.width,NavgationHeight}];
        _accessoryView.barStyle = UIBarStyleBlack;
        _accessoryView.translucent = YES;
        _accessoryView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hiddenDatePick)];
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        NSArray *array = [NSArray arrayWithObjects:flexibleSpaceLeft, doneBtn, nil];
        [_accessoryView setItems:array];
        SafeRelease(doneBtn);
        SafeRelease(flexibleSpaceLeft);
        
        [self.view addSubview:_accessoryView];
    }
    return _accessoryView;
}
-(void)setSelectedIndexPath:(NSIndexPath *)selectedIndexPath {
    _selectedIndexPath = selectedIndexPath;
}

- (void)hiddenDatePick{
    if (indexTemp==1) {
        self.startTime = self.datePicker.date;
        cellTemp.detailTextLabel.text = [self.dateFormatter stringFromDate:self.startTime];
        [self.objectDic setObject:[self.dateFormatter stringFromDate:self.startTime] forKey:@"start"];
    }else if (indexTemp==2){
        self.endTime = self.datePicker.date;
        cellTemp.detailTextLabel.text = [self.dateFormatter stringFromDate:self.endTime];
        [self.objectDic setObject:[self.dateFormatter stringFromDate:self.endTime] forKey:@"end"];
    }
    
    [UIView animateWithDuration:0.25f animations:^{
        self.accessoryView.frame = (CGRect){0,self.view.height,self.view.width,NavgationHeight};
        self.datePicker.frame = (CGRect){0,self.accessoryView.bottom,self.view.width,216};
        self.tableView.frame = (CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-self.navBarView.height-10};
    }completion:^(BOOL finished) {
        [self.tableView deselectRowAtIndexPath:cellTemp.indexPath animated:YES];
        cellTemp = nil;
        indexTemp = -1;
        [self.datePicker removeFromSuperview];
        [self.accessoryView removeFromSuperview];
        self.datePicker  = nil;
        self.accessoryView = nil;
    }];
}
- (void)dateChanged:(id)sender  {
    if (indexTemp==1) {
        self.startTime = ((UIDatePicker *)sender).date;
        cellTemp.detailTextLabel.text = [self.dateFormatter stringFromDate:self.startTime];
        [self.objectDic setObject:[self.dateFormatter stringFromDate:self.startTime] forKey:@"start"];
    }else if (indexTemp==2){
        self.endTime = ((UIDatePicker *)sender).date;
        cellTemp.detailTextLabel.text = [self.dateFormatter stringFromDate:self.endTime];
        [self.objectDic setObject:[self.dateFormatter stringFromDate:self.endTime] forKey:@"end"];
    }
}
#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==2) {
        return 0;
    }
    return 10;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NavgationHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    WQProductSaleHeader *header = (WQProductSaleHeader*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WQProductSaleHeader"];
    header.revealDirection = WQSwipTableHeaderRevealDirectionNone;
    if (section==0) {
        header.textString = NSLocalizedString(@"saleNone", @"");
    }else if (section==1) {
        header.textString = NSLocalizedString(@"salePrice", @"");
    }else if (section==2) {
        header.textString = NSLocalizedString(@"saleDisCount", @"");
    }
    
    if (section ==self.selectedIndex) {
        header.isSelected = YES;
    }else {
        header.isSelected = NO;
    }
    header.delegate = self;
    header.aSection = section;
    return header;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.width, 10)];
    customView.backgroundColor = COLOR(235, 235, 241, 1);
    
    return customView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==self.selectedIndex && section>0) {
        return 4;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return NavgationHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"WQProductSaleTypeCell";
    
    WQProductSaleTypeCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell=[[WQProductSaleTypeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.indexPath = indexPath;
    cell.proSaleVC = self;
    
    
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.textLabel.text =NSLocalizedString(@"salePriceName", @"");
            cell.detailTextLabel.text = [self.objectDic objectForKey:@"details"];
        }
    }else if (indexPath.section==2) {
        if (indexPath.row==0) {
            cell.textLabel.text =NSLocalizedString(@"saleDisCountName", @"");
        }
    }
    if (indexPath.row==1) {
        cell.textLabel.text =NSLocalizedString(@"saleStartTime", @"");
    }else if (indexPath.row==2) {
        cell.textLabel.text =NSLocalizedString(@"saleEndTime", @"");
    }else if (indexPath.row==3) {
        cell.textLabel.text =NSLocalizedString(@"productLimit", @"");
    }
    
    if ((indexPath.section-1) == [[self.objectDic objectForKey:@"type"] integerValue]) {
        if (indexPath.row==0) {
            cell.textField.text = [Utility checkString:[self.objectDic objectForKey:@"details"]]?[self.objectDic objectForKey:@"details"]:@"";
        }else if (indexPath.row==1) {
            cell.detailTextLabel.text = [Utility checkString:[self.objectDic objectForKey:@"start"]]?[self.objectDic objectForKey:@"start"]:@"";
        }else if (indexPath.row==2) {
            cell.detailTextLabel.text = [Utility checkString:[self.objectDic objectForKey:@"end"]]?[self.objectDic objectForKey:@"end"]:@"";
        }else if (indexPath.row==3) {
            cell.textField.text = [Utility checkString:[self.objectDic objectForKey:@"limit"]]?[self.objectDic objectForKey:@"limit"]:@"";
        }
    }
    return cell;
}
static WQProductSaleTypeCell *cellTemp;
static NSInteger indexTemp;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    
    cellTemp = (WQProductSaleTypeCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row==0) {
    }else if (indexPath.row==1){
        indexTemp = 1;
        [self.datePicker setMinimumDate:[NSDate date]];
        [self.datePicker setDate:[NSDate date]];
        if (self.endTime) {
            [self.datePicker setMaximumDate:self.endTime];
        }
        [self showDatePicker];
    }else if (indexPath.row==2) {
        indexTemp = 2;
        if (self.startTime) {
            [self.datePicker setMinimumDate:self.startTime];
        }
        [self showDatePicker];
    }
}
-(void)showDatePicker {
    [UIView animateWithDuration:0.25f animations:^{
        self.accessoryView.frame = (CGRect){0,self.view.height-NavgationHeight-216,self.view.width,NavgationHeight};
        self.datePicker.frame = (CGRect){0,self.accessoryView.bottom,self.view.width,216};
        self.tableView.frame = (CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-self.navBarView.height-10-NavgationHeight-216};
    }completion:^(BOOL finished) {
        [self scrollToIndex:cellTemp.indexPath animated:YES];
    }];
}
- (void)scrollToIndex:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:animated];
}
-(void)editDidTapPressedOption:(WQSwipTableHeader *)Header {
    WQProductSaleHeader *header = (WQProductSaleHeader *)Header;
    
    if (self.selectedIndex == header.aSection && self.selectedIndex != 0) {
        self.selectedIndex = 0;
    }else if (self.selectedIndex != header.aSection){
        self.selectedIndex = header.aSection;
    }
    
    [self.objectDic setObject:[NSNumber numberWithInteger:(self.selectedIndex-1)] forKey:@"type"];
    [self.objectDic setObject:@"" forKey:@"start"];
    [self.objectDic setObject:@"" forKey:@"end"];
    [self.objectDic setObject:@"" forKey:@"details"];
    
    self.startTime = nil;self.endTime = nil;
    [self.tableView reloadData];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[WQProductText class]]) {
        WQProductText *text = (WQProductText *)textField;
        
        [self scrollToIndex:text.idxPath animated:YES];
        
        [self hiddenDatePick];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[WQProductText class]]) {
        WQProductText *text = (WQProductText *)textField;
        
        if (text.idxPath.row==0) {
            [self.objectDic setObject:text.text forKey:@"details"];
        }else {
            [self.objectDic setObject:text.text forKey:@"limit"];
        }
        
    }
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame2 = self.tableView.frame;
                         frame2.size.height += self.keyboardHeight;
                         frame2.size.height -= keyboardRect.size.height;
                         self.tableView.frame = frame2;
                         
                         self.keyboardHeight = keyboardRect.size.height;
                     }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = self.tableView.frame;
                         frame.size.height += self.keyboardHeight;
                         frame.origin.x = 0;
                         self.tableView.frame = frame;
                         
                         self.keyboardHeight = 0;
                         
                     }];
}

@end
