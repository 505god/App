//
//  WQColorVC.m
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQColorVC.h"
#import "WQColorObj.h"



@interface WQColorVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;

@property (nonatomic, strong) NSMutableArray *dataArray;

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
    self.dataArray = nil;
    if ([WQDataShare sharedService].colorArray.count>0) {
        self.dataArray = [NSMutableArray arrayWithArray:[WQDataShare sharedService].colorArray];
        [self.table reloadData];
    }else {
        __weak typeof(self) wself = self;
        [[WQDataShare sharedService] getColorListCompleteBlock:^(BOOL finished) {
            wself.dataArray = [NSMutableArray arrayWithArray:[WQDataShare sharedService].colorArray];
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
    
    //筛选颜色是否选中
    if (self.isPresentVC) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(colorVC:didSelectColor:)]) {
            [self.delegate colorVC:self didSelectColor:self.selectedList];
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

#pragma mark - UITableViewDataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString * CellIdentifier = @"color_cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:CellIdentifier];
    }
    
    WQColorObj *color = (WQColorObj *)self.dataArray[indexPath.row];
    
    //判断选择颜色
    if (self.isPresentVC) {
        BOOL isExit = NO;
        for (int i=0; i<self.selectedList.count; i++) {
            WQColorObj *colorTemp = self.selectedList[i];
            
            if (color.colorId == colorTemp.colorId) {
                isExit = YES;
                break;
            }
        }
        
        cell.accessoryType = isExit?UITableViewCellAccessoryCheckmark:UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = color.colorName;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.isPresentVC) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        WQColorObj *color = (WQColorObj *)self.dataArray[indexPath.row];
        
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            
            for (int i=0; i<self.selectedList.count; i++) {
                WQColorObj *colorTemp = self.selectedList[i];
                
                if (color.colorId == colorTemp.colorId) {
                    [self.selectedList removeObject:colorTemp];
                    break;
                }
            }
            
        }else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            color.sizeArray = nil;
            color.productImg = nil;
            [self.selectedList addObject:color];
        }
    }
}
@end
