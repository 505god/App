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

#import "WQCustomerVC.h"

static WQProductImageCell *addProductImageCell = nil;

@interface WQNewProductVC ()<UITableViewDataSource, UITableViewDelegate,WQProductImageCellDelegate,JKImagePickerControllerDelegate,UITextFieldDelegate,WQProductPropertyCellDelegate,WQProductActionCellDelegate,WQCustomerVCDelegate>

@property (nonatomic, weak) IBOutlet UITableView *table;

//产品图片
@property (nonatomic, strong) NSMutableArray *imagesArray;
//产品属性
@property (nonatomic, strong) NSMutableArray *propertyArray;
//产品热卖
@property (nonatomic, assign) BOOL isHot;
//推荐客户列表
@property (nonatomic, strong) NSMutableArray *customerArray;


@property (nonatomic, assign) CGFloat keyboardHeight;
@end

@implementation WQNewProductVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"新增产品";
    
    NSString *nameStr = @"名称:";
    [self.propertyArray addObject:nameStr];
    
    NSString *priceStr = @"价格:";
    [self.propertyArray addObject:priceStr];
    
    NSString *stockStr = @"库存:";
    [self.propertyArray addObject:stockStr];
    
    NSString *detailStr = @"描述:";
    [self.propertyArray addObject:detailStr];
    
    NSString *customStr = @":";
    [self.propertyArray addObject:customStr];
    
    
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
    addBtn.frame = CGRectMake(0, 10, [UIScreen mainScreen].bounds.size.width, 44);
    [addBtn setBackgroundImage:[Utility imageFileNamed:@"navBar"] forState:UIControlStateNormal];
    [addBtn setTitle:@"完成创建" forState:UIControlStateNormal];
    [addBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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

-(NSMutableArray *)imagesArray {
    if (!_imagesArray) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

-(NSMutableArray *)propertyArray {
    if (!_propertyArray) {
        _propertyArray = [NSMutableArray array];
    }
    return _propertyArray;
}
#pragma mark - TableView Delegate and DataSource

//0:选择图片 1:属性 2:选择分类 3:推荐给客户 4:设置热卖   
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {//添加产品图片cell
        return 1;
    }else if (section==1) {//固定属性
        return self.propertyArray.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
        
    }else if (indexPath.section==1) {//添加产品属性
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
        
        
        if (indexPath.row == self.propertyArray.count-1) {
            [cell setIsCouldExtend:YES];
        }
        
        [cell setIndexPath:indexPath];
        
        //数据
        NSString *string = self.propertyArray[indexPath.row];
        [cell setTextString:string];
        
        cell.delegate = self;
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"WQProductActionCell_cell";
    
    WQProductActionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[WQProductActionCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.section) {
        case 2:
            cell.titleLab.text = @"设置分类";
            break;
        case 3:
            cell.titleLab.text = @"推荐给客户";
            break;
        case 4:
            cell.titleLab.text = @"设置热卖";
            cell.imgView.hidden = YES;
            cell.switchBtn.hidden = NO;
            cell.infoLab.hidden = YES;
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {//添加产品图片cell
        return 110;
    }else
        return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 2) {//设置分类
        
    }else if (indexPath.section == 3) {//推荐客户
        
        WQCustomerVC *customerVC = LOADVC(@"WQCustomerVC");
        customerVC.isPresentVC = YES;
        customerVC.selectedList = self.customerArray;
        customerVC.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:customerVC];
        [self presentViewController:navigationController animated:YES completion:^{
            
        }];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==1) {
        if (indexPath.row>2 && indexPath.row!=self.propertyArray.count-1) {
            return YES;
        }
    }
    
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.propertyArray removeObjectAtIndex:indexPath.row];

        [self.table deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
#pragma mark - 添加产品图片代理

-(void)addNewProductWithCell:(WQProductImageCell *)cell {
    addProductImageCell = cell;
    
    JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.showsCancelButton = YES;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.minimumNumberOfSelection = 1;
    imagePickerController.maximumNumberOfSelection = AddProductImagesMax;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];
}

-(void)addNewProductImage:(UIImage *)image {
    [self.imagesArray addObject:image];
}

-(void)removeProductImage:(UIImage *)image {
    [self.imagesArray removeObject:image];
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source {

    __block NSMutableArray *tempArray = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            JKAssets *set = (JKAssets *)obj;
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:set.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIImage *tempImg = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    
                    UIImage *image = [weakSelf dealImage:tempImg];
                    
                    [tempArray addObject:image];
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }];
    });
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        if (tempArray.count>0) {
            
            [addProductImageCell addProductImages:tempArray];
        }
        
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
        
        if (text.tag<1000) {
            WQProductText *textInfo = (WQProductText *)[cell.contentView viewWithTag:1000];
        
            string = [NSString stringWithFormat:@"%@:%@",text.text,textInfo.text];
        }else {
            WQProductText *textTitle = (WQProductText *)[cell.contentView viewWithTag:100];
            string = [NSString stringWithFormat:@"%@:%@",textTitle.text,text.text];
        }
        
        [self.propertyArray replaceObjectAtIndex:text.idxPath.row withObject:string];
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
    
    //输入字符个数限制
    NSInteger kMaxLength = 0;
    if (text.idxPath.row==1) {
        kMaxLength = 10;
    }else if (text.idxPath.row==2) {
        kMaxLength = 20;
    }else {
        kMaxLength = 5;
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
    
    self.customerArray = [NSMutableArray arrayWithArray:customers];
    
    [customerVC dismissViewControllerAnimated:YES completion:^{
        WQProductActionCell *cell = (WQProductActionCell *)[self.table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3]];
        
        cell.infoLab.text = self.customerArray.count==0?@"":[NSString stringWithFormat:@"已选择%d位客户",self.customerArray.count];
    }];
}
- (void)customerVCDidCancel:(WQCustomerVC *)customerVC {
    [customerVC dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
