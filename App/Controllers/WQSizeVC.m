//
//  WQSizeVC.m
//  App
//
//  Created by 邱成西 on 15/2/12.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSizeVC.h"
#import "WQSizeObj.h"

@interface WQSizeVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation WQSizeVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"尺码";
    
    //导航栏设置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(addNewColor)];
    
    if ([WQDataShare sharedService].sizeArray.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:[WQDataShare sharedService].sizeArray];
//        for (int i=0; i<self.selectedList.count; i++) {
//            WQSizeObj *size = (WQSizeObj *)self.selectedList[i];
//            
//            NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"sizeId==%d", size.sizeId];
//            NSMutableArray  *filteredArray = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicateString]];
//            
//            NSInteger index = [self.dataArray indexOfObject:filteredArray[0]];
//            
//            [self.dataArray replaceObjectAtIndex:index withObject:size];
//        }
        
        [self.table reloadData];
    }else {
        __weak typeof(self) wself = self;
        [[WQDataShare sharedService] getSizeListCompleteBlock:^(BOOL finished) {
            wself.dataArray = [NSMutableArray arrayWithArray:[WQDataShare sharedService].sizeArray];
//            for (int i=0; i<self.selectedList.count; i++) {
//                WQSizeObj *size = (WQSizeObj *)self.selectedList[i];
//                
//                NSPredicate *predicateString = [NSPredicate predicateWithFormat:@"sizeId==%d", size.sizeId];
//                NSMutableArray  *filteredArray = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicateString]];
//                
//                NSInteger index = [self.dataArray indexOfObject:filteredArray[0]];
//                
//                [self.dataArray replaceObjectAtIndex:index withObject:size];
//            }
            [wself.table reloadData];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //筛选尺码是否选中
    if (self.isPresentVC) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sizeVC:didSelectSize:)]) {
            [self.delegate sizeVC:self didSelectSize:self.selectedList];
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
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"添加尺码" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:buttonIndex animated:YES];
    }else if (buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        
        if (![Utility checkString:textField.text]) {
            [Utility errorAlert:@"抱歉，尺码名称不能为空" view:self.view];
        }else {
            NSDictionary *aDic = @{@"sizeId":@5,@"sizeName":textField.text,@"sizeNumber":@0};
            WQSizeObj *size= [WQSizeObj returnSizeWithDic:aDic];
            [self.dataArray addObject:size];
            [self.table reloadData];
        }
        //TODO:上传后台
        
    }
}


#pragma mark - property

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}
#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = @"size_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                  reuseIdentifier:CellIdentifier];
    }
    
    WQSizeObj *size = (WQSizeObj *)self.dataArray[indexPath.row];
    
    //判断选择颜色
    if (self.isPresentVC) {
        BOOL isExit = NO;
        for (int i=0; i<self.selectedList.count; i++) {
            WQSizeObj *sizeTemp = self.selectedList[i];
            
            if (size.sizeId == sizeTemp.sizeId) {
                isExit = YES;
                break;
            }
        }
        
        cell.accessoryType = isExit?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = size.sizeName;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isPresentVC) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        WQSizeObj *size = (WQSizeObj *)self.dataArray[indexPath.row];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            for (int i=0; i<self.selectedList.count; i++) {
                 WQSizeObj *sizeTemp = self.selectedList[i];
                
                if (size.sizeId == sizeTemp.sizeId) {
                    [self.selectedList removeObject:sizeTemp];
                    break;
                }
            }
        }else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            size.stockCount = 0;
            [self.selectedList addObject:size];
        }
    }
}

@end
