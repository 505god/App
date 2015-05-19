//
//  WQLeftBarView.m
//  App
//
//  Created by 邱成西 on 15/3/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQLeftBarView.h"

#define ItemWidth 60

@implementation WQLeftBarView

-(void)dealloc {
    SafeRelease(_shopItem);
    SafeRelease(_orderItem);
    SafeRelease(_customerItem);
    SafeRelease(_saleItem);
    SafeRelease(_leftDelegate);
}

-(void)defaultSelected{
    [self unSelectedAllItems];
}

-(void)unSelectedAllItems{
    self.shopItem.isSelected = NO;
    self.orderItem.isSelected = NO;
    self.customerItem.isSelected = NO;
    self.saleItem.isSelected = NO;
}

-(void)whiteViewSelected {
    [self.shopItem.whiteView setHidden:NO];
    [self.orderItem.whiteView setHidden:NO];
    [self.customerItem.whiteView setHidden:NO];
}

- (IBAction)shopItemClicked:(id)sender {
    [self unSelectedAllItems];
    [self whiteViewSelected];
    self.shopItem.isSelected = YES;
    if (self.leftDelegate && [self.leftDelegate respondsToSelector:@selector(leftTabBar:selectedItem:)]) {
        [self.leftDelegate leftTabBar:self selectedItem:LeftTabBarItemType_shop];
    }
}
- (IBAction)orderItemClicked:(id)sender {
    [self unSelectedAllItems];
    [self whiteViewSelected];
    self.orderItem.isSelected = YES;
    [self.shopItem.whiteView setHidden:YES];
    if (self.leftDelegate && [self.leftDelegate respondsToSelector:@selector(leftTabBar:selectedItem:)]) {
        [self.leftDelegate leftTabBar:self selectedItem:LeftTabBarItemType_order];
    }
}
- (IBAction)customerItemClicked:(id)sender {
    [self unSelectedAllItems];
    [self whiteViewSelected];
    self.customerItem.isSelected = YES;
    [self.orderItem.whiteView setHidden:YES];
    if (self.leftDelegate && [self.leftDelegate respondsToSelector:@selector(leftTabBar:selectedItem:)]) {
        [self.leftDelegate leftTabBar:self selectedItem:LeftTabBarItemType_customer];
    }
}
- (IBAction)saleItemClicked:(id)sender {
    [self unSelectedAllItems];
    [self whiteViewSelected];
    self.saleItem.isSelected = YES;
    [self.customerItem.whiteView setHidden:YES];
    if (self.leftDelegate && [self.leftDelegate respondsToSelector:@selector(leftTabBar:selectedItem:)]) {
        [self.leftDelegate leftTabBar:self selectedItem:LeftTabBarItemType_sale];
    }
}

-(void)awakeFromNib {
    [super awakeFromNib];
    self.frame = (CGRect){0,0,60,[UIScreen mainScreen].bounds.size.height};
    
    self.shopItem.frame = (CGRect){0,0,ItemWidth,self.height/4};
    self.orderItem.frame = (CGRect){0,self.shopItem.bottom,ItemWidth,self.height/4};
    self.customerItem.frame = (CGRect){0,self.orderItem.bottom,ItemWidth,self.height/4};
    self.saleItem.frame = (CGRect){0,self.customerItem.bottom,ItemWidth,self.height/4};
}

-(void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    
    [self defaultSelected];
    
    switch (currentPage) {
        case 0:
            self.shopItem.isSelected = YES;
            break;
        case 1:
            self.orderItem.isSelected = YES;
            break;
        case 2:
            self.customerItem.isSelected = YES;
            break;
        case 3:
            self.saleItem.isSelected = YES;
            break;
            
        default:
            break;
    }
}
@end
