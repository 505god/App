//
//  XLCycleScrollView.m
//  CycleScrollViewDemo
//
//  Created by xie liang on 9/14/12.
//  Copyright (c) 2012 xie liang. All rights reserved.
//

#import "XLCycleScrollView.h"

@implementation XLCycleScrollView

-(void)awakeFromNib {
    self.scrollView= [[UIScrollView alloc] initWithFrame:self.frame];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(self.frame.size.width * 3, self.frame.size.height);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = YES;
    [self addSubview:self.scrollView];

    CGRect pageFrame;
    pageFrame = (CGRect){self.frame.size.width-100,self.frame.size.height-20,100,20};

    StyledPageControl *page = [[StyledPageControl alloc] initWithFrame:pageFrame];
    self.pageControl = page;
    self.pageControl.userInteractionEnabled = NO;
    [self.pageControl setCoreNormalColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
    [self.pageControl setCoreSelectedColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self addSubview:self.pageControl];
    SafeRelease(page);

    _curPage = 0;
}
- (id)initWithFrame:(CGRect)frame isTop:(BOOL)isTop
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollView= [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.clipsToBounds = YES;
        [self addSubview:self.scrollView];

        CGRect rect = self.bounds;
        CGRect pageFrame;
        if (isTop) {
            pageFrame = (CGRect){0,0,rect.size.width,20};
        }else {
            pageFrame = (CGRect){0,rect.size.height-20,rect.size.width,20};
        }

        StyledPageControl *page = [[StyledPageControl alloc] initWithFrame:pageFrame];
        self.pageControl = page;
        self.pageControl.userInteractionEnabled = NO;
        [self.pageControl setCoreNormalColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        [self.pageControl setCoreSelectedColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        [self addSubview:self.pageControl];
        SafeRelease(page);
        
        _curPage = 0;
    }
    return self;
}

- (void)setDataource:(id<XLCycleScrollViewDatasource>)datasource
{
    _datasource = datasource;
    if (_datasource == nil) {
        return;
    }
    [self reloadData];
}

- (void)reloadData
{
    _totalPages = [_datasource numberOfPages];
    if (_totalPages == 0) {
        return;
    }
    self.pageControl.numberOfPages = _totalPages;
    [self loadData];
}

- (void)loadData
{
    self.pageControl.currentPage = _curPage;
    //从scrollView上移除所有的subview
    NSArray *subViews = [self.scrollView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:_curPage];
    
    for (int i = 0; i < 3; i++) {
        UIView *v = [self.curViews objectAtIndex:i];
        v.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [v addGestureRecognizer:singleTap];
        singleTap = nil;

        v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
        [self.scrollView addSubview:v];
    }
    [self.scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}
- (void)handleTap:(UITapGestureRecognizer *)tap {

    if ([self.delegate respondsToSelector:@selector(didClickPage:atIndex:)]) {
        [self.delegate didClickPage:self atIndex:_curPage];
    }
}
- (void)getDisplayImagesWithCurpage:(int)page {
    
    int pre = [self validPageValue:_curPage-1];
    int last = [self validPageValue:_curPage+1];
    
    if (!self.curViews) {
        self.curViews  = [[NSMutableArray alloc] init];
    }
    
    [self.curViews removeAllObjects];
    
    [self.curViews addObject:[self.datasource pageAtIndex:pre]];
    [self.curViews addObject:[self.datasource pageAtIndex:page]];
    [self.curViews addObject:[self.datasource pageAtIndex:last]];
}

- (int)validPageValue:(NSInteger)value {
    
    if(value == -1) value = _totalPages - 1;
    if(value == _totalPages) value = 0;
    return value;
}
- (void)setViewContent:(UIView *)view atIndex:(NSInteger)index
{
    if (index == _curPage) {
        [self.curViews replaceObjectAtIndex:1 withObject:view];
        for (int i = 0; i < 3; i++) {
            UIView *v = [self.curViews objectAtIndex:i];
            v.frame = CGRectOffset(v.frame, v.frame.size.width * i, 0);
            [self.scrollView addSubview:v];
        }
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    int x = aScrollView.contentOffset.x;
    
    //往下翻一张
    if(x >= (2*self.frame.size.width)) {
        _curPage = [self validPageValue:_curPage+1];
        [self loadData];
    }
    
    //往上翻
    if(x <= 0) {
        _curPage = [self validPageValue:_curPage-1];
        [self loadData];
    }
    
    if ([_delegate respondsToSelector:@selector(scrollAtPage:)]) {
        [_delegate scrollAtPage:_curPage];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:YES];
    
}


-(void)setCurPage:(NSInteger)curPage
{
    _curPage = curPage;
    [self loadData];
}
@end
