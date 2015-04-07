//
//  DAPagesContainerTopBar.m
//  DAPagesContainerScrollView
//
//  Created by Daria Kopaliani on 5/29/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import "DAPagesContainerTopBar.h"

@interface DAPagesContainerTopBar ()

@property (strong, nonatomic) NSArray *itemViews;

- (void)layoutItemViews;

@end


@implementation DAPagesContainerTopBar

CGFloat const DAPagesContainerTopBarItemViewWidth = 60;
CGFloat const DAPagesContainerTopBarItemsOffset = 30.;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = [UIFont systemFontOfSize:14];
        
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *lineView = [[UIView alloc]initWithFrame:(CGRect){10,self.height-7,self.width-20,1}];
        lineView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        lineView.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:lineView];
        SafeRelease(lineView);
        
        [self setShadow:[UIColor blackColor] rect:(CGRect){0,self.height,self.width,4} opacity:0.5 blurRadius:3];
    }
    return self;
}

-(void)dealloc {
    SafeRelease(_itemTitles);
    SafeRelease(_font);
    SafeRelease(_itemViews);
}
#pragma mark - Public

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index {
    CGPoint center = ((UIView *)self.itemViews[index]).center;
    return center;
}

#pragma mark * Overwritten setters

- (void)setItemTitles:(NSArray *)itemTitles {
    if (_itemTitles != itemTitles) {
        _itemTitles = itemTitles;
        NSMutableArray *mutableItemViews = [NSMutableArray arrayWithCapacity:itemTitles.count];
        for (NSUInteger i = 0; i < itemTitles.count; i++) {
            UIButton *itemView = [self addItemView];
            [itemView setTitle:itemTitles[i] forState:UIControlStateNormal];
            [mutableItemViews addObject:itemView];
        }
        self.itemViews = [NSArray arrayWithArray:mutableItemViews];
        [self layoutItemViews];
    }
}

- (void)setFont:(UIFont *)font {
    if (![_font isEqual:font]) {
        _font = font;
        for (UIButton *itemView in self.itemViews) {
            [itemView.titleLabel setFont:font];
        }
    }
}

#pragma mark - Private

- (UIButton *)addItemView {
    CGRect frame = CGRectMake(0., 0., DAPagesContainerTopBarItemViewWidth, self.height);
    UIButton *itemView = [[UIButton alloc] initWithFrame:frame];
    [itemView addTarget:self action:@selector(itemViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    itemView.titleLabel.font = self.font;
    [itemView setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [self addSubview:itemView];
    return itemView;
}

- (void)itemViewTapped:(UIButton *)sender {
    [self.delegate itemAtIndex:[self.itemViews indexOfObject:sender] didSelectInPagesContainerTopBar:self];
}

- (void)layoutItemViews {
    CGFloat x = (self.width-DAPagesContainerTopBarItemViewWidth*self.itemViews.count)/(self.itemViews.count+1);
    for (NSUInteger i = 0; i < self.itemViews.count; i++) {
        UIView *itemView = self.itemViews[i];
        itemView.frame = CGRectMake(x*(i+1)+itemView.width*i, 0., itemView.width, itemView.height);
    }

    [self.delegate layoutIndicator];
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    [self layoutItemViews];
//}

@end