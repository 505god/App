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

@interface WQHotSaleVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataArray;

///当前页开始索引
@property (nonatomic, assign) NSInteger start;
///总页数
@property (nonatomic, assign) NSInteger pageCount;
///刷新
@property (nonatomic, assign) BOOL isRefreshing;
///加载
@property (nonatomic, assign) BOOL isLoadingMore;

@end

@implementation WQHotSaleVC

-(void)testData {
    NSDictionary *aDic = [Utility returnDicByPath:@"ProductList"];
    NSArray *array = [aDic objectForKey:@"productList"];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *aDic = (NSDictionary *)obj;
        WQProductObj *product = [[WQProductObj alloc]init];
        [product mts_setValuesForKeysWithDictionary:aDic];
        [weakSelf.dataArray addObject:product];
        SafeRelease(product);
        SafeRelease(aDic);
    }];
    
    //判断数据源
    if (self.dataArray.count>0) {
        [self.collectionView reloadData];
        [self setNoneText:nil animated:NO];
        [self setToolImage:nil text:nil animated:NO];
    }else {
        [self setNoneText:NSLocalizedString(@"NoneProducts", @"") animated:YES];
        [self setToolImage:@"compose_photograph_highlighted" text:NSLocalizedString(@"NewProductVC", @"") animated:YES];
    }
}
-(void)dealloc {
    SafeRelease(_collectionView);
    SafeRelease(_dataArray);
    [self.view removeObserver:self forKeyPath:@"frame"];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];

    //集成刷新控件
    [self addHeader];
    [self addFooter];
    
    //KVO监测view的frame变化
    [self.view addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:Nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
    // 添加下拉刷新头部控件
    [self.collectionView addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf testData];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
            // 结束刷新
            [weakSelf.collectionView headerEndRefreshing];
        });
    } dateKey:@"WQHotSaleVC"];
    // dateKey用于存储刷新时间，也可以不传值，可以保证不同界面拥有不同的刷新时间
    
     //自动刷新(一进入程序就下拉刷新)
    [self.collectionView headerBeginRefreshing];
}

- (void)addFooter {
    __unsafe_unretained typeof(self) weakSelf = self;
    // 添加上拉刷新尾部控件
    [self.collectionView addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        [weakSelf testData];
        
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.collectionView reloadData];
             //结束刷新
            [weakSelf.collectionView footerEndRefreshing];
        });
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
    __block UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseIn|UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.transform = CGAffineTransformMakeScale(1.03, 1.03);
    } completion:^(BOOL finished) {
        //
        [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionAllowUserInteraction animations:^{
            cell.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
        }];
    }];
}

#pragma mark - toolBar事件
-(void)toolControlPressed {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HotSaleVCShowNewProductVC" object:nil];
}

#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self updateSubViews];
}
-(void)updateSubViews {
    self.collectionView.frame = (CGRect){0, 0, self.view.width, self.view.height};
    self.noneView.frame = (CGRect){0, 0, self.view.width, self.view.height};
    self.noneLabel.frame = (CGRect){(self.view.width-60)/2,(self.view.height-20)/2-30,60,20};

    self.toolControl.frame = (CGRect){0,self.view.height-NavgationHeight,self.view.width,NavgationHeight};
}
@end
