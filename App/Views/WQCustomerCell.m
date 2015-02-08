//
//  WQCustomerCell.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerCell.h"

#import "WQTapImg.h"
#import "WQStarView.h"
#import "UIView+Common.h"
#import "UIView+LayerEffects.h"

@interface WQCustomerCell ()<WQTapImgDelegate>

@property (nonatomic, weak) IBOutlet WQTapImg *headerImg;
@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet WQStarView *starV;

@property (nonatomic, weak) IBOutlet UILabel *phoneLab;

@end

@implementation WQCustomerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WQCustomerCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.headerImg.delegate = self;
        
        self.notificationHub = [[RKNotificationHub alloc]initWithView:self];
        [self.notificationHub setCircleAtFrame:(CGRect){50,2,20,20}];

        [self.headerImg setShadow:[UIColor blackColor] opacity:0.5 offset:CGSizeMake(1.0, 1.0) blurRadius:3];
        
        self.starV.enable = NO;
        self.starV.showNormal = NO;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.nameLab sizeToFit];
    self.starV.frame = (CGRect){self.nameLab.right-10,10,120,20};
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCustomerObj:(WQCustomerObj *)customerObj {
    if (_customerObj != customerObj) {
        _customerObj = nil;
        _customerObj = customerObj;
        
        self.nameLab.text = customerObj.customerName;
        self.phoneLab.text = customerObj.customerPhone;
        self.starV.starNumber = customerObj.customerDegree;
    }
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    [self.checkButton setSelected:isSelected];
}

-(IBAction)selectedCheckBtn:(id)sender {
    [self.checkButton setSelected:!self.checkButton.selected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedCustomer:animated:)]) {
        [self.delegate selectedCustomer:self.customerObj animated:self.checkButton.selected];
    }
}

//点击用户头像查看、编辑用户信息页面
- (void)tappedWithObject:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapCellWithCustomer:)]) {
        [self.delegate tapCellWithCustomer:self.customerObj];
    }
}
@end
