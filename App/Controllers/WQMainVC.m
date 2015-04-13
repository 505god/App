//
//  WQMainVC.m
//  App
//
//  Created by 邱成西 on 15/3/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMainVC.h"

#import "WQShopVC.h"
#import "WQOrderVC.h"
#import "WQCustomerVC.h"
#import "WQSaleVC.h"
#import "WQMainRightVC.h"

#import "UIImageView+LBBlurredImage.h"

#define RightWidth self.view.width
#define LeftWidth 60

@interface WQMainVC ()<WQLeftBarViewDelegate,WQNavBarViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView *rightSideView;
@property (nonatomic, assign) BOOL showingRight;
@property (nonatomic, strong) UIImageView *mainBackgroundIV;//滑动后显示的模糊背景
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRec;//模糊图片的点击事件

@property (nonatomic, assign) BOOL showingLeft;

@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRec;

@property (nonatomic, strong) WQMainRightVC *rightVC;
@end

@implementation WQMainVC

-(void)dealloc {
    SafeRelease(_leftBarView);
    SafeRelease(_childenControllerArray);
    SafeRelease(_currentViewController);
    SafeRelease(_rightSideView);
    SafeRelease(_mainBackgroundIV);
    SafeRelease(_tapGestureRec);
    SafeRelease(_panGestureRec);
    SafeRelease(_rightVC);
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showSidebarView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"creatProductNotification" object:nil];
}

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //设置子controller
    self.currentViewController = [self.childenControllerArray objectAtIndex:self.currentPage];
    if (self.currentViewController) {
        [self addOneController:self.currentViewController];
    }
    
    //导航栏
    self.navBarView.navDelegate = self;
    [self.navBarView.leftBtn setHidden:YES];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"mainNavRight"] forState:UIControlStateNormal];
    self.navBarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navBarView];
    
    //设置左边栏   侧边栏打开状态
    [self.view addSubview:self.leftBarView];
    self.leftBarView.currentPage = self.currentPage;
    
    [self initRightVC];
    
    //隐藏侧边栏
    self.tapGestureRec = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSideBar)];
    self.tapGestureRec.delegate=self;
    self.tapGestureRec.enabled = NO;
    
    //滑动手势
    self.panGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGesture:)];
    self.panGestureRec.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRec];
    
    self.showingLeft = YES;
    [self configureViewBlurWith:self.view.width scale:0.1 type:0];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //监测scrollview滑动到边缘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSidebarView:) name:@"showSidebarView" object:nil];
    
    //创建商品时候隐藏导航栏和侧边栏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatProductNotification:) name:@"creatProductNotification" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showSidebarView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"creatProductNotification" object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initRightVC {
    self.rightVC = [[WQMainRightVC alloc]init];
    self.rightVC.view.frame = (CGRect){0,0,RightWidth,self.view.height};
    self.rightVC.navControl = self.navigationController;
    self.rightVC.navBarView.navDelegate = self;
    self.rightSideView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width, 0, RightWidth, self.view.height)];
    self.rightSideView.backgroundColor = COLOR(213, 213, 213, 1);
    [self.rightSideView addSubview:self.rightVC.view];
    [self.view addSubview:self.rightSideView];
}

#pragma mark - property
-(WQLeftBarView *)leftBarView {
    if (!_leftBarView) {
        NSArray *bundles = [[NSBundle mainBundle] loadNibNamed:@"WQLeftBarView" owner:self options:nil];
        _leftBarView = (WQLeftBarView*)[bundles objectAtIndex:0];
        _leftBarView.leftDelegate = self;
        //预留10像素
        _leftBarView.frame = (CGRect){0,0,LeftWidth,self.view.height};
        [_leftBarView defaultSelected];
    }
    return _leftBarView;
}
-(void)setChildenControllerArray:(NSArray *)childenControllerArray{
    if (_childenControllerArray != childenControllerArray && childenControllerArray&& childenControllerArray.count > 0) {
        for (UIViewController *controller in childenControllerArray) {
            [self addChildViewController:controller];
        }
    }
    _childenControllerArray = childenControllerArray;
}


-(void)setCurrentPageVC:(NSInteger)page {
    if (self.currentPage != page) {
        [self.leftBarView defaultSelected];
        self.currentPage = page;
        [self setTitleWithPage];
        [self changeFromController:self.currentViewController toController:[self.childenControllerArray objectAtIndex:self.currentPage]];
    }
}
//设置标题
-(void)setTitleWithPage {
    switch (self.currentPage) {
        case 0:
            self.navBarView.titleLab.text = @"";
            self.navBarView.backgroundColor = [UIColor clearColor];
            self.navBarView.isShowShadow = NO;
            break;
        case 1:
            self.navBarView.titleLab.text = NSLocalizedString(@"OrderVC", @"");
            self.navBarView.backgroundColor = [UIColor whiteColor];
            self.navBarView.isShowShadow = YES;
            break;
        case 2:
            self.navBarView.titleLab.text = NSLocalizedString(@"CustomerVC", @"");
            self.navBarView.backgroundColor = [UIColor whiteColor];
            self.navBarView.isShowShadow = YES;
            break;
        case 3:
            self.navBarView.titleLab.text = NSLocalizedString(@"SaleVC", @"");
            self.navBarView.backgroundColor = [UIColor whiteColor];
            self.navBarView.isShowShadow = YES;
            break;
            
        default:
            break;
    }
}
#pragma mark - 子controller之间切换
-(void)addOneController:(UIViewController*)childController{
    if (!childController) {
        return;
    }
    [childController willMoveToParentViewController:childController];
    childController.view.frame = (CGRect){LeftWidth,0,self.view.width-LeftWidth,self.view.height};
    [self.view addSubview:childController.view];
    [childController didMoveToParentViewController:self];
    [self.view bringSubviewToFront:self.leftBarView];
}

-(void)changeFromController:(UIViewController*)from toController:(UIViewController*)to{
    if (!from || !to) {
        return;
    }
    if (from == to) {
        return;
    }
    to.view.frame = (CGRect){self.leftBarView.right,0,self.view.width-self.leftBarView.right,self.view.height};
    [self transitionFromViewController:from toViewController:to duration:0 options:UIViewAnimationOptionTransitionNone animations:^{
        
    } completion:^(BOOL finished) {
        self.currentViewController = to;
        [self setTitleWithPage];
        [self.view bringSubviewToFront:self.navBarView];

        if(self.mainBackgroundIV != nil){
            [self.view bringSubviewToFront:self.mainBackgroundIV];
        }
        [self.view bringSubviewToFront:self.leftBarView];
    }];
}
#pragma mark - 导航栏代理

//左侧边栏的代理
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self closeSideBar];
}
//  self  的代理
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    [self showRightViewController];
}

#pragma mark - 左侧栏代理

-(void)leftTabBar:(WQLeftBarView*)tabBarView selectedItem:(LeftTabBarItemType)itemType {
    if (itemType < self.childenControllerArray.count) {
        self.currentPage = itemType;
        
        [self changeFromController:self.currentViewController toController:[self.childenControllerArray objectAtIndex:itemType]];
    }
}

#pragma mark -  滑动手势

- (void)moveViewWithGesture:(UIPanGestureRecognizer *)panGes {
    
    [self.currentViewController.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    
    static CGFloat startX;
    static CGFloat lastX;
    static CGFloat durationX;
    CGPoint touchPoint = [panGes locationInView:[[UIApplication sharedApplication] keyWindow]];
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        startX = touchPoint.x;
        lastX = touchPoint.x;
    }
    
    if (panGes.state == UIGestureRecognizerStateChanged) {
        CGFloat currentX = touchPoint.x;
        durationX = currentX - lastX;
        lastX = currentX;
        if (durationX > 0) {//显示左边栏
            if(!self.showingLeft && !self.showingRight) {
                self.showingLeft = YES;
            }
        }else {//显示右边栏
            if(!self.showingLeft && !self.showingRight){
                self.showingRight = YES;
                [self.view bringSubviewToFront:self.rightSideView];
            }
        }
        
        if (self.showingRight){
            float x = durationX + self.rightSideView.frame.origin.x;
            if (x>(self.view.width-RightWidth)) {
                [self configureViewBlurWith:(self.view.width - currentX) scale:0.8 type:1];
                [self.rightSideView setFrame:CGRectMake(x, 0, RightWidth, self.view.height)];
            }
        }else if (self.showingLeft){
            float x = durationX + self.leftBarView.left;
            if (x<=0 && x>=-50) {
                [self configureViewBlurWith:self.view.width scale:0.1 type:0];
                [self.leftBarView setFrame:CGRectMake(x, 0, self.leftBarView.width, self.leftBarView.height)];
                [self.currentViewController.view setFrame:(CGRect){self.leftBarView.right,0,self.view.width-LeftWidth-x,self.view.height}];
            }
        }
    }else if (panGes.state == UIGestureRecognizerStateEnded) {
        if (self.showingRight){
            if (self.rightSideView.left < (self.view.width-RightWidth/2)){
                [UIView animateWithDuration:0.25f animations:^{
                    [self configureViewBlurWith:self.view.width scale:0.6 type:1];
                    [self.rightSideView setFrame:CGRectMake(self.view.width-RightWidth, 0, RightWidth, self.view.height)];
                } completion:^(BOOL finished){
                    self.rightSideView.userInteractionEnabled = YES;
                    self.tapGestureRec.enabled = YES;
                }];
            }else{
                [UIView animateWithDuration:0.25f animations:^{
                    [self configureViewBlurWith:0 scale:1 type:1];
                    [self.rightSideView setFrame:CGRectMake(self.view.width,0, RightWidth, self.view.height)];
                } completion:^(BOOL finished){
                    [self.view sendSubviewToBack:self.rightSideView];
                    self.showingLeft = NO;
                    self.showingRight = NO;
                    self.tapGestureRec.enabled = NO;
                    [self removeconfigureViewBlur];
                }];
            }
        }else if (self.showingLeft) {
            if ((self.leftBarView.left + self.leftBarView.width)>=30){
                [UIView animateWithDuration:0.25f animations:^{
                    [self configureViewBlurWith:self.view.width scale:0.1 type:0];
                    [self.leftBarView setFrame:CGRectMake(0, 0, LeftWidth, self.view.height)];
                    [self.currentViewController.view setFrame:(CGRect){self.leftBarView.right,0,self.view.width-LeftWidth,self.view.height}];
                } completion:^(BOOL finished){
                    self.leftBarView.userInteractionEnabled = YES;
                    self.tapGestureRec.enabled = YES;
                }];
            }else{
                [UIView animateWithDuration:0.25f animations:^{
                    [self configureViewBlurWith:0 scale:0.8 type:0];
                    [self.leftBarView setFrame:CGRectMake(-50,0,LeftWidth,self.view.height)];
                    [self.currentViewController.view setFrame:(CGRect){10,0,self.view.width-10,self.view.height}];
                } completion:^(BOOL finished){
                    self.showingLeft = NO;
                    self.showingRight = NO;
                    self.tapGestureRec.enabled = NO;
                    self.leftBarView.userInteractionEnabled = NO;
                    [self removeconfigureViewBlur];
                }];
            }
        }
    }
}

//显示右侧边栏
- (void)showRightViewController {
    if (self.showingRight) {
        [self closeSideBar];
        return;
    }
    
    self.showingRight = YES;
    [self.view bringSubviewToFront:self.rightSideView];
    
    [self configureViewBlurWith:0 scale:1 type:1];
    [UIView animateWithDuration:0.25f animations:^{
        [self configureViewBlurWith:self.view.width scale:0.6 type:1];
        [self.rightSideView setFrame:CGRectMake(self.view.width-RightWidth, 0, RightWidth, self.view.height)];
    } completion:^(BOOL finished){
        self.rightSideView.userInteractionEnabled = YES;
        self.tapGestureRec.enabled = YES;
    }];
}
//显示左侧边栏
- (void)showLeftViewController {
    if (self.showingLeft) {
        [self closeSideBar];
        return;
    }
    
    self.showingLeft = YES;
    [self.view bringSubviewToFront:self.leftBarView];
    
    [UIView animateWithDuration:0.25f animations:^{
        [self configureViewBlurWith:self.view.width scale:0.1 type:0];
        [self.leftBarView setFrame:CGRectMake(0, 0, LeftWidth, self.view.height)];
        [self.currentViewController.view setFrame:(CGRect){self.leftBarView.right,0,self.view.width-LeftWidth,self.view.height}];
    } completion:^(BOOL finished){
        self.leftBarView.userInteractionEnabled = YES;
        self.tapGestureRec.enabled = YES;
    }];
}
//关闭侧边栏
- (void)closeSideBar {
    if (self.showingLeft) {
        [UIView animateWithDuration:0.25f animations:^{
            [self configureViewBlurWith:0 scale:0.8 type:0];
            [self.leftBarView setFrame:CGRectMake(-50,0,LeftWidth,self.view.height)];
            [self.currentViewController.view setFrame:(CGRect){10,0,self.view.width-10,self.view.height}];
        } completion:^(BOOL finished){
            self.showingLeft = NO;
            self.showingRight = NO;
            self.tapGestureRec.enabled = NO;
            
            [self removeconfigureViewBlur];
            self.leftBarView.userInteractionEnabled = NO;
        }];
    }else {
        [UIView animateWithDuration:0.25f animations:^{
            [self configureViewBlurWith:0 scale:1 type:1];
            [self.rightSideView setFrame:(CGRect){self.view.width,0,RightWidth,self.view.height}];
        } completion:^(BOOL finished){
            [self.view sendSubviewToBack:self.rightSideView];
            self.showingLeft = NO;
            self.showingRight = NO;
            self.tapGestureRec.enabled = NO;
            [self removeconfigureViewBlur];
        }];
    }
}

#pragma mark - 覆盖模糊图片

- (UIImage *)getImageFromView:(UIView *)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
- (void)configureViewBlurWith:(float)nValue scale:(float)nScale type:(NSInteger)type {
    if(self.mainBackgroundIV == nil) {
        self.mainBackgroundIV = [[UIImageView alloc] initWithFrame:self.view.bounds];
        self.mainBackgroundIV.userInteractionEnabled = YES;
        [self.mainBackgroundIV addGestureRecognizer:self.tapGestureRec];
        [self.tapGestureRec setEnabled:YES];
        
        if (type==0) {
            [self.view insertSubview:self.mainBackgroundIV belowSubview:self.leftBarView];
        }else if(type==1){
            UIImage *image = [self getImageFromView:self.view];
            [self.mainBackgroundIV setImageToBlur:image
                                       blurRadius:kLBBlurredImageDefaultBlurRadius
                                  completionBlock:^(){}];
            [self.view insertSubview:self.mainBackgroundIV belowSubview:self.rightSideView];
        }
        
    }
    [self.mainBackgroundIV setAlpha:(nValue/self.view.width) * nScale];
}

- (void)removeconfigureViewBlur {
    [self.mainBackgroundIV removeFromSuperview];
    self.mainBackgroundIV = nil;
}

#pragma mark -

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - 

-(void)showSidebarView:(NSNotification *)notification {
    NSInteger type = [notification.object integerValue];
    if (type==0) {//左
        if (self.showingLeft || self.showingRight) {
            return;
        }else {
            [self showLeftViewController];
        }
    }else if (type==1){//右
        if (self.showingRight || self.showingLeft) {
            return;
        }else {
            [self showRightViewController];
        }
    }
}

-(void)creatProductNotification:(NSNotification *)notification {
    NSInteger type = [notification.object integerValue];
    if (type==0) {//隐藏
        [self.panGestureRec setEnabled:NO];
        [self.navBarView setHidden:YES];
        [self.leftBarView setHidden:YES];
    }else if (type==1) {//出现
        [self.panGestureRec setEnabled:YES];
        [self.navBarView setHidden:NO];
        [self.leftBarView setHidden:NO];
    }
}
@end
