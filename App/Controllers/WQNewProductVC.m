//
//  WQNewProductVC.m
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//


#import "WQNewProductVC.h"

#import "WQProductImageCell.h" //添加产品图片cell

#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "WQProductPropertyCell.h"//产品属性cell

#import "WQProductActionCell.h"//其他

#import "WQProductColorCell.h"//颜色和库存

#import "WQCustomerVC.h"

#import "WQColorVC.h"

/*
 手动：
 编码、价格、描述
 
 
 选择：
 
 规格
 一个 一件 一套 一双
 前面的一是输入的，后面的是选择
 
 
 材质、颜色、尺码、分类、包装规格、适用性别
 */


static WQProductColorCell *addProductImageCell = nil;

@interface WQNewProductVC ()<UITableViewDataSource, UITableViewDelegate,WQProductImageCellDelegate,JKImagePickerControllerDelegate,UITextFieldDelegate,WQProductPropertyCellDelegate,WQProductActionCellDelegate,WQCustomerVCDelegate,WQColorVCDelegate,WQProductColorCellDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;

//产品固定属性
@property (nonatomic, strong) NSMutableArray *propertyArray;
//产品热卖
@property (nonatomic, assign) BOOL isHot;
//推荐客户列表
@property (nonatomic, strong) NSMutableArray *customerArray;
//颜色与库存
@property (nonatomic, strong) NSMutableArray *colorArray;
//尺码
@property (nonatomic, strong) NSMutableArray *sizeArray;
//自定义属性
@property (nonatomic, strong) NSMutableArray *customPropertyArray;

@property (nonatomic, assign) CGFloat keyboardHeight;
@end

@implementation WQNewProductVC

//固定属性:编码、价格、描述
-(void)initPropertys {
    NSString *codeStr = @"产品编号:";
    [self.propertyArray addObject:codeStr];
    
    NSString *priceStr = @"价格:";
    [self.propertyArray addObject:priceStr];
    
    NSString *detailStr = @"描述:";
    [self.propertyArray addObject:detailStr];
}
//尺码
-(void)initSizes {
    NSString *sizeStr = @"设置尺码";
    [self.sizeArray addObject:sizeStr];
}

//客户
-(void)initCustomers {
    NSString *customerStr = @"设置推荐客户";
    [self.customerArray addObject:customerStr];
}

//自定义属性
-(void)initCustomPropertys {
    NSString *customStr = @"添加属性";
    [self.customPropertyArray addObject:customStr];
}
#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增产品";
    
    [self initPropertys];
    
    [self initFooterView];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置创建按钮

-(void)initFooterView {
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 54)];
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(20, 10, [UIScreen mainScreen].bounds.size.width-40, 44);
    [addBtn setTitle:@"完成创建" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    addBtn.layer.cornerRadius = 4;
    addBtn.layer.masksToBounds = YES;
    [addBtn setBackgroundColor:COLOR(57, 164, 247, 1)];
    [addBtn addTarget:self action:@selector(creatProduct:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:addBtn];
    self.table.tableFooterView = footerView;
    footerView=nil;
}

-(void)creatProduct:(id)sender {
    
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
                         CGRect frame = self.table.frame;
                         frame.size.height += self.keyboardHeight;
                         frame.size.height -= keyboardRect.size.height;
                         self.table.frame = frame;
                         
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
                         CGRect frame = self.table.frame;
                         frame.size.height += self.keyboardHeight;
                         self.table.frame = frame;
                         self.keyboardHeight = 0;
                     }];
}

- (void)scrollToIndex:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self.table scrollToRowAtIndexPath:indexPath
                      atScrollPosition:UITableViewScrollPositionBottom
                              animated:animated];
}
#pragma mark - property

-(NSMutableArray *)colorArray {
    if (!_colorArray) {
        _colorArray = [NSMutableArray array];
    }
    return _colorArray;
}

-(NSMutableArray *)sizeArray {
    if (!_sizeArray) {
        _sizeArray = [NSMutableArray array];
    }
    return _sizeArray;
}

-(NSMutableArray *)propertyArray {
    if (!_propertyArray) {
        _propertyArray = [NSMutableArray array];
    }
    return _propertyArray;
}

-(NSMutableArray *)customerArray {
    if (!_customerArray) {
        _customerArray = [NSMutableArray array];
    }
    return _customerArray;
}

-(NSMutableArray *)customPropertyArray {
    if (!_customPropertyArray) {
        _customPropertyArray = [NSMutableArray array];
    }
    return _customPropertyArray;
}
#pragma mark - TableView Delegate and DataSource
// 材质 包装规格  适用性别
// 0:固定属性 1:颜色与库存 2:尺码 3:客户 4:设置热卖 5:自定义属性
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {//固定属性
        return self.propertyArray.count;
    }else if (section==1) {//固定属性
        return self.colorArray.count+1;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
    if (indexPath.section==0) {//添加产品图片cell
        static NSString *CellIdentifier = @"WQProductImageCell_cell";
        
        WQProductImageCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[WQProductImageCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        //TODO:编辑状态下
//        NSMutableArray *array = [NSMutableArray arrayWithCapacity:5];
//        for (int i=0; i<4; i++) {
//            [array addObject:@"test"];
//        }
//        
//        [cell setImages:array];
        
        cell.delegate = self;
        return cell;
        
    }else
        */
    if (indexPath.section==0) {//添加产品属性
        static NSString *CellIdentifier = @"WQProductPropertyCell_cell";
        
        WQProductPropertyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[WQProductPropertyCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        //代理
        cell.infoTextField.delegate = self;
        cell.titleTextField.delegate = self;
        
        [cell setIndexPath:indexPath];
        
        //数据
        NSString *string = self.propertyArray[indexPath.row];
        [cell setTextString:string];
        
        cell.delegate = self;
        
        return cell;
    }else if (indexPath.section==1) {
        static NSString *CellIdentifier = @"WQProductColorCell_cell";
        
        WQProductColorCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            cell = [[WQProductColorCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:CellIdentifier];
        }
        
        if (indexPath.row==0) {
            cell.textLabel.text = @"设置颜色和库存";
            [cell.stockTxt setHidden:YES];
            cell.productImgView.hidden = YES;
        }else {
            [cell setIndexPath:indexPath];
            cell.stockTxt.delegate = self;
            WQColorObj *color = (WQColorObj *)self.colorArray[indexPath.row-1];
            [cell setColorObj:color];
            cell.delegate = self;
            cell.directionImg.hidden = YES;
            [cell.stockTxt setHidden:NO];
            cell.productImgView.hidden = NO;
        }
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"WQProductActionCell_cell";
    
    WQProductActionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[WQProductActionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
    }
    
   // cell setin
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {//添加产品图片cell
        return 40;
    }else if(indexPath.section==1){
        if (indexPath.row==0) {
            return 40;
        }
        return 60;
    }
        return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {//设置颜色
        WQColorVC *colorVC = LOADVC(@"WQColorVC");
        colorVC.isPresentVC = YES;
        colorVC.selectedList = self.colorArray;
        colorVC.delegate = self;
        [self.navigationController pushViewController:colorVC animated:YES];
        SafeRelease(colorVC);
        
    }else if (indexPath.section == 3) {//推荐客户
        NSMutableArray *tempArray = self.customerArray;
        [tempArray removeObjectAtIndex:0];
        
        WQCustomerVC *customerVC = LOADVC(@"WQCustomerVC");
        customerVC.isPresentVC = YES;
        customerVC.selectedList = tempArray;
        customerVC.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:customerVC];
        [navigationController.view setBackgroundColor:[UIColor lightGrayColor]];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
        SafeRelease(tempArray);
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1) {
        if (indexPath.row>0) {
            return YES;
        }
    }
    
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==1) {
        [self.colorArray removeObjectAtIndex:indexPath.row];
        
        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
#pragma mark - 添加产品图片代理


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

        
        WQProductPropertyCell *cell = (WQProductPropertyCell *)[self.table cellForRowAtIndexPath:text.idxPath];
        
        NSString *string = nil;
        
        if (text.idxPath.section==0) {//固定属性
            if (text.tag<1000) {
                WQProductText *textInfo = (WQProductText *)[cell.contentView viewWithTag:1000];
                
                string = [NSString stringWithFormat:@"%@:%@",text.text,textInfo.text];
            }else {
                WQProductText *textTitle = (WQProductText *)[cell.contentView viewWithTag:100];
                string = [NSString stringWithFormat:@"%@:%@",textTitle.text,text.text];
            }
            [self.propertyArray replaceObjectAtIndex:text.idxPath.row withObject:string];
            
            DLog(@"%@",self.propertyArray);
        }else if (text.idxPath.section==1){//颜色和库存
            WQColorObj *color = (WQColorObj *)self.colorArray[text.idxPath.row-1];
            color.stockCount = [text.text integerValue];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isKindOfClass:[WQProductText class]]) {
        WQProductText *text = (WQProductText *)textField;
        
        if (text.tag<1000) {
            WQProductPropertyCell *cell = (WQProductPropertyCell *)[self.table cellForRowAtIndexPath:text.idxPath];

            WQProductText *textInfo = (WQProductText *)[cell.contentView viewWithTag:1000];
            [textInfo becomeFirstResponder];
            
        }else {
            [textField resignFirstResponder];
        }
    }
    
    return YES;
}

-(void)textFieldDidChange:(NSNotification *)notification {
    WQProductText *text = (WQProductText *)notification.object;
    
    if (text.idxPath.section==0) {//固定属性
        //输入字符个数限制
        NSInteger kMaxLength = 100;
        if (text.idxPath.section==0 && text.idxPath.row==2) {
            kMaxLength = 20;
        }
        
        NSString *toBeString = text.text;
        
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage];
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入
            UITextRange *selectedRange = [text markedTextRange];
            UITextPosition *position = [text positionFromPosition:selectedRange.start offset:0];
            if (!position) {
                if (toBeString.length > kMaxLength) {
                    text.text = [toBeString substringToIndex:kMaxLength];
                }
            }
        }else {
            if (toBeString.length > kMaxLength) {
                text.text = [toBeString substringToIndex:kMaxLength];
            }
        }
    }
}
#pragma mark - WQProductPropertyCellDelegate
//添加自定义属性
-(void)addProperty:(WQProductPropertyCell *)cell {
    NSString *string = @":";
    [self.propertyArray addObject:string];
    
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - WQProductActionCellDelegate
//设置产品热卖状态
-(void)setProductHot:(BOOL)isHot {
    self.isHot = isHot;
    DLog(@"ishot = %d",isHot);
}

#pragma mark - WQCustomerVCDelegate
//选择客户
- (void)customerVC:(WQCustomerVC *)customerVC didSelectCustomers:(NSArray *)customers {
    
    NSString *str = self.customerArray[0];
    self.customerArray = nil;
    [self.customerArray addObject:str];
    [self.customerArray addObjectsFromArray:customers];
    
    [customerVC dismissViewControllerAnimated:YES completion:^{
        WQProductActionCell *cell = (WQProductActionCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        
        cell.infoLab.text = self.customerArray.count-1==0?@"":[NSString stringWithFormat:@"已选择%d位客户",self.customerArray.count];
    }];
}
- (void)customerVCDidCancel:(WQCustomerVC *)customerVC {
    [customerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark - WQCustomerVCDelegate
//选择颜色
- (void)colorVC:(WQColorVC *)colorVC didSelectColor:(NSArray *)colors {
    self.colorArray = [NSMutableArray arrayWithArray:colors];
    
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationAutomatic];
}
//添加图片
-(void)addProductImage:(WQProductColorCell *)cell {
    
    [self.view endEditing:YES];
    
    addProductImageCell = cell;
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = 1;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source {
    
    __block UIImage *image = nil;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        
        JKAssets *set = (JKAssets *)assets[0];
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        
        [lib assetForURL:set.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *tempImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                
                image = [weakSelf dealImage:tempImg];
                WQColorObj *color = (WQColorObj *)weakSelf.colorArray[addProductImageCell.indexPath.row-1];
                color.productImg = image;
            }
        } failureBlock:^(NSError *error) {
            
        }];
    });
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        addProductImageCell.productImgView.image = image;
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
    }];
}


-(UIImage *)dealImage:(UIImage *)image {
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    int maxFileSize = 200*1024;
    
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    
    while ([imageData length] > maxFileSize && compression > maxCompression)
    {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    return [UIImage imageWithData:imageData];
}
@end
