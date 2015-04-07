//
//  WQMainRightVC.m
//  App
//
//  Created by 邱成西 on 15/3/23.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMainRightVC.h"
#import "WQMainRightCell.h"
#import "JKImagePickerController.h"
#import "WQEditNameVC.h"

#import "WQClassVC.h"
#import "WQClassObj.h"

#import "WQColorVC.h"

#import "WQSizeVC.h"

#import "WQCoinVC.h"

@interface WQMainRightVC ()<UITableViewDataSource, UITableViewDelegate,WQNavBarViewDelegate,JKImagePickerControllerDelegate,WQEditNameVCDelegate>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation WQMainRightVC

#pragma mark - lifestyle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //导航栏
    self.navBarView.titleLab.text = NSLocalizedString(@"SettingVC", @"");
    [self.navBarView.rightBtn setHidden:YES];
    self.navBarView.isShowShadow = YES;
    [self.view addSubview:self.navBarView];
    
    [self.view addSubview:self.tableView];
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

#pragma mark - property

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:(CGRect){0,self.navBarView.height+10,self.view.width,self.view.height-self.navBarView.height-10} style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _tableView;
}
#pragma mark - tableView
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section==0) {
        return 0;
    }
    return 10;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 2;
    }else if (section==1) {
        return 4;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)_tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0 && indexPath.row==0) {
        return 70;
    }
    return NavgationHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * identifier = @"classCell";
    
    WQMainRightCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[WQMainRightCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    [cell.headerImageView setHidden:YES];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            [cell.headerImageView setHidden:NO];
            cell.titleLab.text = NSLocalizedString(@"Header", @"");
        }else if (indexPath.row==1) {
            cell.titleLab.text = NSLocalizedString(@"ShopName", @"");
            cell.detailLab.text = @"龙舞精神";
        }
    }else if (indexPath.section==1) {
        if (indexPath.row==0) {
            cell.titleLab.text = NSLocalizedString(@"ClassifySetup", @"");
        }else if (indexPath.row==1) {
            cell.titleLab.text = NSLocalizedString(@"ColorSetup", @"");
        }else if (indexPath.row==2) {
            cell.titleLab.text = NSLocalizedString(@"SizeSetup", @"");
        }else if (indexPath.row==3) {
            cell.titleLab.text = NSLocalizedString(@"CurrencySetup", @"");
        }
    }else {
        [cell.directionImage setHidden:YES];
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = NSLocalizedString(@"LogOut", @"");
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            __block JKImagePickerController *imagePicker = [[JKImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.allowsMultipleSelection = NO;
            imagePicker.minimumNumberOfSelection = 1;
            imagePicker.maximumNumberOfSelection = 1;
            [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:^{
                SafeRelease(imagePicker);
            }];
        }else if (indexPath.row==1) {
            __block WQEditNameVC *imagePicker = [[WQEditNameVC alloc]init];
            imagePicker.delegate = self;
            [self.view.window.rootViewController presentViewController:imagePicker animated:YES completion:^{
                SafeRelease(imagePicker);
            }];
        }
    }else if (indexPath.section==1) {
        if (indexPath.row==0) {
            WQClassVC *classVC = [[WQClassVC alloc]init];
            [self.navControl pushViewController:classVC animated:YES];
            SafeRelease(classVC);
        }else if (indexPath.row==1) {
            WQColorVC *colorVC = [[WQColorVC alloc]init];
//            colorVC.isPresentVC = YES;
//            colorVC.selectedList = [[NSMutableArray alloc]init];
//            [self.view.window.rootViewController presentViewController:colorVC animated:YES completion:^{
//            }];
            
            [self.navControl pushViewController:colorVC animated:YES];
            SafeRelease(colorVC);
        }else if (indexPath.row==2) {
            WQSizeVC *sizeVC = [[WQSizeVC alloc]init];
            [self.navControl pushViewController:sizeVC animated:YES];
            SafeRelease(sizeVC);
        }else if (indexPath.row==3) {
            WQCoinVC *coinVC = [[WQCoinVC alloc]init];
            [self.navControl pushViewController:coinVC animated:YES];
            SafeRelease(coinVC);
        }
    }else {
        
    }
}

#pragma mark - JKImagePickerControllerDelegate

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak typeof(self) weakSelf = self;
    JKAssets *asset = (JKAssets *)assets[0];
    __block UIImage *image = nil;
    ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
    [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
        if (asset) {
            UIImage *tempImg = [UIImage imageWithCGImage:asset.thumbnail];//157x157
            
            image = [Utility dealImageData:tempImg];//图片处理
            SafeRelease(tempImg);
        }
    } failureBlock:^(NSError *error) {
        [WQPopView showWithImageName:@"picker_alert_sigh" message:NSLocalizedString(@"PhotoSelectedError", @"")];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        //TODO:上传图片
        WQMainRightCell *cell = (WQMainRightCell *)[weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        cell.headerImageView.image = image;
        
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
    }];
}
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker {
    [imagePicker dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - WQEditNameVCDelegate
- (void)editNameVCDidChange:(WQEditNameVC *)editNameVC {
    WQMainRightCell *cell = (WQMainRightCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailLab.text = @"测试测试";
}
- (void)editNameVCDidCancel:(WQEditNameVC *)editNameVC {
    [editNameVC dismissViewControllerAnimated:YES completion:^{
    }];
}
@end