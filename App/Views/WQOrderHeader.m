//
//  WQOrderHeader.m
//  App
//
//  Created by 邱成西 on 15/4/16.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQOrderHeader.h"

@interface WQOrderHeader ()

@property (nonatomic, strong) UILabel *codeLab;
@property (nonatomic, strong) UILabel *customerLab;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *timeLab;

@property (nonatomic, strong) UIImageView *arrawImage;

@property (nonatomic, strong) UIImageView *lineView;
@end

@implementation WQOrderHeader

-(void)dealloc {
    SafeRelease(_codeLab);
    SafeRelease(_customerLab);
    SafeRelease(_priceLab);
    SafeRelease(_timeLab);
    SafeRelease(_arrawImage);
    SafeRelease(_lineView);
    SafeRelease(_orderObj);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.arrawImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.arrawImage.backgroundColor = [UIColor clearColor];
        [self addSubview:self.arrawImage];
        
        self.codeLab = [self returnLab];
        [self addSubview:self.codeLab];
        
        self.timeLab = [self returnLab];
        self.timeLab.font = [UIFont systemFontOfSize:14];
        self.timeLab.textColor = [UIColor lightGrayColor];
        [self addSubview:self.timeLab];
        
        self.priceLab = [self returnLab];
        [self addSubview:self.priceLab];
        
        self.customerLab = [self returnLab];
        self.customerLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.customerLab];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(UILabel *)returnLab {
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:15];
    return lab;
}


-(void)setOrderObj:(WQCustomerOrderObj *)orderObj {
    _orderObj = orderObj;
    
    self.codeLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderCode", @""),orderObj.orderCode];
    
    self.priceLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderPrice", @""),orderObj.orderPrice];
    NSString *priceString = [NSString stringWithFormat:@"%.2f",orderObj.orderPrice];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.priceLab.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251/255.0 green:0/255.0 blue:41/255.0 alpha:1] range:NSMakeRange(self.priceLab.text.length-priceString.length, priceString.length)];
    self.priceLab.attributedText = attributedString;
    SafeRelease(attributedString);
    SafeRelease(priceString);
    
    
    
    self.timeLab.text = [NSString stringWithFormat:@"%@",orderObj.orderTime];
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.arrawImage.image = isSelected?[UIImage imageNamed:@"headerDown"]:[UIImage imageNamed:@"headerUp"];
}

-(void)setASection:(NSInteger)aSection {
    _aSection = aSection;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.arrawImage.image = nil;
    self.customerLab.text = nil;
    self.orderObj = nil;
    self.codeLab.text = nil;
    self.priceLab.text = nil;
    self.timeLab.text = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.codeLab sizeToFit];
    [self.priceLab sizeToFit];
    [self.timeLab sizeToFit];
    
    self.codeLab.frame = (CGRect){10,(self.height-self.codeLab.height-self.priceLab.height-5)/2,self.codeLab.width,self.codeLab.height};
    
    self.priceLab.frame = (CGRect){10,self.codeLab.bottom+5,self.priceLab.width,self.priceLab.height};
    
    self.timeLab.frame = (CGRect){self.width-self.timeLab.width-40,(self.height-self.timeLab.height)/2,self.timeLab.width,self.timeLab.height};
    
    self.arrawImage.frame = (CGRect){self.width-30,(self.height-20)/2,20,20};
    
    self.lineView.frame = (CGRect){0,self.height-1,self.width,2};
}

@end
