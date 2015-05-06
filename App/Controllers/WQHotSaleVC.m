//
//  WQHotSaleVC.m
//  App
//
//  Created by 邱成西 on 15/3/25.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQHotSaleVC.h"
#import "WQProductObj.h"
#import "WQHotSaleCell.h"

#import "MJRefresh.h"

#import "WQProductDetailVC.h"

@interface WQHotSaleVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

///当前页开始索引
@property (nonatomic, assign) NSInteger start;
@property (nonatomic, assign) NSInteger lastProductId;
///分页基数---默认10
@property (nonatomic, assign) NSInteger limit;
///总页数
@property (nonatomic, assign) NSInteger pageCount;
@end

@implementation WQHotSaleVC

-(void)dealloc {
    SafeRelease(_collectionView.delegate);
    SafeRelease(_collectionView.dataSource);
    SafeRelease(_collectionView);
    SafeRelease(_dataArray);
}

#pragma mark - 获取产品列表

-(void)getProductList {
    __unsafe_unretained typeof(self) weakSelf = self;
    self.interfaceTask = [WQAPIClient getHotSaleListWithParameters:@{@"lastProductId":[NSNumber numberWithInteger:self.lastProductId],@"count":[NSNumber numberWithInteger:self.limit]} block:^(NSArray *array, NSInteger pageCount, NSError *error) {
        if (!error) {
            if (weakSelf.pageCount<0) {
                weakSelf.pageCount = pageCount;
            }
            
            [weakSelf.dataArray addObjectsFromArray:array];
            if (weakSelf.dataArray.count>0) {
                [weakSelf.collectionView reloadData];
                [weakSelf setNoneText:nil animated:NO];
            }else {
                [weakSelf setNoneText:NSLocalizedString(@"NoneProducts", @"") animated:YES];
            }
            
            if ((weakSelf.start/10+1)<self.pageCount) {
                [weakSelf.collectionView removeFooter];
                [weakSelf addFooter];
            }else {
                [weakSelf.collectionView removeFooter];
            }
        }else {
            [weakSelf.collectionView removeFooter];
        }
        [weakSelf.collectionView headerEndRefreshing];
        [weakSelf.collectionView footerEndRefreshing];
    }];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];

    self.limit = 10;
    
    //集成刷新控件
    [self addHeader];
    
    [self.collectionView headerBeginRefreshing];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.interfaceTask cancel];
    self.interfaceTask = nil;
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private

- (void)addHeader {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.collectionView addHeaderWithCallback:^{
        weakSelf.dataArray = nil;
        weakSelf.start = 0;
        weakSelf.lastProductId = 0;
        weakSelf.pageCount = -1;
        
        [weakSelf getProductList];
    } dateKey:@"WQHotSaleVC"];
}

- (void)addFooter {
    __unsafe_unretained typeof(self) weakSelf = self;
    [self.collectionView addFooterWithCallback:^{
        weakSelf.start += weakSelf.limit;
        if (weakSelf.dataArray.count>0) {
            WQProductObj *proObj = (WQProductObj *)[weakSelf.dataArray lastObject];
            weakSelf.lastProductId = proObj.productId;
        }
        
        [weakSelf getProductList];
    }];
}

#pragma mark - property
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
-(UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 5.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) collectionViewLayout:layout];
        _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[WQHotSaleCell class] forCellWithReuseIdentifier:@"WQHotSaleCell"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        [self.view addSubview:_collectionView];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WQHotSaleCell *cell = (WQHotSaleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"WQHotSaleCell" forIndexPath:indexPath];
    
    WQProductObj *proObj = (WQProductObj *)self.dataArray[indexPath.item];
    [cell setProductObj:proObj];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 140);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WQProductDetailVC *detailVC = [[WQProductDetailVC alloc]init];
    
    WQProductObj *proObj = (WQProductObj *)self.dataArray[indexPath.item];
    detailVC.productObj = proObj;
    [self.navControl pushViewController:detailVC animated:YES];
    SafeRelease(detailVC);
    
//    __block UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
//    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
//        cell.transform = CGAffineTransformMakeScale(1.03, 1.03);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
//            cell.transform = CGAffineTransformIdentity;
//        } completion:^(BOOL finished) {
//            
//        }];
//    }];
}

#pragma mark - toolBar事件
-(void)toolControlPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSaleVCShowNewProductVC" object:nil];
}
@end
