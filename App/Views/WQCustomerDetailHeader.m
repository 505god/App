//
//  WQCustomerDetailHeader.m
//  App
//
//  Created by 邱成西 on 15/4/14.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerDetailHeader.h"
#import "UIImageView+Addition.h"
#import "WQStarView.h"

@interface WQCustomerDetailHeader ()

@property (nonatomic, strong) UIImageView *headerImage;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) WQStarView *starView;
@end

@implementation WQCustomerDetailHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.headerImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.headerImage.layer.cornerRadius = 4;
        self.headerImage.layer.masksToBounds = YES;
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.headerImage showLargeImage];
        [self addSubview:self.headerImage];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.nameLab];
        
        self.starView = [[WQStarView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.starView];
        
        self.contentView.backgroundColor = COLOR(235, 235, 241, 1);
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.headerImage.frame = (CGRect){10,(self.height-60)/2,60,60};
    
    [self.nameLab sizeToFit];
    self.nameLab.frame = (CGRect){self.headerImage.right+20,self.headerImage.top+10,self.nameLab.width,self.nameLab.height};
    
    self.starView.frame = (CGRect){self.headerImage.right+20,self.nameLab.bottom+5,120,20};
}

-(void)setCustomerObj:(WQCustomerObj *)customerObj {
    _customerObj = customerObj;
    
    [self.headerImage setImageWithURL:[NSURL URLWithString:customerObj.customerHeader] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    self.nameLab.text = customerObj.customerName;
}
@end
