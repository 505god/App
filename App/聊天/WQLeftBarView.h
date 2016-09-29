//
//  WQLeftBarView.h
//  App
//
//  Created by 邱成西 on 15/3/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WQLeftBarItem.h"

//左侧按钮类型
typedef enum{
    LeftTabBarItemType_shop=0,
    LeftTabBarItemType_order,
    LeftTabBarItemType_customer,
    LeftTabBarItemType_sale
}LeftTabBarItemType;

@protocol WQLeftBarViewDelegate;

@interface WQLeftBarView : UIControl
//店铺
@property (nonatomic, weak) IBOutlet WQLeftBarItem *shopItem;
//订单
@property (nonatomic, weak) IBOutlet WQLeftBarItem *orderItem;
//客户
@property (nonatomic, weak) IBOutlet WQLeftBarItem *customerItem;
//销售统计
@property (nonatomic, weak) IBOutlet WQLeftBarItem *saleItem;

@property (nonatomic, assign) id<WQLeftBarViewDelegate>leftDelegate;

@property (nonatomic, assign) NSInteger currentPage;

//取消所有选中
-(void)defaultSelected;

- (IBAction)shopItemClicked:(id)sender;
- (IBAction)orderItemClicked:(id)sender;
- (IBAction)customerItemClicked:(id)sender;
- (IBAction)saleItemClicked:(id)sender;
@end

@protocol WQLeftBarViewDelegate <NSObject>

-(void)leftTabBar:(WQLeftBarView*)tabBarView selectedItem:(LeftTabBarItemType)itemType;
@end