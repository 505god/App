//
//  WQShopVC.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQShopVC.h"


#import "WQProductObj.h"


#import "DAPagesContainer.h"
#import "WQHotSaleVC.h"//热卖
#import "WQClassifyVC.h"//分类
#import "WQNewProductVC.h"//创建

@interface WQShopVC ()

//店铺logo、店铺名
@property (nonatomic, strong) UIView *shopView;
@property (nonatomic, strong) UIImageView *shopLogoImage;
@property (nonatomic, strong) UILabel *shopNameLab;

//热卖、分类、创建的容器
@property (strong, nonatomic) DAPagesContainer *pagesContainer;
@end

@implementation WQShopVC

-(void)dealloc {
    SafeRelease(_shopLogoImage);
    SafeRelease(_shopNameLab);
    SafeRelease(_shopView);
    [self.view removeObserver:self forKeyPath:@"frame"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HotSaleVCShowNewProductVC" object:nil];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initShopView];
    
    [self initContainerView];
    
    //KVO监测view的frame变化
    [self.view addObserver:self forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:Nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //hotSaleVC通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewProductVC:) name:@"HotSaleVCShowNewProductVC" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"HotSaleVCShowNewProductVC" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
//店铺
-(void)initShopView {
    self.shopView = [[UIView alloc]initWithFrame:(CGRect){0,0,self.view.width,180}];
    [self.shopView setShadow:[UIColor blackColor] rect:(CGRect){0,180,self.view.width,4} opacity:0.5 blurRadius:3];
    self.shopView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.shopView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.shopView];
    
    //店铺logo
    self.shopLogoImage = [[UIImageView alloc]initWithFrame:(CGRect){(self.view.width-90)/2,NavgationHeight,90,90}];
    self.shopLogoImage.contentMode = UIViewContentModeScaleAspectFill;
    self.shopLogoImage.image = [UIImage imageNamed:@"assets_placeholder_picture"];
    [Utility roundView:self.shopLogoImage];
    [self.shopView addSubview:self.shopLogoImage];
    
    //店铺名
    self.shopNameLab = [[UILabel alloc]initWithFrame:(CGRect){0,self.shopLogoImage.bottom+2,self.view.width,20}];
    self.shopNameLab.backgroundColor = [UIColor clearColor];
    self.shopNameLab.font = [UIFont systemFontOfSize:17];
    self.shopNameLab.text = @"龙舞精神";
    CGFloat width = [self.shopNameLab.text sizeWithFont:[UIFont systemFontOfSize:17]].width;
    self.shopNameLab.frame = (CGRect){(self.view.width-width)/2,self.shopLogoImage.bottom+2,width,20};
    [self.shopView addSubview:self.shopNameLab];
}

//商品类页面容器
-(void)initContainerView {
    self.pagesContainer = [[DAPagesContainer alloc] init];
    [self.pagesContainer willMoveToParentViewController:self];
    self.pagesContainer.view.frame = (CGRect){0,self.shopView.bottom+10,self.view.width,self.view.height-self.shopView.height-10};
    [self.view addSubview:self.pagesContainer.view];
    [self.pagesContainer didMoveToParentViewController:self];
    
    //热卖
    WQHotSaleVC *hotVC = LOADVC(@"WQHotSaleVC");
    hotVC.title = NSLocalizedString(@"HotSaleVC", @"");
    
    //分类
    WQClassifyVC *classifyVC = LOADVC(@"WQClassifyVC");
    classifyVC.title = NSLocalizedString(@"ProductClassifyVC", @"");
    
    //创建
    WQNewProductVC *creatProVC = LOADVC(@"WQNewProductVC");
    creatProVC.title = NSLocalizedString(@"NewProductVC", @"");
    
    self.pagesContainer.viewControllers = @[hotVC,classifyVC,creatProVC];
}

#pragma mark - 
//热卖商品页面跳转创建商品页面
-(void)showNewProductVC:(NSNotification *)notification {
    [self.pagesContainer setSelectedIndex:2 animated:YES];
}
#pragma mark - KVO
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [self updateSubViews];
}
-(void)updateSubViews {
    //店铺
    self.shopLogoImage.frame = (CGRect){(self.view.width-self.shopLogoImage.width)/2,NavgationHeight,self.shopLogoImage.width,self.shopLogoImage.height};
    self.shopNameLab.frame = (CGRect){(self.view.width-self.shopNameLab.width)/2,self.shopLogoImage.bottom+2,self.shopNameLab.width,self.shopNameLab.height};
}
@end
