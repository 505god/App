//
//  WQPhoneVC.h
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "BaseViewController.h"
#import "SectionsViewController.h"

@interface WQPhoneVC : BaseViewController<SecondViewControllerDelegate,UITextFieldDelegate>

@property(nonatomic,strong) UITableView* tableView;
@property(nonatomic,strong) UITextField* areaCodeField;
@property(nonatomic,strong) UITextField* telField;

-(void)nextStep;
@end
