//
//  WQCustomerVC.h
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"

#import "UIFolderTableView.h"

@class WQCustomBtn;

@interface WQCustomerVC : BaseViewController<UITableViewDataSource, UITableViewDelegate,UIFolderTableViewDelegate>

@property (strong, nonatomic) IBOutlet UIFolderTableView *tableView;


//查看个人信息
-(void)subViewInfoBtnAction:(WQCustomBtn *)sender;
//进入往来记录
-(void)subViewMessageBtnAction:(WQCustomBtn *)sender;
@end
