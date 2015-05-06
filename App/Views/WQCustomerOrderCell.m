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

@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *saleLab;
@end

@implementation WQCustomerOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
        
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 4;
        
        self.priceLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.priceLab.backgroundColor = [UIColor clearColor];
        self.priceLab.font = [UIFont systemFontOfSize:15];
        self.priceLab.textColor = COLOR(251, 0, 41, 1);
        [self.contentView addSubview:self.priceLab];
        
        self.saleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.saleLab.backgroundColor = [UIColor clearColor];
        self.saleLab.textColor = [UIColor lightGrayColor];
        self.saleLab.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.saleLab];
        
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
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
    [self.saleLab sizeToFit];
    [self.priceLab sizeToFit];
    
    self.textLabel.frame = (CGRect){self.imageView.right+10,(self.contentView.height-self.textLabel.height-self.detailTextLabel.height)/2,self.textLabel.width,self.textLabel.height};
    
    self.detailTextLabel.frame = (CGRect){self.imageView.right+10,self.textLabel.bottom,self.detailTextLabel.width,self.detailTextLabel.height};
    
    CGFloat width = self.textLabel.right>=self.detailTextLabel.right?self.textLabel.right:self.detailTextLabel.right;
    
    self.saleLab.frame = (CGRect){width+20,(self.contentView.height-self.saleLab.height)/2,self.saleLab.width,self.saleLab.height};
    
    self.priceLab.frame = (CGRect){self.contentView.width-self.priceLab.width-10,(self.contentView.height-self.priceLab.height)/2,self.priceLab.width,self.priceLab.height};
    
    self.lineView.frame = (CGRect){self.imageView.left,self.contentView.height-1,self.contentView.width-self.imageView.left,2};
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
    self.saleLab.text = @"";
    self.detailTextLabel.text = @"";
    self.orderProductObj = nil;
    self.priceLab.text = @"";
}

-(void)setOrderProductObj:(WQCustomerOrderProObj *)orderProductObj {
    _orderProductObj = orderProductObj;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:orderProductObj.proImg] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    self.textLabel.text = [NSString stringWithFormat:@"%@",orderProductObj.proName];
    
    
    self.detailTextLabel.text = [NSString stringWithFormat:NSLocalizedString(@"ProNumber", @""),orderProductObj.proNumber];
    
    
    if (orderProductObj.proSaleType ==0) {
        self.saleLab.text = @"";
        self.priceLab.text = [NSString stringWithFormat:@"%.2f",orderProductObj.proPrice*orderProductObj.proNumber];
    }else if (orderProductObj.proSaleType ==1) {
        self.saleLab.text = [NSString stringWithFormat:@"%d%@",(int)(orderProductObj.proDiscount*10),NSLocalizedString(@"proDiscount", @"")];
        self.priceLab.text = [NSString stringWithFormat:@"%.2f",(orderProductObj.proPrice*orderProductObj.proDiscount)*orderProductObj.proNumber];
    }else if (orderProductObj.proSaleType ==2) {
        self.saleLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderSale", @""),orderProductObj.proNumber*orderProductObj.proReducePrice];
        self.priceLab.text = [NSString stringWithFormat:@"%.2f",(orderProductObj.proPrice-orderProductObj.proReducePrice)*orderProductObj.proNumber];
    }
}
@end
