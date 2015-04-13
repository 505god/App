//
//  WQProImgView.m
//  App
//
//  Created by 邱成西 on 15/4/8.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProImgView.h"
#import "WQProImgItem.h"

#define defaultWidth  60      // 每一个ProImgItem的默认宽度
#define defaultPace   6       // ProImgItem之间的间距
#define duration      0.25     // 动画执行时间
#define defaultVisibleCount 4 //默认显示的ProImgItem的个数

@interface WQProImgView ()<WQProImgItemDelefate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray *itemList;

///默认的item  添加按钮
@property (nonatomic, strong) WQProImgItem *defaultItem;
///判断是否有删除操作
@property (nonatomic, assign) BOOL hasDelete;
///判断删除操作item的移动方向
@property (nonatomic, assign) BOOL frontMove;
///统计删除操作总共移动的次数
@property (nonatomic, assign) NSInteger  moveCount;
@end

@implementation WQProImgView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setProperty];
    }
    return self;
}

- (void) setProperty {
    self.itemList = [[NSMutableArray alloc] init];
    self.hasDelete = NO;
    self.moveCount = 0;
    
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.delegate = self;
    self.scrollView.frame = CGRectMake(0, (self.height - defaultWidth)/2.0, self.width, defaultWidth);
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.scrollEnabled = YES;
    self.scrollView.directionalLockEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = YES;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    self.scrollView.contentSize = [self contentSizeForUIScrollView:0];
    [self addSubview:self.scrollView];
    
    self.defaultItem = [[WQProImgItem alloc] initWithFrame:CGRectMake(defaultPace, 0, defaultWidth, defaultWidth) andImage:[UIImage imageNamed:@"CheckmarkGreen"]];
    [self.scrollView addSubview:self.defaultItem];
    [self scrollViewAbleScroll];
}

///根据index获取UIScrollView的ContentSize
- (CGSize)contentSizeForUIScrollView:(int)index {
    float width = (defaultPace + defaultWidth) * index;
    if (width < self.scrollView.width)
        width = self.scrollView.width;
    return CGSizeMake(width, defaultWidth);
}

- (void)scrollViewAbleScroll {
    self.scrollView.contentSize = [self contentSizeForUIScrollView:(self.itemList.count + 1)];
    [self.scrollView scrollRectToVisible:CGRectMake(self.scrollView.contentSize.width - defaultWidth, 0, defaultWidth, self.frame.size.height) animated:YES];
}

///新增一个ProItem
- (void)addNewProItem:(UIImage *)proImg {
    __block WQProImgItem *newItem;
    
    CGFloat x = (self.itemList.count) * (defaultPace + defaultWidth) + defaultPace;
    newItem = [[WQProImgItem alloc] initWithFrame:CGRectMake(x, 0, defaultWidth, defaultWidth) andImage:proImg];
    newItem.alpha = 0.1;
    newItem.delegate = self;
    [self.itemList addObject:newItem];
    [self.scrollView addSubview:newItem];
    [self scrollViewAbleScroll];
    self.defaultItem.alpha = 0.5;
    
    [UIView animateWithDuration:duration animations:^(){
        CGRect rect = self.defaultItem.frame;
        rect.origin.x += (defaultPace + defaultWidth);
        self.defaultItem.frame = rect;
        self.defaultItem.alpha = 1.0;
        newItem.alpha = 0.8;
        
    } completion:^(BOOL finished){
        newItem.alpha = 1.0;
    }];

}

#pragma mark - WQProImgItemDelefate

-(void)deleteProItem:(WQProImgItem *)proItem {
    self.hasDelete = YES;
    int index = (int)[self.itemList indexOfObject:proItem];
    
    // step_1: 设置相关proItem的透明度
    proItem.alpha = 0.8;
    
    // 判断其余proItem的移动方向（从前向后移动/从后向前移动）
    self.frontMove = NO;
    if (self.itemList.count - 1 > defaultVisibleCount
        && (self.itemList.count - index - 1) <= defaultVisibleCount) {
        self.frontMove = YES;
    }
    if (index == self.itemList.count - 1 && !self.frontMove)
        self.defaultItem.alpha = 0.5;
    
    [UIView animateWithDuration:duration animations:^(){
        
        // step_2: 其余proItem依次移动
        if (self.frontMove){
            // 前面的向后移动
            for (int i = 0; i < index; i++) {
                WQProImgItem *item = [self.itemList objectAtIndex:(NSUInteger)i];
                CGRect rect = item.frame;
                rect.origin.x += (defaultPace + defaultWidth);
                item.frame = rect;
            }
            self.moveCount++;
        }else{
            // 后面的向前移动
            for (int i = index + 1; i < self.itemList.count; i++) {
                WQProImgItem *item = [self.itemList objectAtIndex:(NSUInteger)i];
                CGRect rect = item.frame;
                rect.origin.x -= (defaultPace + defaultWidth);
                item.frame = rect;
            }
            
            // step_3: defaultItem向前移动
            CGRect rect = self.defaultItem.frame;
            rect.origin.x -= (defaultPace + defaultWidth);
            self.defaultItem.frame = rect;
            self.defaultItem.alpha = 1.0;
            
        }
        proItem.alpha = 0.0;
    } completion:^(BOOL finished){
        
        // step_4: 删除被点击的unitCell
        [proItem removeFromSuperview];
        [self.itemList removeObject:proItem];
        
        if (self.itemList.count <= defaultVisibleCount)
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        if (self.frontMove) {
            [self isNeedResetFrame];
        }
    }];
}
///当删除操作是前面的unitCell向后移动时
///做滚动操作或者添加操作需要重新设置每个unitCell的frame
- (void)isNeedResetFrame {
    if (self.frontMove && self.moveCount > 0) {
        
        for (int i = 0; i < self.itemList.count; i++) {
            WQProImgItem *item = [self.itemList objectAtIndex:(NSUInteger) i];
            CGRect rect = item.frame;
            rect.origin.x -= (defaultPace + defaultWidth) * self.moveCount;
            item.frame = rect;
        }
        
        CGRect rect = self.defaultItem.frame;
        rect.origin.x -= (defaultPace + defaultWidth) * self.moveCount;
        self.defaultItem.frame = rect;
        
        self.frontMove = NO;
        self.moveCount = 0;
    }
    
    if (self.hasDelete) {
        self.scrollView.contentSize = [self contentSizeForUIScrollView:(self.itemList.count + 1)];
        self.hasDelete = !self.hasDelete;
    }
}
@end
