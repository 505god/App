//
//  WQSubVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSubVC.h"

#import "WQCustomerVC.h"
#import "WQCustomBtn.h"

@interface WQSubVC ()

@property (nonatomic, weak) IBOutlet WQCustomBtn *infoBtn;
@property (nonatomic, weak) IBOutlet WQCustomBtn *messageBtn;

@end

@implementation WQSubVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.infoBtn.index = self.idxPath;
    [self.infoBtn addTarget:self.customerVC action:@selector(subViewInfoBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.messageBtn.index = self.idxPath;
    [self.messageBtn addTarget:self.customerVC action:@selector(subViewMessageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
