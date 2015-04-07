//
//  WQOrderVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQOrderVC.h"

@interface WQOrderVC ()

@end

@implementation WQOrderVC

-(void)dealloc {
    [self.view removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.title = NSLocalizedString(@"OrderVC", @"");
    
    //KVO监测view的frame变化
    [self.view addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:Nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self updateSubViews];
}
-(void)updateSubViews {
    
}

@end
