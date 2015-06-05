//
//  WQCustomerCell.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerCell.h"
#import "WQCellSelectedBackground.h"

@interface WQCustomerCell ()

@property (nonatomic, strong) UIImageView *accessView;


@property (nonatomic, strong) UIImageView *headerImg;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *phoneLab;

@property (nonatomic, strong) UIImageView *lineView;

//屏蔽图片
@property (nonatomic, strong) UIImageView *shieldImg;

@end

@implementation WQCustomerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.headerImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.headerImg.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImg.layer.cornerRadius = 4;
        self.headerImg.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImg];
        
        self.shieldImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.shieldImg.image = [UIImage imageNamed:@"shield"];
        [self.shieldImg setHidden:YES];
        [self.contentView addSubview:self.shieldImg];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        self.nameLab.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLab];
        
        self.phoneLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.phoneLab.backgroundColor = [UIColor clearColor];
        self.phoneLab.font = [UIFont systemFontOfSize:12];
        self.phoneLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.phoneLab];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        self.accessView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.accessView.contentMode = UIViewContentModeScaleAspectFit;
        [self.accessView setHidden:YES];
        [self.accessView setImage:[UIImage imageNamed:@"selectedNormal"]];
        [self.contentView addSubview:self.accessView];
        
        self.notificationHub = [[RKNotificationHub alloc]initWithView:self];
        [self.notificationHub setCount:-1];
        
        WQCellSelectedBackground *selectedBackgroundView = [[WQCellSelectedBackground alloc] initWithFrame:CGRectZero];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor colorWithRed:220/255. green:220/255. blue:220/255. alpha:1] CGColor]];
        [self setSelectedBackgroundViewGradientColors:colors];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setSelectedBackgroundViewGradientColors:(NSArray*)colors {
    [(WQCellSelectedBackground*)self.selectedBackgroundView setSelectedBackgroundGradientColors:colors];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    
    self.headerImg.frame = (CGRect){10,(self.contentView.height-40)/2,40,40};
    
    [self.notificationHub setCircleAtFrame:(CGRect){self.headerImg.right-5,self.headerImg.top-5,10,10}];
    
    self.shieldImg.frame = (CGRect){self.headerImg.right-12,self.headerImg.bottom-12,10,10};
    
    [self.nameLab sizeToFit];
    [self.phoneLab sizeToFit];
    
    self.nameLab.frame = (CGRect){self.headerImg.right+10,self.headerImg.top+(self.headerImg.height-self.nameLab.height-self.phoneLab.height)/3,self.nameLab.width,self.nameLab.height};
    
    
    self.phoneLab.frame = (CGRect){self.headerImg.right+10,self.nameLab.bottom+(self.headerImg.height-self.nameLab.height-self.phoneLab.height)/3,self.phoneLab.width,self.phoneLab.height};
    
    self.accessView.frame = (CGRect){self.contentView.width-40,(self.contentView.height-20)/2,20,20};
    
    self.lineView.frame = (CGRect){10,self.contentView.height-1,self.contentView.width-10,2};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setCustomerObj:(WQCustomerObj *)customerObj {
    _customerObj = customerObj;
    
    if ([Utility checkString:[NSString stringWithFormat:@"%@",customerObj.customerRemark]]) {
        if ([customerObj.customerRemark isEqualToString:customerObj.customerName]) {
            self.nameLab.text = customerObj.customerName;
        }else {
            self.nameLab.text = [NSString stringWithFormat:@"%@ (%@)",customerObj.customerName,customerObj.customerRemark];
        }
    }else {
        self.nameLab.text = customerObj.customerName;
    }
    
    self.phoneLab.text = customerObj.customerPhone;
    
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,customerObj.customerHeader]] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    if (customerObj.customerShield==0) {
        [self.shieldImg setHidden:YES];
    }else {
        [self.shieldImg setHidden:NO];
    }
    
    
    if ([[WQDataShare sharedService].messageArray containsObject:[NSString stringWithFormat:@"%d",customerObj.customerId]]) {
        [self.notificationHub setCount:0];
        [self.notificationHub bump];
    }else {
        [self.notificationHub setCount:-1];
    }
}


-(void)setSelectedType:(NSInteger)selectedType {
    _selectedType = selectedType;
    
    if (selectedType==0) {
        [self.accessView setHidden:YES];
    }else {
        [self.accessView setHidden:NO];
        if (selectedType==1) {
            [self.accessView setImage:[UIImage imageNamed:@"selectedNormal"]];
        }else {
            [self.accessView setImage:[UIImage imageNamed:@"selectedAct"]];
        }
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
    self.nameLab.text = @"";
    self.phoneLab.text = @"";
}
@end
