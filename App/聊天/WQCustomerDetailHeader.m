//
//  WQCustomerDetailHeader.m
//  App
//
//  Created by 邱成西 on 15/4/14.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerDetailHeader.h"
#import "WQStarView.h"
#import "WQTapImg.h"

@interface WQCustomerDetailHeader ()<WQTapImgDelegate>

@property (nonatomic, strong) WQTapImg *headerImage;

@property (nonatomic, strong) UILabel *nameLab;

@property (nonatomic, strong) WQStarView *starView;

//屏蔽图片
@property (nonatomic, strong) UIImageView *shieldImg;
@end

@implementation WQCustomerDetailHeader

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.headerImage = [[WQTapImg alloc]initWithFrame:CGRectZero];
        self.headerImage.layer.cornerRadius = 4;
        self.headerImage.layer.masksToBounds = YES;
        self.headerImage.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImage.delegate = self;
        
        [self addSubview:self.headerImage];
        
        self.shieldImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.shieldImg.image = [UIImage imageNamed:@"shield"];
        [self.shieldImg setHidden:YES];
        [self addSubview:self.shieldImg];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.nameLab];
        
        self.starView = [[WQStarView alloc]initWithFrame:(CGRect){0,0,100,30} enable:NO];
        self.starView.enable = NO;
        self.starView.showNormal = YES;
        [self addSubview:self.starView];
        
        self.contentView.backgroundColor = COLOR(235, 235, 241, 1);
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.headerImage.frame = (CGRect){10,(self.height-60)/2,60,60};
    self.shieldImg.frame = (CGRect){self.headerImage.right-17,self.headerImage.bottom-17,15,15};
    
    [self.nameLab sizeToFit];
    self.nameLab.frame = (CGRect){self.headerImage.right+20,self.headerImage.top+10,self.nameLab.width,self.nameLab.height};
    
    self.starView.frame = (CGRect){self.headerImage.right-5,self.nameLab.bottom,self.starView.width,self.starView.height};
}

-(void)setCustomerObj:(WQCustomerObj *)customerObj {
    _customerObj = customerObj;
    
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,customerObj.customerHeader]] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    self.nameLab.text = customerObj.customerName;
    
    self.starView.starNumber = customerObj.customerDegree;
    
    if (customerObj.customerShield==0) {
        [self.shieldImg setHidden:YES];
    }else {
        [self.shieldImg setHidden:NO];
    }
}
- (void)tappedWithObject:(id) sender {
    [Utility showImage:self.headerImage];
}

@end
