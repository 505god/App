//
//  XLCycleScrollView.h
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StyledPageControl.h"

@protocol XLCycleScrollViewDelegate;
@protocol XLCycleScrollViewDatasource;

@interface XLCycleScrollView : UIView<UIScrollViewDelegate>
{
    NSInteger _totalPages;
}

@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) StyledPageControl *pageControl;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) NSMutableArray *curViews;

@property (nonatomic, assign, setter = setDataource:) id<XLCycleScrollViewDatasource> datasource;
@property (nonatomic, assign, setter = setDelegate:) id<XLCycleScrollViewDelegate> delegate;

- (void)reloadData;
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index;
- (id)initWithFrame:(CGRect)frame isTop:(BOOL)isTop;

@end

@protocol XLCycleScrollViewDelegate <NSObject>
@optional
-(void)scrollAtPage:(NSInteger)page;
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index;
@end

@protocol XLCycleScrollViewDatasource <NSObject>

@required
- (NSInteger)numberOfPages;
- (UIView *)pageAtIndex:(NSInteger)index;

@end
