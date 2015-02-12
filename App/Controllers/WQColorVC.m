//
//  WQColorVC.m
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQColorVC.h"
#import "WQColorObj.h"

#import "WQColorCell.h"

#import "JKUtil.h"

@interface WQColorVC ()<WQColorCellDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) NSMutableArray *tempArray;
@end

@implementation WQColorVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"颜色";
    
    //导航栏设置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(addNewColor)];
    
    //TODO:获取颜色列表
    NSDictionary *aDic = [Utility returnDicByPath:@"ColorList"];
    NSArray *array = [aDic objectForKey:@"colorList"];
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *aDic = (NSDictionary *)obj;
            WQColorObj *color = [WQColorObj returnColorWithDic:aDic];
            [wself.dataArray addObject:color];
            SafeRelease(color);
            SafeRelease(aDic);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.table reloadData];
        });
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.tempArray = [NSMutableArray arrayWithArray:self.selectedList];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //筛选颜色是否选中
    if (self.isPresentVC) {
        
        if(self.tempArray.count>0){
            NSMutableArray *tempAttay = [NSMutableArray array];
            for (int i=0; i<self.selectedList.count; i++) {
                WQColorObj *color = (WQColorObj *)self.selectedList[i];
                
                NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"colorId==%d", color.colorId];
                NSMutableArray  *filteredArray = [NSMutableArray arrayWithArray:[self.tempArray filteredArrayUsingPredicate:predicateString]];
                if (filteredArray.count>0) {//已包含
                    [tempAttay addObject:color];
                    [self.tempArray removeObjectsInArray:filteredArray];
                }
                SafeRelease(filteredArray);
            }
            
            self.selectedList = nil;
            self.selectedList = [NSMutableArray arrayWithArray:self.tempArray];
            [self.selectedList addObjectsFromArray:tempAttay];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(colorVC:didSelectColor:)]) {
                [self.delegate colorVC:self didSelectColor:self.selectedList];
            }
            SafeRelease(tempAttay);
        }else {
            self.selectedList = nil;
            if (self.delegate && [self.delegate respondsToSelector:@selector(colorVC:didSelectColor:)]) {
                [self.delegate colorVC:self didSelectColor:self.selectedList];
            }
        }
        
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNewColor {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加颜色" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        if (![Utility checkString:textField.text]) {
            [Utility errorAlert:@"抱歉，颜色名称不能为空" view:self.view];
        }else {
            NSDictionary *aDic = @{@"colorId":@5,@"colorName":textField.text,@"colorNumber":@0};
            WQColorObj *color = [WQColorObj returnColorWithDic:aDic];
            [self.dataArray addObject:color];
            [self.table reloadData];
        }
        //TODO:上传后台
        
    }
}
-(void)willPresentAlertView:(UIAlertView *)alertView {
    alertView.cancelButtonIndex = 0;
}


#pragma mark - property

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(NSMutableArray *)tempArray {
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}
#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = @"color_cell";
    
    WQColorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[WQColorCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    WQColorObj *color = (WQColorObj *)self.dataArray[indexPath.row];
    
    
    cell.delegate = self;
    
    //判断选择颜色
    if (self.isPresentVC) {
        [cell.checkButton setHidden:NO];
        
        BOOL isExit = NO;
        for (int i=0; i<self.tempArray.count; i++) {
            WQColorObj *colorTemp = (WQColorObj *)self.tempArray[i];
            if (colorTemp.colorId==color.colorId) {
                isExit = YES;
                [cell setColorObj:colorTemp];
                break;
            }
        }
        [cell setIsSelected:isExit];
        if (!isExit) {
            [cell setColorObj:color];
        }
    }
    
    return cell;
}

#pragma mark - WQColorCellDelegate
//选择颜色
-(void)selectedColor:(WQColorObj *)colorObj animated:(BOOL)animated {
    if (animated) {
        [self.tempArray addObject:colorObj];
    }else {
        [self.tempArray removeObject:colorObj];
    }
}
@end
