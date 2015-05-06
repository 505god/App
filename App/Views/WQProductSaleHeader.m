//
//  WQProductSaleHeader.m
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductSaleHeader.h"

@interface WQProductSaleHeader ()

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) UIImageView *arrawImage;
@property (nonatomic, strong) UIImageView *lineView;
@end

@implementation WQProductSaleHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        [self.contextMenuView addSubview:self.nameLab];
        
        self.arrawImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.arrawImage.backgroundColor = [UIColor clearColor];
        [self.contextMenuView addSubview:self.arrawImage];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contextMenuView addSubview:self.lineView];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.arrawImage.image = isSelected?[UIImage imageNamed:@"selectedAct"]:[UIImage imageNamed:@"selectedNormal"];
}

-(void)setASection:(NSInteger)aSection {
    _aSection = aSection;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    self.contextMenuView.frame = (CGRect){0,0,self.width,self.height};
    
    [self.nameLab sizeToFit];
    self.nameLab.frame = (CGRect){10,(self.height-self.nameLab.height)/2,self.nameLab.width,self.nameLab.height};
    
    self.arrawImage.frame = (CGRect){self.width-30,12,20,20};
    
    self.lineView.frame = (CGRect){0,self.height-1,self.width,2};
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.arrawImage.image = nil;
    self.nameLab.text = nil;
}

-(void)setTextString:(NSString *)textString {
    _textString = textString;
    
    self.nameLab.text = textString;
}
@end
