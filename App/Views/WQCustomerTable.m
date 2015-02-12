//
//  WQCustomerTable.m
//  App
//
//  Created by 邱成西 on 15/2/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerTable.h"

#import "WQCustomerTableIndex.h"

@interface WQCustomerTable ()<WQCustomerTableIndexDelegate>

@property (nonatomic, strong) UILabel *flotageLabel;
@property (nonatomic, strong) WQCustomerTableIndex *tableViewIndex;

@end

@implementation WQCustomerTable

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        self.tableView.showsVerticalScrollIndicator = NO;
        [self addSubview:self.tableView];
        
        self.searchBar = [[UISearchBar alloc] init];
        self.searchBar.placeholder = @"搜索";
        [self.searchBar sizeToFit];
        self.tableView.tableHeaderView = self.searchBar;
        
        self.tableViewIndex = [[WQCustomerTableIndex alloc] initWithFrame:(CGRect){[UIScreen mainScreen].bounds.size.width-20,0,20,frame.size.height}];
        [self addSubview:self.tableViewIndex];
        
        self.flotageLabel = [[UILabel alloc] initWithFrame:(CGRect){(self.bounds.size.width - 64 ) / 2,(self.bounds.size.height - 64) / 2,64,64}];
        self.flotageLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"flotageBackgroud"]];
        self.flotageLabel.hidden = YES;
        self.flotageLabel.textAlignment = NSTextAlignmentCenter;
        self.flotageLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.flotageLabel];
    }
    return self;
}

- (void)setDelegate:(id<WQCustomerTableDelegate>)delegate {
    _delegate = delegate;
    self.tableView.delegate = delegate;
    self.tableView.dataSource = delegate;
    self.searchBar.delegate = delegate;
    self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForWQCustomerTable:self];
    CGRect rect = self.tableViewIndex.frame;
    rect.size.height = self.tableViewIndex.indexes.count * 16;
    rect.origin.y = (self.bounds.size.height - rect.size.height) / 2;
    self.tableViewIndex.frame = rect;
    
    self.tableViewIndex.tableViewIndexDelegate = self;
}

- (void)reloadData
{
    [self.tableView reloadData];
    
    UIEdgeInsets edgeInsets = self.tableView.contentInset;
    
    self.tableViewIndex.indexes = [self.delegate sectionIndexTitlesForWQCustomerTable:self];
    CGRect rect = self.tableViewIndex.frame;
    rect.size.height = self.tableViewIndex.indexes.count * 16;
    rect.origin.y = (self.bounds.size.height - rect.size.height - edgeInsets.top - edgeInsets.bottom) / 2 + edgeInsets.top + 20;
    self.tableViewIndex.frame = rect;
    self.tableViewIndex.tableViewIndexDelegate = self;
}

#pragma mark -
- (void)tableViewIndex:(WQCustomerTableIndex *)tableViewIndex didSelectSectionAtIndex:(NSInteger)index withTitle:(NSString *)title {
    if ([self.tableView numberOfSections] > index && index > -1){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:NO];
        self.flotageLabel.text = title;
    }
}

- (void)tableViewIndexTouchesBegan:(WQCustomerTableIndex *)tableViewIndex {
    self.flotageLabel.hidden = NO;
}

- (void)tableViewIndexTouchesEnd:(WQCustomerTableIndex *)tableViewIndex {
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.4;
    [self.flotageLabel.layer addAnimation:animation forKey:nil];
    
    self.flotageLabel.hidden = YES;
}

- (NSArray *)tableViewIndexTitle:(WQCustomerTableIndex *)tableViewIndex {
    return [self.delegate sectionIndexTitlesForWQCustomerTable:self];
}

@end
