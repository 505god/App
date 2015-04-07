//
//  WQHotSaleCell.m
//  App
//
//  Created by 邱成西 on 15/3/31.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQHotSaleCell.h"

@interface WQHotSaleCell ()
//图片
@property (nonatomic, strong) UIImageView *proImage;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *saleLab;

@end

@implementation WQHotSaleCell

-(void)dealloc {
    SafeRelease(_proImage);
    SafeRelease(_priceLab);
    SafeRelease(_nameLab);
    SafeRelease(_saleLab);
    SafeRelease(_productObj);
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizesSubviews = YES;
        
        self.proImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.proImage.backgroundColor = [UIColor clearColor];
        self.proImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.proImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.proImage];
        
        self.priceLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.priceLab.backgroundColor = [UIColor clearColor];
        self.priceLab.textColor = COLOR(251, 0, 41, 1);
        self.priceLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.priceLab];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
        self.nameLab.numberOfLines = 2;
        self.nameLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.nameLab];
        
        self.saleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.saleLab.backgroundColor = [UIColor clearColor];
        self.saleLab.font = [UIFont systemFontOfSize:12];
        self.saleLab.textColor = [UIColor lightGrayColor];
        self.saleLab.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.saleLab];
    }
    
    return self;
}

-(void)setProductObj:(WQProductObj *)productObj {
    _productObj = productObj;
    
    [self.proImage setImageWithURL:[NSURL URLWithString:productObj.productImage] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    self.priceLab.text = productObj.productPrice;
    
    self.nameLab.text = productObj.productName;
    
    self.saleLab.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"HasSale", @""),productObj.productSaleCount];
    
    //未上架
    if (productObj.productIsSale==0) {
        self.proImage.layer.borderWidth = 1;
        self.proImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }else {
        self.proImage.layer.borderWidth = 0;
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //(60,60)
    self.proImage.frame = (CGRect){(self.contentView.width-60)/2,10,60,60};
    [Utility roundView:self.proImage];
    
    self.priceLab.frame = (CGRect){0,self.proImage.bottom+2,self.contentView.width,18};
    
    self.nameLab.frame = (CGRect){0,self.priceLab.bottom+2,self.contentView.width,28};
    
    self.saleLab.frame = (CGRect){0,self.nameLab.bottom+2,self.contentView.width,14};
}

-(void)prepareForReuse {
    [super prepareForReuse];
    
    self.priceLab.text = nil;
    self.proImage.layer.borderWidth = 0;
    self.proImage.image = nil;
    self.nameLab.text = nil;
    self.saleLab.text = nil;
    self.productObj = nil;
}
@end
