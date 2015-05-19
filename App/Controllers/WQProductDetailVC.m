//
//  WQProductDetailVC.m
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductDetailVC.h"

#import "WQProAttributeCell.h"
#import "WQProAttributrFooter.h"

#import "WQProAttributeWithImgCell.h"

#import "WQClassObj.h"
#import "WQClassLevelObj.h"
#import "WQColorObj.h"
#import "WQSizeObj.h"

#import "WQClassVC.h"
#import "WQColorVC.h"
#import "WQSizeVC.h"

#import "JKImagePickerController.h"

#import "BlockAlertView.h"

#import "WQProductSaleVC.h"
#import "JSONKit.h"
///一级
static NSIndexPath *selectedProImageIndex = nil;
///二级  尺码
static NSInteger selectedIndex = -1;

@interface WQProductDetailVC ()<UITableViewDataSource, UITableViewDelegate,WQProAttributrFooterDelegate,WQProAttributeWithImgCellDelegate,WQColorVCDelegate,WQClassVCDelegate,WQSizeVCDelegate,JKImagePickerControllerDelegate,RMSwipeTableViewCellDelegate,WQProAttributeCellDelegate,WQProductSaleVCDelegate,WQNavBarViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

///带图片的数组
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) CGFloat keyboardHeight;

///商品分类
@property (nonatomic, strong) WQClassObj *selectedClassObj;
@property (nonatomic, strong) WQClassLevelObj *selectedLevelClassObj;


///是否热卖
@property (nonatomic, assign) BOOL isHotting;
///是否上架
@property (nonatomic, assign) BOOL isOnSale;

///传给后台数据
@property (nonatomic, strong) NSMutableDictionary *postDictionary;

//最低价格
@property (nonatomic, strong) NSString *lowPrice;
@property (nonatomic, strong) NSString *salelowPrice;
@end

@implementation WQProductDetailVC
#pragma mark - private

/*
 status:
 
 0=名称
 2=有图片
 3=分类
 4=客户
 5=完成创建
 6=热卖
 7=优惠方式
 8=上架
 */
//初始化数据
-(void)setArrayData {
    self.selectedClassObj = nil;
    self.selectedLevelClassObj = nil;
    self.postDictionary = nil;
    self.dataArray = [[NSMutableArray alloc]init];
    
    ///商品名称
    NSDictionary *aDic1 = @{@"titleName":NSLocalizedString(@"ProductDetail", @""),@"name":self.productObj.proName,@"status":@"0"};
    [self.dataArray addObject:aDic1];
    
    ///尺码、价格、库存
    for (int i=0; i<self.productObj.proImgArray.count; i++) {
        NSDictionary *dictionary = (NSDictionary *)self.productObj.proImgArray[i];
        NSMutableArray *tempArray = [NSMutableArray array];
        
        NSArray *listArray = (NSArray *)[dictionary objectForKey:@"proSizeArray"];
        for (int j=0; j<listArray.count; j++) {
            NSDictionary *sizeDic = (NSDictionary *)listArray[j];
            
            WQSizeObj *sizeObj = [[WQSizeObj alloc]init];
            sizeObj.sizeId = [[sizeDic objectForKey:@"productSizeId"]integerValue];
            sizeObj.sizeName = [sizeDic objectForKey:@"productSizeName"];
            
            //设置最低价格
            if ([self predicateText:[NSString stringWithFormat:@"%@",[sizeDic objectForKey:@"productPrice"]] regex:@"^[0-9]+(.[0-9]{1,2})?$"]){
                if (self.lowPrice==nil) {
                    self.lowPrice = [sizeDic objectForKey:@"productPrice"];
                }else {
                    if ([self.lowPrice floatValue]-[[sizeDic objectForKey:@"productPrice"] floatValue]>0.00001) {
                        self.lowPrice =[sizeDic objectForKey:@"productPrice"];
                    }
                }
            }
            
            NSDictionary *dicc = @{@"sizeTitle":NSLocalizedString(@"ProductSize", @""),@"sizeDetail":sizeObj,@"priceTitle":NSLocalizedString(@"ProductPrice", @""),@"priceDetail":[sizeDic objectForKey:@"productPrice"],@"stockTitle":NSLocalizedString(@"ProductStock", @""),@"stockDetail":[sizeDic objectForKey:@"productStock"]};
            [tempArray addObject:dicc];
        }
        
        WQColorObj *colorObj = [[WQColorObj alloc]init];
        colorObj.colorId = [[dictionary objectForKey:@"proColorId"] integerValue];
        colorObj.colorName = [dictionary objectForKey:@"proColorName"];
        
        NSDictionary *aDicccc = @{@"image":[dictionary objectForKey:@"productImg"],@"color":colorObj,@"property":tempArray,@"status":@"2"};
        
        [self.dataArray addObject:aDicccc];
        SafeRelease(aDicccc);
        SafeRelease(tempArray);
    }
    
    ///商品分类
    if ([Utility checkString:[NSString stringWithFormat:@"%@",self.productObj.proClassAName]] && [Utility checkString:[NSString stringWithFormat:@"%@",self.productObj.proClassBName]]) {
        self.selectedClassObj = [[WQClassObj alloc]init];
        self.selectedClassObj.classId = self.productObj.proClassAId;
        self.selectedClassObj.className = self.productObj.proClassAName;
        
        self.selectedLevelClassObj = [[WQClassLevelObj alloc]init];
        self.selectedLevelClassObj.levelClassId = self.productObj.proClassBId;
        self.selectedLevelClassObj.levelClassName = self.productObj.proClassBName;
    }
    NSDictionary *aDic3 = @{@"titleClass":NSLocalizedString(@"SelectedProClass", @""),@"details":([Utility checkString:[NSString stringWithFormat:@"%@",self.productObj.proClassBName]]?self.productObj.proClassBName:@""),@"status":@"3"};
    [self.dataArray addObject:aDic3];
    
    ///优惠方式
    
    if ((self.productObj.proOnSaleType) == 1) {
        self.salelowPrice = self.productObj.onSalePrice;
    }
    NSDictionary *aDic7 = @{@"titleSale":NSLocalizedString(@"ProductSaleType", @""),@"details":([Utility checkString:[NSString stringWithFormat:@"%@",self.productObj.onSalePrice]]?self.productObj.onSalePrice:@""),@"status":@"7",@"type":[NSString stringWithFormat:@"%d",self.productObj.proOnSaleType-1],@"start":([Utility checkString:[NSString stringWithFormat:@"%@",self.productObj.proSaleStartTime]]?self.productObj.proSaleStartTime:@""),@"end":([Utility checkString:[NSString stringWithFormat:@"%@",self.productObj.proSaleEndTime]]?self.productObj.proSaleEndTime:@""),@"limit":[NSString stringWithFormat:@"%d",self.productObj.proStock]};
    [self.dataArray addObject:aDic7];
    
    //热卖
    self.isHotting = self.productObj.proIsHot;
    NSDictionary *aDic14 = @{@"titleHot":NSLocalizedString(@"ProductHotSale", @""),@"isOn":[NSString stringWithFormat:@"%d",self.productObj.proIsHot],@"status":@"6"};
    [self.dataArray addObject:aDic14];
    
    //上架
    self.isOnSale = self.productObj.proIsSale;
    NSDictionary *aDic15 = @{@"titleHot":NSLocalizedString(@"ProductOnSale", @""),@"isOn":[NSString stringWithFormat:@"%d",self.productObj.proIsSale],@"status":@"8"};
    [self.dataArray addObject:aDic15];
    
    ///删除
    NSDictionary *aDic25 = @{@"titleFinish":NSLocalizedString(@"Delete", @""),@"status":@"9"};
    [self.dataArray addObject:aDic25];
    
    [self.tableView reloadData];
    
    SafeRelease(aDic1);
    SafeRelease(aDic3);
    SafeRelease(aDic7);
    SafeRelease(aDic15)
    SafeRelease(aDic25);
}

-(BOOL)checkDataArray {
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *aDic = (NSDictionary *)self.dataArray[i];
        NSInteger status = [[aDic objectForKey:@"status"]integerValue];
        
        ///商品名称
        if (status==0) {
            if (![[aDic objectForKey:@"name"] isEqualToString:self.productObj.proName]) {
                return YES;
            }
        }
  
        ///商品分类
        if (self.selectedClassObj.classId!=self.productObj.proClassAId || self.selectedLevelClassObj.levelClassId!=self.productObj.proClassBId) {
            return YES;
        }
        ///优惠方式
        if (status==7) {
            if (![[aDic objectForKey:@"details"] isEqualToString:self.productObj.onSalePrice] || ([[aDic objectForKey:@"type"]integerValue]!=(self.productObj.proOnSaleType-1)) || ![[aDic objectForKey:@"start"] isEqualToString:self.productObj.proSaleStartTime] || ![[aDic objectForKey:@"end"] isEqualToString:self.productObj.proSaleEndTime] || ([[aDic objectForKey:@"limit"]integerValue]!=self.productObj.proStock)) {
                return YES;
            }
        }
        //热卖
        if (self.isHotting != self.productObj.proIsHot) {
            return YES;
        }
        //上架
        if (self.isOnSale != self.productObj.proIsSale) {
            return YES;
        }
    }
    return NO;
}
#pragma mark - WQNavBarViewDelegate
-(void)leftBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)rightBtnClickByNavBarView:(WQNavBarView *)navView {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    
    BOOL res = [self getPostStringWithImage];
    if (res) {
        [MBProgressHUD showHUDAddedTo:self.appDel.window.rootViewController.view animated:YES];
        [self.postDictionary setObject:@"1" forKey:@"type"];
        
        [self upLoadImageArray:[self.postDictionary objectForKey:@"proImgArray"]];
    }else
        return;
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    [self.navBarView setTitleString:NSLocalizedString(@"ProductDetails", @"")];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveAct"] forState:UIControlStateNormal];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveNor"] forState:UIControlStateHighlighted];
    [self.navBarView.rightBtn setImage:[UIImage imageNamed:@"saveNor"] forState:UIControlStateDisabled];
    self.navBarView.rightBtn.enabled = NO;
    self.navBarView.navDelegate = self;
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self setArrayData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [WQAPIClient cancelConnection];
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

#pragma mark - property

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.navBarView.bottom+10,self.view.width,self.view.height-10-self.navBarView.height} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[WQProAttributrFooter class] forHeaderFooterViewReuseIdentifier:@"WQProAttributrFooter"];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
-(NSMutableDictionary *)postDictionary {
    if (!_postDictionary) {
        _postDictionary = [NSMutableDictionary dictionary];
    }
    return _postDictionary;
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}
#pragma mark - tableView

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else if (section==self.dataArray.count-5) {
        return 40;
    }
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == self.dataArray.count-5) {
        WQProAttributrFooter *footer = (WQProAttributrFooter *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"WQProAttributrFooter"];
        footer.footDelegate = self;
        return footer;
    }
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *aDic = (NSDictionary *)self.dataArray[indexPath.section];
    if ([[aDic objectForKey:@"status"]integerValue]==2) {
        NSArray *array = [aDic objectForKey:@"property"];
        ///尺码、库存、价格 30；  添加更多规格30；  图片60
        return array.count*3*30+30+60;
    }
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *aDic = (NSDictionary *)self.dataArray[indexPath.section];
    NSInteger status = [[aDic objectForKey:@"status"]integerValue];
    
    if (status==2) {
        static NSString * identifier = @"CreatProCellImage_WE";
        
        WQProAttributeWithImgCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell=[[WQProAttributeWithImgCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.revealDirection = RMSwipeTableViewCellRevealDirectionRight;
        [cell setDetailVC:self];
        [cell setIndexPath:indexPath];
        cell.attributeWithImgDelegate = self;
        cell.delegate = self;
        
        [cell setDictionary:aDic];
        
        return cell;
    }else {//Default
        static NSString * identifier = @"CreatProCellImageDefault";
        
        WQProAttributeCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell=[[WQProAttributeCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier ];
        }
        if (status==3 || status==4 || status==5|| status==6 || status==7|| status==8) {
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            if (status==5|| status==6|| status==8) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }else {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        [cell setDetailVC:self];
        [cell setIdxPath:indexPath];
        [cell setDataDic:aDic];
        cell.delegate = self;
        return cell;
    }
    return nil;
}
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    if (point.x < 0 && (0-point.x) >= 60) {
        swipeTableViewCell.shouldAnimateCellReset = YES;
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
            
            swipeTableViewCell.shouldAnimateCellReset = NO;
            [UIView animateWithDuration:0.25
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 swipeTableViewCell.contentView.frame = CGRectOffset(swipeTableViewCell.contentView.bounds, swipeTableViewCell.contentView.frame.size.width, 0);
                             }
                             completion:^(BOOL finished) {
                                 [self.dataArray removeObjectAtIndex:indexPath.section];
                                 [swipeTableViewCell setHidden:YES];
                                 [self.tableView reloadData];
                             }
             ];
        }];
        [alert show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    
    if (indexPath.section == self.dataArray.count-1) {//删除
        BlockAlertView *alert = [BlockAlertView alertWithTitle:@"Alert Title" message:NSLocalizedString(@"ConfirmDelete", @"")];
        
        [alert setCancelButtonWithTitle:NSLocalizedString(@"Cancel", @"") block:nil];
        [alert setDestructiveButtonWithTitle:NSLocalizedString(@"Confirm", @"") block:^{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [[WQAPIClient sharedClient] POST:@"/rest/product/delProduct" parameters:@{@"productId":[NSNumber numberWithInteger:self.productObj.proId]} success:^(NSURLSessionDataTask *task, id responseObject) {
                
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *jsonData=(NSDictionary *)responseObject;
                    
                    if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                        if (self.delegate && [self.delegate respondsToSelector:@selector(deleteWQProductDetailVC:indexPath:)]) {
                            [self.delegate deleteWQProductDetailVC:self indexPath:self.indexPath];
                        }
                        [self.navigationController popViewControllerAnimated:YES];
                    }else {
                        [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                    }
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
            }];
        }];
        [alert show];
    }else if (indexPath.section == self.dataArray.count-4){//优惠方式
        __block WQProductSaleVC *saleVC = [[WQProductSaleVC alloc]init];
        saleVC.delegate = self;
        saleVC.selectedIndexPath = indexPath;
        saleVC.lowPrice = self.lowPrice;
        saleVC.objectDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[self.dataArray.count-4]];
        
        [self.view.window.rootViewController presentViewController:saleVC animated:YES completion:^{
            SafeRelease(saleVC);
        }];
    }else if (indexPath.section == self.dataArray.count-5){//选择分类
        __block WQClassVC *classVC = [[WQClassVC alloc]init];
        classVC.delegate = self;
        classVC.isPresentVC = YES;
        classVC.selectedIndexPath = indexPath;
        classVC.selectedClassBObj = self.selectedLevelClassObj;
        classVC.selectedClassAObj = self.selectedClassObj;
        [self.view.window.rootViewController presentViewController:classVC animated:YES completion:^{
            SafeRelease(classVC);
        }];
    }
}

//去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGFloat sectionHeaderHeight = 30;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
}
#pragma mark - 添加商品型号
-(void)addMoreProType {
    [self.view.subviews makeObjectsPerformSelector:@selector(endEditing:)];
    
    ///尺码、价格、库存
    NSDictionary *aDic = @{@"sizeTitle":NSLocalizedString(@"ProductSize", @""),@"sizeDetail":@"",@"priceTitle":NSLocalizedString(@"ProductPrice", @""),@"priceDetail":@"",@"stockTitle":NSLocalizedString(@"ProductStock", @""),@"stockDetail":@""};
    NSArray *array = @[aDic];
    
    NSDictionary *aDic2 = @{@"image":@"",@"color":@"",@"property":array,@"status":@"2"};
    
    [self.dataArray insertObject:aDic2 atIndex:self.dataArray.count-5];
    
    [self.tableView reloadData];
}

#pragma mark - WQProAttributeWithImgCellDelegate 有图片
#pragma mark - 选择颜色
-(void)selectedProductColor:(WQProductBtn *)colorBtn {
    DLog(@"选择颜色");
    
    selectedProImageIndex = colorBtn.idxPath;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    [self.dataArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != colorBtn.idxPath.section) {
            NSDictionary *dictionary = (NSDictionary *)obj;
            if ([[dictionary objectForKey:@"color"] isKindOfClass:[WQColorObj class]] && [dictionary objectForKey:@"color"]!=nil) {
                WQColorObj *color = (WQColorObj *)[dictionary objectForKey:@"color"];
                [tempArray addObject:[NSString stringWithFormat:@"%d",color.colorId]];
            }
        }
    }];
    
    __block WQColorVC *colorVC = [[WQColorVC alloc]init];
    colorVC.isPresentVC = YES;
    colorVC.delegate = self;
    colorVC.selectedIndexPath = colorBtn.idxPath;
    colorVC.hasSelectedColor = tempArray;
    ///选择的颜色
    NSDictionary *object = (NSDictionary *)self.dataArray[selectedProImageIndex.section];
    if ([[object objectForKey:@"color"] isKindOfClass:[WQColorObj class]] && [object objectForKey:@"color"]!=nil) {
        colorVC.selectedColorObj = (WQColorObj *)[object objectForKey:@"color"];
    }else {
        colorVC.selectedColorObj = nil;
    }
    
    [self.view.window.rootViewController presentViewController:colorVC animated:YES completion:^{
        SafeRelease(colorVC);
    }];
}

//选择颜色代理回调
-(void)colorVC:(WQColorVC *)colorVC selectedColor:(WQColorObj *)colorObj {
    self.navBarView.rightBtn.enabled = YES;
    
    __weak typeof(self) weakSelf = self;
    [colorVC dismissViewControllerAnimated:YES completion:^{
        WQProAttributeWithImgCell *cell = (WQProAttributeWithImgCell *)[weakSelf.tableView cellForRowAtIndexPath:selectedProImageIndex];
        cell.colorObj = colorObj;
        
        ///更改数据
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[selectedProImageIndex.section]];
        [mutableDic setObject:colorObj forKey:@"color"];
        [self.dataArray replaceObjectAtIndex:selectedProImageIndex.section withObject:mutableDic];
        selectedProImageIndex = nil;
    }];
}
#pragma mark - 添加图片

-(void)selectedProductImage:(WQProAttributeWithImgCell *)cell {
    DLog(@"添加图片");
    selectedProImageIndex = cell.indexPath;
    __block JKImagePickerController *imagePicker = [[JKImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.allowsMultipleSelection = NO;
    imagePicker.minimumNumberOfSelection = 1;
    imagePicker.maximumNumberOfSelection = 1;
    [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:^{
        SafeRelease(imagePicker);
    }];
}

/// JKImagePickerControllerDelegate

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets{
    self.navBarView.rightBtn.enabled = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    JKAssets *asset = (JKAssets *)assets[0];
    __block UIImage *image = nil;
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            UIImage *tempImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
            image = [Utility dealImageData:tempImg];//图片处理
            SafeRelease(tempImg);
        }
    } failureBlock:^(NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"PhotoSelectedError", @"")];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        WQProAttributeWithImgCell *cell = (WQProAttributeWithImgCell *)[weakSelf.tableView cellForRowAtIndexPath:selectedProImageIndex];
        cell.proImgView.image = image;
        
        ///更改数据
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[selectedProImageIndex.section]];
        [mutableDic setObject:image forKey:@"image"];
        [self.dataArray replaceObjectAtIndex:selectedProImageIndex.section withObject:mutableDic];
        selectedProImageIndex = nil;
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker {
    selectedProImageIndex = nil;
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - 选择尺码
-(void)selectedProductSize:(WQProductBtn *)sizeBtn {
    DLog(@"选择尺码");
    
    selectedProImageIndex = sizeBtn.idxPath;
    selectedIndex = sizeBtn.tag - SizeTextFieldTag;
    
    NSMutableArray *tempArray = [NSMutableArray array];
    
    NSDictionary *object = (NSDictionary *)self.dataArray[selectedProImageIndex.section];
    NSArray *array = (NSArray *)[object objectForKey:@"property"];
    
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx != selectedIndex) {
            NSDictionary *dic = (NSDictionary *)obj;
            if ([[dic objectForKey:@"sizeDetail"]isKindOfClass:[WQSizeObj class]] && [dic objectForKey:@"sizeDetail"]!=nil) {
                WQSizeObj *size = (WQSizeObj *)[dic objectForKey:@"sizeDetail"];
                [tempArray addObject:[NSString stringWithFormat:@"%d",size.sizeId]];
            }
        }
    }];
    
    __block WQSizeVC *sizeVC = [[WQSizeVC alloc]init];
    sizeVC.isPresentVC = YES;
    sizeVC.delegate = self;
    sizeVC.selectedIndexPath = sizeBtn.idxPath;
    sizeVC.hasSelectedSize = tempArray;
    
    NSDictionary *aDic = (NSDictionary *)array[selectedIndex];
    if ([[aDic objectForKey:@"sizeDetail"]isKindOfClass:[WQSizeObj class]] && [aDic objectForKey:@"sizeDetail"]!=nil) {
        sizeVC.selectedSizeObj = (WQSizeObj *)[aDic objectForKey:@"sizeDetail"];
    }else {
        sizeVC.selectedSizeObj = nil;
    }
    [self.view.window.rootViewController presentViewController:sizeVC animated:YES completion:^{
        SafeRelease(sizeVC);
    }];
}

///选择尺码代理回调
-(void)sizeVC:(WQSizeVC *)sizeVC selectedSize:(WQSizeObj *)sizeObj{
    self.navBarView.rightBtn.enabled = YES;
    __weak typeof(self) weakSelf = self;
    [sizeVC dismissViewControllerAnimated:YES completion:^{
        WQProAttributeWithImgCell *cell = (WQProAttributeWithImgCell *)[weakSelf.tableView cellForRowAtIndexPath:selectedProImageIndex];
        WQProductBtn *sizeBtn = (WQProductBtn *)[cell.contentView viewWithTag:(SizeTextFieldTag+selectedIndex)];
        [sizeBtn setTitle:sizeObj.sizeName forState:UIControlStateNormal];
        
        ///更改数据
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[selectedProImageIndex.section]];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[mutableDic objectForKey:@"property"]];
        NSMutableDictionary *aDic = [[NSMutableDictionary alloc]initWithDictionary:array[selectedIndex]];
        [aDic setObject:sizeObj forKey:@"sizeDetail"];
        [array replaceObjectAtIndex:selectedIndex withObject:aDic];
        [mutableDic setObject:array forKey:@"property"];
        [self.dataArray replaceObjectAtIndex:selectedProImageIndex.section withObject:mutableDic];
        selectedProImageIndex = nil;
        selectedIndex = -1;
    }];
}

#pragma mark - 删除尺码、价格、库存
-(void)deleteProductSize:(WQProductBtn *)deleteBtn {
    DLog(@"删除尺码、价格、库存");
    
    ///更改数据
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[deleteBtn.idxPath.section]];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[mutableDic objectForKey:@"property"]];
    
    [mutableArray removeObjectAtIndex:(deleteBtn.tag-DeleteBtnTag)];
    
    if (mutableArray.count==0) {
        [self.dataArray removeObjectAtIndex:deleteBtn.idxPath.section];
        [self.tableView reloadData];
    }else {
        [mutableDic setObject:mutableArray forKey:@"property"];
        [self.dataArray replaceObjectAtIndex:deleteBtn.idxPath.section withObject:mutableDic];
        
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:deleteBtn.idxPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
}
#pragma mark - 添加尺码、价格、库存
-(void)addProductSize:(WQProductBtn *)addBtn {
    DLog(@"添加尺码、价格、库存");
    
    DLog(@"section = %d",addBtn.idxPath.section);
    ///更改数据
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[addBtn.idxPath.section]];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[mutableDic objectForKey:@"property"]];
    NSDictionary *aDic = @{@"sizeTitle":NSLocalizedString(@"ProductSize", @""),@"sizeDetail":@"",@"priceTitle":NSLocalizedString(@"ProductPrice", @""),@"priceDetail":@"",@"stockTitle":NSLocalizedString(@"ProductStock", @""),@"stockDetail":@""};
    [mutableArray addObject:aDic];
    [mutableDic setObject:mutableArray forKey:@"property"];
    [self.dataArray replaceObjectAtIndex:addBtn.idxPath.section withObject:mutableDic];
    
    [self.tableView beginUpdates];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:addBtn.idxPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

#pragma mark - 选择分类
-(void)classVC:(WQClassVC *)classVC classA:(WQClassObj *)classObj classB:(WQClassLevelObj *)levelClassObj {
    [classVC dismissViewControllerAnimated:YES completion:^{
        self.selectedClassObj = classObj;
        self.selectedLevelClassObj = levelClassObj;
        
        NSMutableDictionary *mutableDic = nil;
        mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[self.dataArray.count-5]];
        
        [mutableDic setObject:levelClassObj.levelClassName forKey:@"details"];
        
        [self.dataArray replaceObjectAtIndex:(self.dataArray.count-5) withObject:mutableDic];
        
        self.navBarView.rightBtn.enabled = [self checkDataArray];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[classVC.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
}
#pragma mark - 选择优惠方式
-(void)selectedSale:(WQProductSaleVC *)saleVC object:(NSDictionary *)dictionary {
    [saleVC dismissViewControllerAnimated:YES completion:^{
        self.salelowPrice = saleVC.lowPrice;
        [self.dataArray replaceObjectAtIndex:(self.dataArray.count-4) withObject:dictionary];
        self.navBarView.rightBtn.enabled = [self checkDataArray];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[saleVC.selectedIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
}
#pragma mark - 热卖

-(void)proAttributeCell:(WQProAttributeCell *)cell changeSwitch:(BOOL)isHot {
    
    NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[cell.idxPath.section]];
    
    [mutableDic setObject:[NSNumber numberWithBool:isHot] forKey:@"isOn"];
    [self.dataArray replaceObjectAtIndex:cell.idxPath.section withObject:mutableDic];
    
    if (cell.switchBtn.tag==100) {
        self.isHotting = isHot;
    }else {
        self.isOnSale = isHot;
    }
    self.navBarView.rightBtn.enabled = [self checkDataArray];
}

#pragma mark - Keyboard notifications

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame2 = self.tableView.frame;
                         frame2.size.height += self.keyboardHeight;
                         frame2.size.height -= keyboardRect.size.height;
                         self.tableView.frame = frame2;
                         
                         self.keyboardHeight = keyboardRect.size.height;
                     }];
}
- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = self.tableView.frame;
                         frame.size.height += self.keyboardHeight;
                         frame.origin.x = 0;
                         self.tableView.frame = frame;
                         
                         self.keyboardHeight = 0;
                         
                     }];
}

- (void)scrollToIndex:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self.tableView scrollToRowAtIndexPath:indexPath
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:animated];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[WQProductText class]]) {
        WQProductText *text = (WQProductText *)textField;
        
        [self scrollToIndex:text.idxPath animated:YES];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([textField isKindOfClass:[WQProductText class]]) {
        WQProductText *text = (WQProductText *)textField;
        ///更改数据
        NSMutableDictionary *mutableDic = [[NSMutableDictionary alloc]initWithDictionary:self.dataArray[text.idxPath.section]];
        NSInteger status = [[mutableDic objectForKey:@"status"]integerValue];
        if (status==0) {
            [mutableDic setObject:text.text forKey:@"name"];
            [self.dataArray replaceObjectAtIndex:text.idxPath.section withObject:mutableDic];
            self.navBarView.rightBtn.enabled = [self checkDataArray];
        }else {
            NSMutableArray *array = [NSMutableArray arrayWithArray:[mutableDic objectForKey:@"property"]];
            
            NSInteger index = 0;
            if (text.tag>=PriceTextFieldTag && text.tag<StockTextFieldTag) {//价格
                index = text.tag-PriceTextFieldTag;
                
                NSMutableDictionary *aDic = [[NSMutableDictionary alloc]initWithDictionary:array[index]];
                [aDic setObject:text.text forKey:@"priceDetail"];
                [array replaceObjectAtIndex:index withObject:aDic];
                
                //设置最低价格
                if ([self predicateText:text.text regex:@"^[0-9]+(.[0-9]{1,2})?$"]){
                    if (self.lowPrice==nil) {
                        self.lowPrice = text.text;
                    }else {
                        if ([self.lowPrice floatValue]-[text.text floatValue]>0.00001) {
                            self.lowPrice =text.text;
                        }
                    }
                }
            }else if (text.tag>=StockTextFieldTag){//库存
                index = text.tag-StockTextFieldTag;
                
                NSMutableDictionary *aDic = [[NSMutableDictionary alloc]initWithDictionary:array[index]];
                [aDic setObject:text.text forKey:@"stockDetail"];
                [array replaceObjectAtIndex:index withObject:aDic];
            }
            [mutableDic setObject:array forKey:@"property"];
            [self.dataArray replaceObjectAtIndex:text.idxPath.section withObject:mutableDic];
            
            self.navBarView.rightBtn.enabled = YES;
        }
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isKindOfClass:[WQProductText class]]) {
        WQProductText *text = (WQProductText *)textField;
        
        if (text.returnKeyType == UIReturnKeyDone) {
            [text resignFirstResponder];
        }else if (text.returnKeyType == UIReturnKeyNext){
            WQProAttributeCell *cell = (WQProAttributeCell *)[self.tableView cellForRowAtIndexPath:text.idxPath];
            WQProductText *textNext = (WQProductText *)[cell.contentView viewWithTag:(text.tag-PriceTextFieldTag+StockTextFieldTag)];
            [textNext becomeFirstResponder];
        }
    }
    return YES;
}

#pragma mark -
#pragma mark - 整合数据传给后台

-(BOOL)predicateText:(NSString *)text regex:(NSString *)regex {
    NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (![test evaluateWithObject:text]){
        return NO;
    }else {
        return YES;
    }
}

-(BOOL)getPostStringWithImage {
    self.postDictionary = nil;
    
    BOOL isHasImage = NO;
    for (int i=0; i<self.dataArray.count; i++) {
        NSDictionary *aDic = (NSDictionary *)self.dataArray[i];
        
        NSInteger status = [[aDic objectForKey:@"status"]integerValue];
        if (status==0) {///商品名称
            if ([Utility checkString:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"name"]]]) {
                [self.postDictionary setObject:[aDic objectForKey:@"name"] forKey:@"productName"];
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"NameError", @"")];
                self.postDictionary = nil;
                return NO;
            }
        }else if (status==2) {///商品
            isHasImage = YES;
            NSMutableArray *imageArray = nil;
            if (![[self.postDictionary objectForKey:@"proImgArray"] isKindOfClass:[NSNull class]] && [self.postDictionary objectForKey:@"proImgArray"]!= nil) {
                imageArray = [NSMutableArray arrayWithArray:[self.postDictionary objectForKey:@"proImgArray"]];
            }else {
                imageArray = [[NSMutableArray alloc]init];
            }
            
            NSMutableDictionary *imageDic = [[NSMutableDictionary alloc]init];
            ///商品图片
            if ([[aDic objectForKey:@"image"]isKindOfClass:[UIImage class]] && [aDic objectForKey:@"image"]!=nil) {
                UIImage *image = (UIImage *)[aDic objectForKey:@"image"];
                [imageDic setObject:image forKey:@"productImg"];
            }else if ([[aDic objectForKey:@"image"]isKindOfClass:[NSString class]] && [aDic objectForKey:@"image"]!=nil){
                [imageDic setObject:[aDic objectForKey:@"image"] forKey:@"productImg"];
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ImageError", @"")];
                self.postDictionary = nil;
                return NO;
            }
            ///商品颜色
            if ([[aDic objectForKey:@"color"] isKindOfClass:[WQColorObj class]] && [aDic objectForKey:@"color"]!=nil) {
                WQColorObj *color = (WQColorObj *)[aDic objectForKey:@"color"];
                [imageDic setObject:[NSNumber numberWithInteger:color.colorId] forKey:@"proColorId"];
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ColorError", @"")];
                self.postDictionary = nil;
                return NO;
            }
            
            NSMutableArray *sizeArray = [[NSMutableArray alloc]init];
            NSArray *array = [aDic objectForKey:@"property"];
            for (int i=0; i<array.count; i++) {
                NSDictionary *dic = (NSDictionary *)array[i];
                NSMutableDictionary *sizeDic = [[NSMutableDictionary alloc]init];
                ///尺码
                if ([[dic objectForKey:@"sizeDetail"]isKindOfClass:[WQSizeObj class]] && [dic objectForKey:@"sizeDetail"]!=nil) {
                    WQSizeObj *size = (WQSizeObj *)[dic objectForKey:@"sizeDetail"];
                    [sizeDic setObject:[NSNumber numberWithInteger:size.sizeId] forKey:@"productSizeId"];
                }else {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"SizeError", @"")];
                    self.postDictionary = nil;
                    return NO;
                }
                ///价格
                NSString *priceString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"priceDetail"]];
                if (priceString.length==0) {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"PriceError", @"")];
                    self.postDictionary = nil;
                    return NO;
                }else {
                    if ([self predicateText:priceString regex:@"^[0-9]+(.[0-9]{1,2})?$"]) {
                        
                        if (([priceString floatValue]-[self.salelowPrice floatValue])<0.00001) {
                            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"pricesaleConfirmError", @"")];
                            self.postDictionary = nil;
                            return NO;
                        }else {
                            [sizeDic setObject:priceString forKey:@"productPrice"];
                        }
                    }else {
                        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"PriceError", @"")];
                        self.postDictionary = nil;
                        return NO;
                    }
                }
                ///库存
                NSString *stockString = [NSString stringWithFormat:@"%@",[dic objectForKey:@"stockDetail"]];
                if (stockString.length==0) {
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"StockError", @"")];
                    self.postDictionary = nil;
                    return NO;
                }else {
                    if ([self predicateText:stockString regex:@"^[0-9]*$"]) {
                        [sizeDic setObject:stockString forKey:@"productStock"];
                    }else {
                        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"StockConfirmError", @"")];
                        self.postDictionary = nil;
                        return NO;
                    }
                }
                [sizeArray addObject:sizeDic];
                SafeRelease(sizeDic);
            }
            [imageDic setObject:sizeArray forKey:@"proSizeArray"];
            SafeRelease(sizeArray);
            
            [imageArray addObject:imageDic];
            SafeRelease(imageDic);
            
            [self.postDictionary setObject:imageArray forKey:@"proImgArray"];
            SafeRelease(imageArray);
        }
    }
    
    if (isHasImage == NO) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"AddMarqueError", @"")];
        self.postDictionary = nil;
        return NO;
    }else {
        if (self.selectedLevelClassObj && self.selectedClassObj) {
            [self.postDictionary setObject:[NSNumber numberWithInteger:self.selectedLevelClassObj.levelClassId] forKey:@"proClassBId"];
            [self.postDictionary setObject:[NSNumber numberWithInteger:self.selectedClassObj.classId] forKey:@"proClassAId"];
        }else {
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"ClassSelectedError", @"")];
            self.postDictionary = nil;
            return NO;
        }
        
        [self.postDictionary setObject:[NSNumber numberWithInteger:self.isHotting] forKey:@"productIsHot"];
        [self.postDictionary setObject:[NSNumber numberWithInteger:self.isOnSale] forKey:@"productIsSale"];
        
        NSDictionary *dic = (NSDictionary *)self.dataArray[self.dataArray.count-4];
        [self.postDictionary setObject:[NSNumber numberWithInteger:([[dic objectForKey:@"type"] integerValue]+1)] forKey:@"proOnSaleType"];
        [self.postDictionary setObject:[dic objectForKey:@"details"] forKey:@"onSalePrice"];
        [self.postDictionary setObject:[dic objectForKey:@"start"] forKey:@"proSaleStartTime"];
        [self.postDictionary setObject:[dic objectForKey:@"end"] forKey:@"proSaleEndTime"];
        [self.postDictionary setObject:[dic objectForKey:@"limit"] forKey:@"onSaleStock"];
    }
    
    return YES;
}
#pragma mark - 上传图像
static NSInteger upLoadImgCount = 0;
-(void)upLoadImageArray:(NSArray *)imgArray {
    if (upLoadImgCount == imgArray.count) {
        [self saveProduct];
    }else {
        NSDictionary *dictionary = (NSDictionary *)imgArray[upLoadImgCount];
        
        if ([[dictionary objectForKey:@"productImg"]isKindOfClass:[UIImage class]] && [dictionary objectForKey:@"productImg"]!=nil) {
            UIImage *image = (UIImage *)[dictionary objectForKey:@"productImg"];
            
            [self postProductImg:image index:upLoadImgCount];
        }else {
            upLoadImgCount ++;
            return  [self upLoadImageArray:[self.postDictionary objectForKey:@"proImgArray"]];
        }
    }
}
-(void)postProductImg:(UIImage *)image index:(NSInteger)index {
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"https://barryhippo.xicp.net:8443/rest/img/uploadProImg" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 1)  name:@"imgFile" fileName:@"imgFile.jpeg" mimeType:@"image/jpeg"];
    } error:nil];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.securityPolicy.allowInvalidCertificates = YES;
    
    NSProgress *progress = nil;
    
    self.uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (!error) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)responseObject;
                
                if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                    
                    NSDictionary *obj = [jsonData objectForKey:@"returnObj"];
                    NSString *imagePath = [obj objectForKey:@"img"];
                    
                    NSMutableArray *mutableArray = [NSMutableArray arrayWithArray:[self.postDictionary objectForKey:@"proImgArray"]];
                    NSMutableDictionary *mutableDic = mutableArray[index];
                    [mutableDic setObject:imagePath forKey:@"productImg"];
                    [mutableArray replaceObjectAtIndex:index withObject:mutableDic];
                    [self.postDictionary setObject:mutableArray forKey:@"proImgArray"];
                    
                    
                    upLoadImgCount ++;
                    
                    return  [self upLoadImageArray:[self.postDictionary objectForKey:@"proImgArray"]];
                }else {
                    upLoadImgCount = 0;
                    [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
                }
            }
        }else {
            upLoadImgCount = 0;
            [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
        }
    }];
    [self.uploadTask resume];
}
//最终创建商品
-(void)saveProduct {
    [self.postDictionary setObject:[NSNumber numberWithInteger:self.productObj.moneyType] forKey:@"moneyType"];
    [self.postDictionary setObject:[NSNumber numberWithInteger:self.productObj.proId] forKey:@"productId"];
    
    NSString *jsonString = [self.postDictionary JSONString];
    self.interfaceTask = [[WQAPIClient sharedClient] POST:@"/rest/product/productEdit" parameters:@{@"product":jsonString} success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideAllHUDsForView:self.appDel.window.rootViewController.view animated:YES];
        upLoadImgCount = 0;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)responseObject;
            
            if ([[jsonData objectForKey:@"status"]integerValue]==1) {
                WQProductObj *productObj = [[WQProductObj alloc]init];
                [productObj mts_setValuesForKeysWithDictionary:[jsonData objectForKey:@"returnObj"]];
                
                self.productObj = productObj;
                if (self.delegate && [self.delegate respondsToSelector:@selector(editWQProductDetailVC:indexPath:)]) {
                    [self.delegate editWQProductDetailVC:self indexPath:self.indexPath];
                }
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [WQPopView showWithImageName:@"picker_alert_sigh" message:[jsonData objectForKey:@"msg"]];
            }
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:self.appDel.window.rootViewController.view animated:YES];
        upLoadImgCount = 0;
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"InterfaceError", @"")];
    }];
}

@end
