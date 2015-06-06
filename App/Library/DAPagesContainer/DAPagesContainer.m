//
//  DAPageContainerScrollView.m
//  DAPagesContainerScrollView
//
//  Created by Daria Kopaliani on 5/29/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAPagesContainer.h"

#import "DAPagesContainerTopBar.h"
#import "DAPageIndicatorView.h"

#include "stdlib.h"

@interface DAPagesContainer () <DAPagesContainerTopBarDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) DAPagesContainerTopBar *topBar;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (weak,   nonatomic) UIScrollView *observingScrollView;
@property (strong, nonatomic) DAPageIndicatorView *pageIndicatorView;

@property (assign, nonatomic) BOOL shouldObserveContentOffset;

- (void)layoutSubviews;
- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView;
- (void)stopObservingContentOffset;

@end


@implementation DAPagesContainer

#pragma mark - Initialization

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [self stopObservingContentOffset];
    
    SafeRelease(_viewControllers);
    SafeRelease(_topBar);
    SafeRelease(_scrollView.delegate);
    SafeRelease(_scrollView);
    SafeRelease(_pageIndicatorView);
    
    [self.view removeObserver:self forKeyPath:@"frame"];
}

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shouldObserveContentOffset = YES;
    
    //标题栏
    self.topBar = [[DAPagesContainerTopBar alloc] initWithFrame:CGRectMake(0.,0.,self.view.width,NavgationHeight)];
    self.topBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.topBar.delegate = self;
    [self.view addSubview:self.topBar];
    
    //scrollview
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.,NavgationHeight+10,self.view.width,self.view.height - NavgationHeight-10)];
    self.scrollView.autoresizingMask =  UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
    
    //提示 (8,6)
    self.pageIndicatorView = [[DAPageIndicatorView alloc] initWithFrame:CGRectMake(0.,NavgationHeight-12,8,6)];
    [self.view insertSubview:self.pageIndicatorView aboveSubview:self.topBar];
    
    //KVO监测scrollView的contentOffset变化
    [self startObservingContentOffsetForScrollView:self.scrollView];
    [self.view addObserver:self forKeyPath:@"frame" options:0 context:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Public

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    UIButton *previosSelectdItem = self.topBar.itemViews[self.selectedIndex];
    UIButton *nextSelectdItem = self.topBar.itemViews[selectedIndex];
    
    if (abs(self.selectedIndex - selectedIndex) <= 1) {
        [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollView.width, 0.)animated:YES];
        UIViewController *leftViewController = self.viewControllers[self.selectedIndex];
        if (selectedIndex == self.selectedIndex) {
            [leftViewController viewWillAppear:YES];
        }else {
            [leftViewController viewWillDisappear:YES];
            
            UIViewController *rightViewController = self.viewControllers[selectedIndex];
            rightViewController.view.frame = (CGRect){self.scrollView.width*selectedIndex,0,self.scrollView.width,self.scrollView.height};
            [rightViewController viewWillAppear:YES];
        }
        
        [UIView animateWithDuration:(animated) ? 0.25 : 0. delay:0. options:UIViewAnimationOptionBeginFromCurrentState animations:^{
             [previosSelectdItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
             [nextSelectdItem setTitleColor:COLOR(251, 0, 41, 1) forState:UIControlStateNormal];
         } completion:nil];
    } else {
        self.shouldObserveContentOffset = NO;
        BOOL scrollingRight = (selectedIndex > self.selectedIndex);
        UIViewController *leftViewController = self.viewControllers[MIN(self.selectedIndex, selectedIndex)];
        UIViewController *rightViewController = self.viewControllers[MAX(self.selectedIndex, selectedIndex)];
        
        leftViewController.view.frame = CGRectMake(0., 0., self.scrollView.width, self.scrollView.height);
        
        rightViewController.view.frame = CGRectMake(self.scrollView.width, 0., self.scrollView.width, self.scrollView.height);
        
        self.scrollView.contentSize = CGSizeMake(2 * self.scrollView.width, self.scrollView.height);
        
        CGPoint targetOffset;
        if (scrollingRight) {
            self.scrollView.contentOffset = CGPointZero;
            targetOffset = CGPointMake(self.scrollView.width, 0.);
            [leftViewController viewWillDisappear:YES];
            [rightViewController viewWillAppear:YES];
        } else {
            self.scrollView.contentOffset = CGPointMake(self.scrollView.width, 0.);
            targetOffset = CGPointZero;
            [leftViewController viewWillAppear:YES];
            [rightViewController viewWillDisappear:YES];
        }
        [self.scrollView setContentOffset:targetOffset animated:YES];
        [UIView animateWithDuration:0. delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [previosSelectdItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [nextSelectdItem setTitleColor:COLOR(251, 0, 41, 1) forState:UIControlStateNormal];
        } completion:^(BOOL finished) {
            for (NSUInteger i = 0; i < self.viewControllers.count; i++) {
                UIViewController *viewController = self.viewControllers[i];
                viewController.view.frame = CGRectMake(i * self.scrollView.width, 0., self.scrollView.width, self.scrollView.height);
                [self.scrollView addSubview:viewController.view];
            }
            self.scrollView.contentSize = CGSizeMake(self.scrollView.width * self.viewControllers.count, self.scrollView.height);
            [self.scrollView setContentOffset:CGPointMake(selectedIndex * self.scrollView.width, 0.) animated:YES];
            self.scrollView.userInteractionEnabled = YES;
            self.shouldObserveContentOffset = YES;
        }];
    }
    _selectedIndex = selectedIndex;
}

#pragma mark * Overwritten setters

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:YES];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers != viewControllers) {
        _viewControllers = viewControllers;
        self.topBar.itemTitles = [viewControllers valueForKey:@"title"];
        
        for (UIViewController *viewController in viewControllers) {
            [viewController willMoveToParentViewController:self];
            viewController.view.frame = CGRectMake(0., 0., self.scrollView.width, self.scrollView.height);
            [self.scrollView addSubview:viewController.view];
            [viewController didMoveToParentViewController:self];
        }
        [self layoutSubviews];
        self.selectedIndex = 0;
        self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,self.pageIndicatorView.center.y);
    }
}

#pragma mark - Private

- (void)layoutSubviews {
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width*self.viewControllers.count, self.scrollView.height);
    [self.scrollView setContentOffset:CGPointMake(self.selectedIndex * self.scrollView.width, 0.)];
    
    CGFloat x = 0.;
    for (UIViewController *viewController in self.viewControllers) {
        viewController.view.frame = CGRectMake(x, 0, self.scrollView.width, self.scrollView.height);
        x += self.scrollView.width;
    }
    
    self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,self.pageIndicatorView.center.y);
    
    self.scrollView.userInteractionEnabled = YES;
}

-(void)layoutIndicator {
    [self setSelectedIndex:self.selectedIndex animated:YES];
}
- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView {
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    self.observingScrollView = scrollView;
}

- (void)stopObservingContentOffset
{
    if (self.observingScrollView) {
        [self.observingScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.observingScrollView = nil;
    }
}

#pragma mark - DAPagesContainerTopBar delegate

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(DAPagesContainerTopBar *)bar {
    [self setSelectedIndex:index animated:YES];
    
    self.pageIndicatorView.center = CGPointMake([self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x,self.pageIndicatorView.center.y);
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.selectedIndex = scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.frame);
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        self.scrollView.userInteractionEnabled = YES;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.scrollView.userInteractionEnabled = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollView.userInteractionEnabled = NO;
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"containerWillBeginDragging" object:nil];
}
#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"frame"]) {
        [self layoutSubviews];
    }else {
        if (self.scrollView.contentOffset.x < 0) {//左
            [[NSNotificationCenter defaultCenter]postNotificationName:@"showSidebarView" object:@"0"];
        }else if (self.scrollView.contentOffset.x > self.scrollView.width*(self.viewControllers.count-1)){//右
            [[NSNotificationCenter defaultCenter]postNotificationName:@"showSidebarView" object:@"1"];
        }else {
            CGFloat oldX = self.selectedIndex * self.scrollView.width;
            if (oldX != self.scrollView.contentOffset.x && self.shouldObserveContentOffset) {
                BOOL scrollingTowards = (self.scrollView.contentOffset.x > oldX);
                NSInteger targetIndex = (scrollingTowards) ? self.selectedIndex + 1 : self.selectedIndex - 1;
                if (targetIndex >= 0 && targetIndex < self.viewControllers.count) {
                    CGFloat ratio = (self.scrollView.contentOffset.x - oldX) / self.scrollView.width;
                    CGFloat previousItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:self.selectedIndex].x;
                    CGFloat nextItemPageIndicatorX = [self.topBar centerForSelectedItemAtIndex:targetIndex].x;
                    UIButton *previosSelectedItem = self.topBar.itemViews[self.selectedIndex];
                    UIButton *nextSelectedItem = self.topBar.itemViews[targetIndex];
                    [previosSelectedItem setTitleColor:COLOR(251, 0, 41, 1) forState:UIControlStateNormal];
                    [nextSelectedItem setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    if (scrollingTowards) {
                        self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX +(nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,self.pageIndicatorView.center.y);
                        
                    } else {
                        self.pageIndicatorView.center = CGPointMake(previousItemPageIndicatorX - (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio,self.pageIndicatorView.center.y);
                    }
                }
            }
        }
    }
}

@end