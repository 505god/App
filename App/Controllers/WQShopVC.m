//
//  WQShopVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQShopVC.h"

#import "WQNewProductVC.h"
#import "WQProductObj.h"
#import "XLCycleScrollView.h"

#import "UIImageView+WebCache.h"

@interface WQShopVC ()<XLCycleScrollViewDelegate,XLCycleScrollViewDatasource>

@property (nonatomic, strong) NSMutableArray *productList;

@property (nonatomic, weak) IBOutlet XLCycleScrollView *scrollView;

@end

@implementation WQShopVC

#pragma mark 轮播
- (void)moveToTargetPosition:(CGFloat)targetX
{
    if (targetX >= self.scrollView.scrollView.contentSize.width) {
        targetX = 0.0;
    }
    
    [self.scrollView.scrollView setContentOffset:CGPointMake(targetX, 0) animated:YES] ;
}

-(void)scrollTimer{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(scrollTimer)
                                               object:nil];
    
    CGFloat targetX = self.scrollView.scrollView.contentOffset.x + self.scrollView.scrollView.frame.size.width;
    [self moveToTargetPosition:targetX];
    
    [self performSelector:@selector(scrollTimer) withObject:nil afterDelay:3];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的店铺";
    
    //导航栏设置
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                              target:self
                                              action:@selector(addNewProduct)];

    
    self.scrollView.delegate = self;
    self.scrollView.datasource = self;
    
    //TODO:获取通讯录列表
    NSDictionary *aDic = [Utility returnDicByPath:@"ProductList"];
    NSArray *array = [aDic objectForKey:@"productList"];
    
    __weak typeof(self) wself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSDictionary *aDic = (NSDictionary *)obj;
            WQProductObj *product = [WQProductObj returnProductWithDic:aDic];
            [wself.productList addObject:product];
            SafeRelease(product);
            SafeRelease(aDic);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [wself.scrollView reloadData];
            //自动滚动
            [self performSelector:@selector(scrollTimer) withObject:nil afterDelay:3];
        });
    });
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(scrollTimer)
                                               object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addNewProduct {
    WQNewProductVC *proVC = LOADVC(@"WQNewProductVC");
    
    [self.navigationController pushViewController:proVC animated:YES];
    SafeRelease(proVC);
}

#pragma mark - property

-(NSMutableArray *)productList {
    if (!_productList) {
        _productList = [NSMutableArray array];
    }
    return _productList;
}

#pragma mark - XLCycleScrollView代理
- (NSInteger)numberOfPages {
    return self.productList==0?1:self.productList.count;
}

- (UIView *)pageAtIndex:(NSInteger)index {
    UIView *proView = [[UIView alloc]initWithFrame:(CGRect){0,0,CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame)}];
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:(CGRect){0,0,CGRectGetWidth(self.scrollView.frame),CGRectGetHeight(self.scrollView.frame)}];
    WQProductObj *product = (WQProductObj *)self.productList[index];
    
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",product.productImagesArray[0]]] placeholderImage:[UIImage imageNamed:@""]];
    
    UILabel *nameLab = [[UILabel alloc]initWithFrame:(CGRect){20,CGRectGetHeight(self.scrollView.frame)-20,200,20}];
    nameLab.text = product.productName;
    
    [proView addSubview:nameLab];
    [proView addSubview:imgView];
    
    return proView;
    
}
- (void)didClickPage:(XLCycleScrollView *)csView atIndex:(NSInteger)index {
    
}
@end
