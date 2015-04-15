//
//  WQCustomerOrderCell.m
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerOrderCell.h"

@interface WQCustomerOrderCell ()

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) UILabel *timeLab;
@end

@implementation WQCustomerOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont systemFontOfSize:16];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 4;
        
        self.timeLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.timeLab.backgroundColor = [UIColor clearColor];
        self.timeLab.font = [UIFont systemFontOfSize:12];
        self.timeLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.timeLab];
        
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = (CGRect){10,5,40,40};
    
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
    [self.timeLab sizeToFit];
    
    self.textLabel.frame = (CGRect){self.imageView.right+10,(self.contentView.height-self.textLabel.height-self.detailTextLabel.height)/2,self.textLabel.width,self.textLabel.height};
    
    self.detailTextLabel.frame = (CGRect){self.imageView.right+10,self.textLabel.bottom,self.detailTextLabel.width,self.detailTextLabel.height};
    
    self.timeLab.frame = (CGRect){self.contentView.width-self.timeLab.width-10,self.imageView.top,self.timeLab.width,self.timeLab.height};
    
    self.lineView.frame = (CGRect){self.imageView.left,self.contentView.height-1,self.contentView.width-self.imageView.left,2};
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
    self.timeLab.text = @"";
    self.detailTextLabel.text = @"";
}

-(void)setOrderObj:(WQCustomerOrderObj *)orderObj {
    _orderObj = orderObj;
    
    [self.imageView setImageWithURL:[NSURL URLWithString:orderObj.proImg] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    self.textLabel.text = [NSString stringWithFormat:@"%@",orderObj.proName];
    
    self.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ProNumber", @""),orderObj.proNumber];
    
    self.timeLab.text = [NSString stringWithFormat:@"%@",orderObj.orderTime];
}
@end
