//
//  WQProAttributeWithImgCell.m
//  App
//
//  Created by 邱成西 on 15/4/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProAttributeWithImgCell.h"

#import "WQSizeObj.h"

#import "WQProductText.h"

#import "WQCreatProductVC.h"
#import "WQProductDetailVC.h"

@interface WQProAttributeWithImgCell ()<WQTapImgDelegate>

@property (nonatomic, strong) UIImageView *arrawImage;
@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) WQProductBtn *addBtn;
@end

@implementation WQProAttributeWithImgCell

///图片和颜色  60
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - private

-(void)setProductVC:(WQCreatProductVC *)productVC {
    _productVC = productVC;
}

-(void)setDetailVC:(WQProductDetailVC *)detailVC {
    _detailVC = detailVC;
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

-(void)setDictionary:(NSDictionary *)dictionary {
    _dictionary = dictionary;
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.contentView addSubview:self.colorBtn];
    [self.contentView addSubview:self.addBtn];
    [self.contentView addSubview:self.proImgView];
    [self.contentView addSubview:self.arrawImage];
    [self.contentView addSubview:self.lineView];
    ///商品图片
    if ([[dictionary objectForKey:@"image"]isKindOfClass:[UIImage class]] && [dictionary objectForKey:@"image"]!=nil) {
        UIImage *image = (UIImage *)[dictionary objectForKey:@"image"];
        self.proImgView.image = image;
    }else if (![[dictionary objectForKey:@"image"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"image"]!=nil){
        [self.proImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,[dictionary objectForKey:@"image"]]] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    }else {
        self.proImgView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
    }
    
    ///商品颜色
    if ([[dictionary objectForKey:@"color"] isKindOfClass:[WQColorObj class]] && [dictionary objectForKey:@"color"]!=nil) {
        WQColorObj *color = (WQColorObj *)[dictionary objectForKey:@"color"];
        self.colorObj = color;
        [self.colorBtn setTitle:color.colorName forState:UIControlStateNormal];
    }else {
        [self.colorBtn setTitle:NSLocalizedString(@"AddProductColor", @"") forState:UIControlStateNormal];
    }
    
    ///尺码、库存、价格
    CGFloat height = 60;
    NSArray *array = [dictionary objectForKey:@"property"];
    
    ///灰色背景
    UIView *customView = [[UIView alloc]initWithFrame:(CGRect){0,height,60,90*array.count}];
    customView.backgroundColor = COLOR(236, 236, 236, 1);
    [self.contentView addSubview:customView];
    SafeRelease(customView);
    
    for (int i=0; i<array.count; i++) {
        NSDictionary *aDic = (NSDictionary *)array[i];
        ///删除按钮  宽 60
        WQProductBtn *deleteBtn = [WQProductBtn buttonWithType:UIButtonTypeCustom];
        deleteBtn.frame = (CGRect){0,height+90*i+(90-60)/2,60,60};
        [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.idxPath = self.indexPath;
        deleteBtn.tag = i+DeleteBtnTag;
        [deleteBtn setImage:[UIImage imageNamed:@"DeleteRed"] forState:UIControlStateNormal];
        [self.contentView addSubview:deleteBtn];
        
        
        ///尺码
        UILabel *sizeLab = [self addLab:(CGRect){height,height+90*i+(30-20)/2,height,20}];
        sizeLab.text = [aDic objectForKey:@"sizeTitle"];
        [self.contentView addSubview:sizeLab];
        
        WQProductBtn *sizeBtn = [WQProductBtn buttonWithType:UIButtonTypeCustom];
        sizeBtn.frame = (CGRect){sizeLab.right+5,sizeLab.top,100,20};
        [sizeBtn setBackgroundColor:COLOR(236, 236, 236, 1)];
        [sizeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [sizeBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
        sizeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        if ([[aDic objectForKey:@"sizeDetail"]isKindOfClass:[WQSizeObj class]] && [aDic objectForKey:@"sizeDetail"]!=nil) {
            WQSizeObj *size = (WQSizeObj *)[aDic objectForKey:@"sizeDetail"];
            [sizeBtn setTitle:size.sizeName forState:UIControlStateNormal];
        }else {
            [sizeBtn setTitle:NSLocalizedString(@"SelectedProSize", @"") forState:UIControlStateNormal];
        }
        sizeBtn.tag = SizeTextFieldTag+i;
        sizeBtn.idxPath = self.indexPath;
        sizeBtn.layer.cornerRadius = 4;
        sizeBtn.layer.masksToBounds = YES;
        [sizeBtn addTarget:self action:@selector(selectProSize:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:sizeBtn];
        
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:(CGRect){sizeLab.right+5,height+90*i+29,[UIScreen mainScreen].bounds.size.width-sizeLab.right-10,2}];
        lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:lineView];
        
        ///价格
        UILabel *priceLab = [self addLab:(CGRect){height,height+90*i+(30-20)/2+30,height,20}];
        priceLab.text = [aDic objectForKey:@"priceTitle"];
        [self.contentView addSubview:priceLab];
        
        WQProductText *priceTxt = [self addText:(CGRect){priceLab.right+5,priceLab.top,[UIScreen mainScreen].bounds.size.width-priceLab.right-10,20}];
        priceTxt.text = [Utility checkString:[NSString stringWithFormat:@"%@",[aDic objectForKey:@"priceDetail"]]]?[NSString stringWithFormat:@"%@",[aDic objectForKey:@"priceDetail"]]:@"";
        priceTxt.idxPath = self.indexPath;
        priceTxt.tag = PriceTextFieldTag+i;
        if (self.productVC) {
            priceTxt.delegate = self.productVC;
        }else {
            priceTxt.delegate = self.detailVC;
        }
        
        priceTxt.returnKeyType = UIReturnKeyNext;
        priceTxt.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [self.contentView addSubview:priceTxt];
        
        UIImageView *lineView2 = [[UIImageView alloc]initWithFrame:(CGRect){priceLab.right+5,height+90*i+29+30,priceTxt.width,2}];
        lineView2.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:lineView2];
        
        ///库存
        UILabel *stockLab = [self addLab:(CGRect){height,height+90*i+(30-20)/2+30*2,height,20}];
        stockLab.text = [aDic objectForKey:@"stockTitle"];
        [self.contentView addSubview:stockLab];
        
        WQProductText *stockTxt = [self addText:(CGRect){stockLab.right+5,stockLab.top,[UIScreen mainScreen].bounds.size.width-stockLab.right-10,20}];
        stockTxt.text = [NSString stringWithFormat:@"%@",[aDic objectForKey:@"stockDetail"]];
        stockTxt.idxPath = self.indexPath;
        stockTxt.tag = StockTextFieldTag+i;
        if (self.productVC) {
            stockTxt.delegate = self.productVC;
        }else {
            stockTxt.delegate = self.detailVC;
        }
        stockTxt.returnKeyType = UIReturnKeyDone;
        stockTxt.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [self.contentView addSubview:stockTxt];
        
        UIImageView *lineView3 = [[UIImageView alloc]initWithFrame:(CGRect){0,height+90*i+29+30*2,[UIScreen mainScreen].bounds.size.width,2}];
        lineView3.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:lineView3];
        
        SafeRelease(stockTxt);
        SafeRelease(stockLab);
        SafeRelease(priceTxt);
        SafeRelease(priceLab);
        SafeRelease(sizeBtn);
        SafeRelease(sizeLab);
        SafeRelease(deleteBtn);
        SafeRelease(lineView);
        SafeRelease(lineView2);
        SafeRelease(lineView3);
    }
}

-(UILabel *)addLab:(CGRect)frame {
    UILabel *lab = [[UILabel alloc]initWithFrame:frame];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:15];
    
    return lab;
}

-(WQProductText *)addText:(CGRect)frame {
    WQProductText *text = [[WQProductText alloc] initWithFrame:frame];
    text.borderStyle = UITextBorderStyleNone;
    text.font = [UIFont systemFontOfSize:16];
    text.backgroundColor = [UIColor clearColor];
    return text;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.proImgView.frame = (CGRect){10,5,50,50};
    
    self.colorBtn.frame = (CGRect){self.proImgView.right+20,15,120,30};
    self.arrawImage.frame = (CGRect){self.contentView.width-32,20,20,20};
    self.lineView.frame = (CGRect){0,59,self.contentView.width,2};
    
    
    self.addBtn.frame = (CGRect){0,self.contentView.height-25,self.contentView.width,20};
}


-(void)prepareForReuse {
    [super prepareForReuse];
    self.proImgView.image = nil;
    self.colorObj = nil;
    self.colorBtn = nil;
    self.indexPath = nil;
    self.addBtn = nil;
    [self cleanupBackView];
}
-(void)cleanupBackView {
    [super cleanupBackView];
    [_deleteGreyImageView removeFromSuperview];
    _deleteGreyImageView = nil;
    [_deleteRedImageView removeFromSuperview];
    _deleteRedImageView = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setColorObj:(WQColorObj *)colorObj {
    _colorObj = colorObj;
    
    [self.colorBtn setTitle:colorObj.colorName forState:UIControlStateNormal];
}
#pragma mark -

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super animateContentViewForPoint:point velocity:velocity];
    if (point.x < 0) {
        [self.deleteGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - self.deleteGreyImageView.width, CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.deleteGreyImageView.frame), self.deleteGreyImageView.width, self.deleteGreyImageView.height)];
        if (-point.x >= 50) {
            [self.deleteRedImageView setAlpha:1];
        } else {
            [self.deleteRedImageView setAlpha:0];
        }
    }
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super resetCellFromPoint:point velocity:velocity];
    if (point.x < 0) {
        if (-point.x <= CGRectGetHeight(self.frame)) {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.deleteGreyImageView setFrame:CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.deleteGreyImageView.frame), self.deleteGreyImageView.width, self.deleteGreyImageView.height)];
                             }];
        } else {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.deleteGreyImageView.layer setTransform:CATransform3DMakeScale(2, 2, 2)];
                                 [self.deleteGreyImageView setAlpha:0];
                                 [self.deleteRedImageView.layer setTransform:CATransform3DMakeScale(2, 2, 2)];
                                 [self.deleteRedImageView setAlpha:0];
                             }];
        }
    }
}

#pragma mark -
///选择颜色
-(void)selectProColor:(id)sender {
    if (self.attributeWithImgDelegate && [self.attributeWithImgDelegate respondsToSelector:@selector(selectedProductColor:)]) {
        WQProductBtn *btn = (WQProductBtn *)sender;
        [self.attributeWithImgDelegate selectedProductColor:btn];
    }
}
///添加图片
- (void)tappedWithObject:(id)sender {
    if (self.attributeWithImgDelegate && [self.attributeWithImgDelegate respondsToSelector:@selector(selectedProductImage:)]) {
        [self.attributeWithImgDelegate selectedProductImage:self];
    }
}
///添加尺码
-(void)selectProSize:(id)sender {
    if (self.attributeWithImgDelegate && [self.attributeWithImgDelegate respondsToSelector:@selector(selectedProductSize:)]) {
        WQProductBtn *btn = (WQProductBtn *)sender;
        [self.attributeWithImgDelegate selectedProductSize:btn];
    }
}

///删除尺码、价格、库存
-(void)deleteBtnPressed:(id)sender {
    if (self.attributeWithImgDelegate && [self.attributeWithImgDelegate respondsToSelector:@selector(deleteProductSize:)]) {
        WQProductBtn *btn = (WQProductBtn *)sender;
        [self.attributeWithImgDelegate deleteProductSize:btn];
    }
}
///添加尺码、价格、库存
-(void)addMoreSize:(id)sender {
    if (self.attributeWithImgDelegate && [self.attributeWithImgDelegate respondsToSelector:@selector(addProductSize:)]) {
        WQProductBtn *btn = (WQProductBtn *)sender;
        [self.attributeWithImgDelegate addProductSize:btn];
    }
}

#pragma mark - property
-(UIImageView*)deleteGreyImageView {
    if (!_deleteGreyImageView) {
        _deleteGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), (self.height-40)/2, 40, 40)];
        [_deleteGreyImageView setImage:[UIImage imageNamed:@"DeleteGrey"]];
        [_deleteGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_deleteGreyImageView];
    }
    return _deleteGreyImageView;
}

-(UIImageView*)deleteRedImageView {
    if (!_deleteRedImageView) {
        _deleteRedImageView = [[UIImageView alloc] initWithFrame:self.deleteGreyImageView.bounds];
        [_deleteRedImageView setImage:[UIImage imageNamed:@"DeleteRed"]];
        [_deleteRedImageView setContentMode:UIViewContentModeCenter];
        [self.deleteGreyImageView addSubview:_deleteRedImageView];
    }
    return _deleteRedImageView;
}

-(WQTapImg *)proImgView {
    if (!_proImgView) {
        _proImgView= [[WQTapImg alloc]initWithFrame:CGRectZero];
        _proImgView.delegate = self;
        _proImgView.layer.cornerRadius = 6;
        _proImgView.layer.masksToBounds = YES;
        _proImgView.contentMode = UIViewContentModeScaleAspectFill;
        _proImgView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
    }
    return _proImgView;
}
-(WQProductBtn *)colorBtn {
    if (!_colorBtn) {
        _colorBtn = [WQProductBtn buttonWithType:UIButtonTypeCustom];
        [_colorBtn setBackgroundColor:COLOR(236, 236, 236, 1)];
        [_colorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_colorBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
        _colorBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_colorBtn setTitle:NSLocalizedString(@"AddProductColor", @"") forState:UIControlStateNormal];
        _colorBtn.idxPath = self.indexPath;
        _colorBtn.layer.cornerRadius = 4;
        _colorBtn.layer.masksToBounds = YES;
        [_colorBtn addTarget:self action:@selector(selectProColor:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _colorBtn;
}

-(UIImageView *)arrawImage {
    if (!_arrawImage) {
        _arrawImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        _arrawImage.backgroundColor = [UIColor clearColor];
        _arrawImage.image = [UIImage imageNamed:@"headerDown"];
    }
    return _arrawImage;
}
-(UIImageView *)lineView {
    if (!_lineView) {
        _lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _lineView.image = [UIImage imageNamed:@"line"];
    }
    return _lineView;
}
-(WQProductBtn *)addBtn {
    if (!_addBtn) {
        _addBtn = [WQProductBtn buttonWithType:UIButtonTypeCustom];
        [_addBtn setImage:[UIImage imageNamed:@"addProImg"] forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"addProImgNormal"] forState:UIControlStateHighlighted];
        _addBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_addBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_addBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateHighlighted];
        _addBtn.idxPath = self.indexPath;
        [_addBtn setTitleColor:COLOR(130, 134, 137, 1) forState:UIControlStateDisabled];
        [_addBtn addTarget:self action:@selector(addMoreSize:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}
@end
