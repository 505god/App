//
//  WQMessageVC.m
//  App
//
//  Created by 邱成西 on 15/5/5.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMessageVC.h"

#import "WQInputFunctionView.h"
#import "WQMessageCell.h"
#import "WQMessageFrame.h"
#import "WQMessageObj.h"

@interface WQMessageVC ()<WQNavBarViewDelegate,WQInputFunctionViewDelegate,WQMessageCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WQInputFunctionView *inputView;

@end

@implementation WQMessageVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"CustomerNew", @"")];
    [self.navBarView.rightBtn setHidden:YES];
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self.view addSubview:self.inputView];
    [self.view addSubview:self.tableView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - property

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(WQInputFunctionView *)inputView {
    if (!_inputView) {
        _inputView = [[WQInputFunctionView alloc]initWithSuperVC:self];
        _inputView.delegate = self;
    }
    return _inputView;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height-self.inputView.height} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

#pragma mark - keyboard

-(void)keyboardChange:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
//    //adjust ChatTableView's height
//    if (notification.name == UIKeyboardWillShowNotification) {
//        self.bottomConstraint.constant = keyboardEndFrame.size.height+40;
//    }else{
//        self.bottomConstraint.constant = 40;
//    }
//    
//    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    CGRect newFrame = self.inputView.frame;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height;
    self.inputView.frame = newFrame;
    
    [UIView commitAnimations];
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom {
    if (self.dataArray.count==0)
        return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - tableView delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WQMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCellID"];
    if (cell == nil) {
        cell = [[WQMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellID"];
        cell.delegate = self;
    }
    [cell setMessageFrame:self.dataArray[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.dataArray[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
