//
//  WQProImagesV.m
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProImagesV.h"

#import "WQAddProductCell.h"

#define defaultWidth  ([UIScreen mainScreen].bounds.size.width-20)/3      // 每一个Cell的默认宽度
#define defaultHeight 100
#define defaultPace   5       // Cell之间的间距
#define duration      0.5     // 动画执行时间
#define defaultVisibleCount 3 //默认显示的Cell的个数

@interface WQProImagesV ()<WQAddProductCellDelegate,UIScrollViewDelegate>

/*
 @abstract 用于显示成员
 */

@property (nonatomic, strong) UIScrollView   *scrollView;

/*
 @abstract 用于管理成员
 */
@property (nonatomic, strong) NSMutableArray *unitList;

/*
 @abstract 默认显示的占位图
 */
@property (nonatomic, strong) WQAddProductCell       *defaultUnit;

/*
 @abstract 判断是否有删除操作
 */
@property (nonatomic, assign) BOOL           hasDelete;

/*
 @abstract 判断删除操作unitCell的移动方向
 */
@property (nonatomic, assign) BOOL           frontMove;

/*
 @abstract 统计删除操作总共移动的次数
 */
@property (nonatomic, assign) int            moveCount;

@end

@implementation WQProImagesV

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self setProperty];
    }
    return self;
}

- (void) setProperty
{
    _unitList = [[NSMutableArray alloc] init];
    _hasDelete = NO;
    _moveCount = 0;
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollEnabled = YES;
    _scrollView.directionalLockEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleDefault;
    _scrollView.contentSize = [self contentSizeForUIScrollView:0];
    [self addSubview:_scrollView];
    
    _defaultUnit = [[WQAddProductCell alloc] initWithFrame:CGRectMake(defaultPace, 5, defaultWidth, defaultHeight) andImage:[UIImage imageNamed:@"add_attention_btn"] andName:@"" andImageUrl:nil];
    [_defaultUnit addTarget:self action:@selector(addNewItem) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_defaultUnit];
    [self scrollViewAbleScroll];
}


-(void)addNewItem {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNewProduct)]) {
        [self.delegate addNewProduct];
    }
}


/*
 *  @method
 *  @function
 *  根据index获取UIScrollView的ContentSize
 */
- (CGSize)contentSizeForUIScrollView:(int)index
{
    float width = (defaultPace + defaultWidth) * index+defaultPace;
    if (width < _scrollView.bounds.size.width)
        width = _scrollView.bounds.size.width;
    return CGSizeMake(width, 110);
}

/*
 *  @method
 *  @function
 *  根据_unitList.count
 *  设置scrollView是否可以滚动
 *  设置scrollView的ContentSize
 *  设置scrollView的VisibleRect
 */
- (void)scrollViewAbleScroll
{
    if (_unitList.count==AddProductImagesMax) {
        _scrollView.contentSize = [self contentSizeForUIScrollView:_unitList.count];
    }else {
        _scrollView.contentSize = [self contentSizeForUIScrollView:(_unitList.count + 1)];
    }
    
    [_scrollView scrollRectToVisible:CGRectMake(_scrollView.contentSize.width-defaultWidth, 0, defaultWidth, self.frame.size.height) animated:YES];
}

/*
 *  @method
 *  @function
 *  新增一个unitCell
 *  _defaultUnit向后移动并伴随动画效果
 *  newUnitCell渐变显示
 */
- (void)addNewUnit:(UIImage *)image withName:(NSString *)name
{
    if (_unitList.count==AddProductImagesMax) {//个数限制
        
    }else if (_unitList.count<AddProductImagesMax){
        __block WQAddProductCell *newUnitCell;
        CGFloat x = (_unitList.count) * (defaultPace + defaultWidth)+defaultPace;
        newUnitCell = [[WQAddProductCell alloc] initWithFrame:CGRectMake(x, 5, defaultWidth, defaultHeight) andImage:image andName:name andImageUrl:nil];
        newUnitCell.alpha = 0.1;
        newUnitCell.delegate = self;
        [_unitList addObject:newUnitCell];
        
        //添加
        if (self.delegate && [self.delegate respondsToSelector:@selector(addNewImage:)]) {
            [self.delegate addNewImage:image];
        }
        
        [_defaultUnit setHidden:_unitList.count==AddProductImagesMax?YES:NO];
        
        [_scrollView addSubview:newUnitCell];
        [self scrollViewAbleScroll];
        _defaultUnit.alpha = 0.5;
        
        [UIView animateWithDuration:duration animations:^(){
            CGRect rect = _defaultUnit.frame;
            rect.origin.x += (defaultPace + defaultWidth);
            _defaultUnit.frame = rect;
            _defaultUnit.alpha = 1.0;
            newUnitCell.alpha = 0.8;
            
        } completion:^(BOOL finished){
            newUnitCell.alpha = 1.0;
            
        }];
    }
}

//TODO:设置imageURL
- (void)addImageUnit:(NSString *)imageUrl withName:(NSString *)name
{
    if (_unitList.count==AddProductImagesMax) {//个数限制
        
    }else if (_unitList.count<AddProductImagesMax){
        __block WQAddProductCell *newUnitCell;
        CGFloat x = (_unitList.count) * (defaultPace + defaultWidth)+defaultPace;
        newUnitCell = [[WQAddProductCell alloc] initWithFrame:CGRectMake(x, 5, defaultWidth, defaultHeight) andImage:nil andName:name andImageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",imageUrl,imageUrl]]];
        newUnitCell.alpha = 0.1;
        newUnitCell.backgroundColor = [UIColor redColor];
        newUnitCell.delegate = self;
        [_unitList addObject:newUnitCell];
        
        [_defaultUnit setHidden:_unitList.count==AddProductImagesMax?YES:NO];
        
        [_scrollView addSubview:newUnitCell];
        [self scrollViewAbleScroll];
        _defaultUnit.alpha = 0.5;
        
        [UIView animateWithDuration:duration animations:^(){
            CGRect rect = _defaultUnit.frame;
            rect.origin.x += (defaultPace + defaultWidth);
            _defaultUnit.frame = rect;
            _defaultUnit.alpha = 1.0;
            newUnitCell.alpha = 0.8;
            
        } completion:^(BOOL finished){
            newUnitCell.alpha = 1.0;
            
        }];
    }
}

/*
 *  @method
 *  @function
 *  unitCell被点击代理，需要执行删除操作
 */
- (void)unitCellTouched:(WQAddProductCell *)unitCell
{
    _hasDelete = YES;
    int index = (int)[_unitList indexOfObject:unitCell];
    
    // step_1: 设置相关unitCell的透明度
    unitCell.alpha = 0.8;
    
    // 判断其余cell的移动方向（从前向后移动/从后向前移动）
    _frontMove = NO;
    if (_unitList.count - 1 > defaultVisibleCount
        && (_unitList.count - index - 1) <= defaultVisibleCount) {
        _frontMove = YES;
    }
    if (index == _unitList.count - 1 && !_frontMove)
        _defaultUnit.alpha = 0.5;
    
    [UIView animateWithDuration:duration animations:^(){
        
        // step_2: 其余unitCell依次移动
        if (_frontMove)
        {
            // 前面的向后移动
            for (int i = 0; i < index; i++) {
                WQAddProductCell *cell = [_unitList objectAtIndex:(NSUInteger) i];
                CGRect rect = cell.frame;
                rect.origin.x += (defaultPace + defaultWidth);
                cell.frame = rect;
            }
            _moveCount++;
        }
        else
        {
            // 后面的向前移动
            for (int i = index + 1; i < _unitList.count; i++) {
                WQAddProductCell *cell = [_unitList objectAtIndex:(NSUInteger)i];
                CGRect rect = cell.frame;
                rect.origin.x -= (defaultPace + defaultWidth);
                cell.frame = rect;
            }
            
            // step_3: _defaultUnit向前移动
            CGRect rect = _defaultUnit.frame;
            rect.origin.x -= (defaultPace + defaultWidth);
            _defaultUnit.frame = rect;
            _defaultUnit.alpha = 1.0;
            
        }
        unitCell.alpha = 0.0;
        
    } completion:^(BOOL finished){
        
        //删除
        if (self.delegate && [self.delegate respondsToSelector:@selector(removeImage:)]) {
            [self.delegate removeImage:unitCell.image];
        }
        
        // step_4: 删除被点击的unitCell
        [unitCell removeFromSuperview];
        [_unitList removeObject:unitCell];
        
        [_defaultUnit setHidden:_unitList.count==AddProductImagesMax?YES:NO];
        
        [self scrollViewAbleScroll];
        
        if (_unitList.count <= defaultVisibleCount)
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
        if (_frontMove) {
            [self isNeedResetFrame];
        }
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //    [self isNeedResetFrame];
}

/*
 *  @method
 *  @function
 *  当删除操作是前面的unitCell向后移动时
 *  做滚动操作或者添加操作需要重新设置每个unitCell的frame
 */
- (void)isNeedResetFrame
{
    if (_frontMove && _moveCount > 0) {
        
        for (int i = 0; i < _unitList.count; i++) {
            WQAddProductCell *cell = [_unitList objectAtIndex:(NSUInteger) i];
            CGRect rect = cell.frame;
            rect.origin.x -= (defaultPace + defaultWidth) * _moveCount;
            cell.frame = rect;
        }
        
        CGRect rect = _defaultUnit.frame;
        rect.origin.x -= (defaultPace + defaultWidth) * _moveCount;
        _defaultUnit.frame = rect;
        
        _frontMove = NO;
        _moveCount = 0;
    }
    
    if (_hasDelete)
    {
        _scrollView.contentSize = [self contentSizeForUIScrollView:(_unitList.count + 1)];
        _hasDelete = !_hasDelete;
    }
}

@end
