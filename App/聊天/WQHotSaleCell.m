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

@property (nonatomic, strong) UIImageView *lineImg;
@property (nonatomic, strong) UIImageView *lineImg2;
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
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        
        self.proImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.proImage.backgroundColor = [UIColor clearColor];
        self.proImage.contentMode = UIViewContentModeScaleAspectFill;
        self.proImage.clipsToBounds = YES;
        [self.contentView addSubview:self.proImage];
        
        self.priceLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.priceLab.backgroundColor = [UIColor clearColor];
        self.priceLab.textColor = COLOR(251, 0, 41, 1);
        self.priceLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.priceLab];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.lineBreakMode = NSLineBreakByTruncatingTail;
        self.nameLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLab];
        
        self.saleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.saleLab.backgroundColor = [UIColor clearColor];
        self.saleLab.font = [UIFont systemFontOfSize:12];
        self.saleLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.saleLab];
        
        self.lineImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.lineImg.backgroundColor = [UIColor clearColor];
        self.lineImg.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineImg];
        
        self.lineImg2 = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.lineImg2.backgroundColor = [UIColor clearColor];
        self.lineImg2.image = [UIImage imageNamed:@"hLine"];
        [self.contentView addSubview:self.lineImg2];
    }
    
    return self;
}

-(NSString *)returnMoneyWithType:(NSInteger)type {
    if (type==0) {
        return @"￥";
    }else if (type==1) {
        return @"＄";
    }else if (type==2) {
        return @"€";
    }
    return @"＄";
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

-(void)setProductObj:(WQProductObj *)productObj {
    _productObj = productObj;
    
    NSArray *imgArray = [productObj.proImage componentsSeparatedByString:@"|"];
    
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,[imgArray firstObject]]] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    //￥ ＄ €
    self.priceLab.text = [NSString stringWithFormat:@"%@ %@",[self returnMoneyWithType:productObj.moneyType],productObj.proPrice];
    
    self.nameLab.text = productObj.proName;

    self.saleLab.text = [NSString stringWithFormat:@"%@:%d",NSLocalizedString(@"HasSale", @""),productObj.proSaleCount];
    
    //未上架
    if (productObj.proIsSale==0) {
        self.proImage.layer.borderWidth = 1;
        self.proImage.layer.borderColor = [UIColor darkGrayColor].CGColor;
    }else {
        self.proImage.layer.borderWidth = 0;
    }
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    self.lineImg2.frame = (CGRect){self.width-1,0,2,self.height};
    self.lineImg.frame = (CGRect){0,self.height-1,self.width,2};
    
    if (self.indexPath.item%2==0) {
        [self.lineImg2 setHidden:NO];
    }else {
        [self.lineImg2 setHidden:YES];
    }
    
    self.proImage.frame = (CGRect){5,5,self.width-10,self.width-10};
    
    self.nameLab.frame = (CGRect){5,self.proImage.bottom+5,self.width-10,18};
    
    self.priceLab.frame = (CGRect){5,self.nameLab.bottom+5,self.width-10,15};

    self.saleLab.frame = (CGRect){5,self.priceLab.bottom+5,self.width-10,12};
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
