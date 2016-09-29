//
//  WQCustomerTable.h
//  App
//
//  Created by 邱成西 on 15/2/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQCustomerTableDelegate;

@interface WQCustomerTable : UIView

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, assign) id<WQCustomerTableDelegate> delegate;

- (void)reloadData;

-(void)setHeaderAnimated:(BOOL)animated;
@end

@protocol WQCustomerTableDelegate <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

- (NSArray *)sectionIndexTitlesForWQCustomerTable:(WQCustomerTable *)tableView;

@end