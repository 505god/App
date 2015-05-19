//
//  WQCustomerOrderCell.m
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerOrderCell.h"

#import "WQTapImg.h"

@interface WQCustomerOrderCell ()<WQTapImgDelegate>

//订单
@property (nonatomic, strong) UILabel *codeLab;
@property (nonatomic, strong) UILabel *customerLab;
@property (nonatomic, strong) UIImageView *customerImg;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *timeLab;

//产品
@property (nonatomic, strong) WQTapImg *proImage;
@property (nonatomic, strong) UILabel *proNameLab;
@property (nonatomic, strong) UILabel *proPriceLab;
@property (nonatomic, strong) UILabel *proSaleLab;
@property (nonatomic, strong) UILabel *proTypeLab;

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) UIImageView *editGreyImageView;
@property (nonatomic, strong) UIImageView *editRedImageView;

@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;
@end

@implementation WQCustomerOrderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        //订单
        self.codeLab = [self returnLab];
        [self.contentView addSubview:self.codeLab];
        
        self.timeLab = [self returnLab];
        self.timeLab.font = [UIFont systemFontOfSize:12];
        self.timeLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.timeLab];
        
        self.priceLab = [self returnLab];
        [self.contentView addSubview:self.priceLab];
        
        self.customerLab = [self returnLab];
        self.customerLab.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.customerLab];
        
        self.customerImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.customerImg.image = [UIImage imageNamed:@"customer"];
        self.customerImg.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.customerImg];
        
        //产品
        self.proImage = [[WQTapImg alloc]initWithFrame:CGRectZero];
        self.proImage.delegate = self;
        self.proImage.layer.cornerRadius = 4;
        self.proImage.layer.masksToBounds = YES;
        self.proImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.proImage];
        
        self.proNameLab = [self returnLab];
        [self.contentView addSubview:self.proNameLab];
        
        self.proPriceLab = [self returnLab];
        [self.contentView addSubview:self.proPriceLab];
        
        self.proSaleLab = [self returnLab];
        [self.contentView addSubview:self.proSaleLab];
        
        self.proTypeLab = [self returnLab];
        [self.contentView addSubview:self.proTypeLab];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
    }
    return self;
}

-(UILabel *)returnLab {
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:15];
    return lab;
}

/*
 type:
 0=客户
 1=待处理
 2=待付款
 3=已完成
 */
-(void)setType:(NSInteger)type {
    _type = type;
    
    if (type ==0) {
        self.customerImg.hidden = YES;
        self.customerLab.hidden = YES;
    }else {
        self.customerImg.hidden = NO;
        self.customerLab.hidden = NO;
    }
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    [self.codeLab sizeToFit];
    [self.priceLab sizeToFit];
    [self.timeLab sizeToFit];
    [self.customerLab sizeToFit];
    
    self.codeLab.frame = (CGRect){10,5,self.codeLab.width,self.codeLab.height};

    self.customerImg.frame = (CGRect){10,self.codeLab.bottom+3,self.customerLab.height,self.customerLab.height};
    self.customerLab.frame = (CGRect){self.customerImg.right+5,self.codeLab.bottom+3,self.customerLab.width,self.customerLab.height};
    
    self.timeLab.frame = (CGRect){self.width-self.timeLab.width-10,self.codeLab.top,self.timeLab.width,self.timeLab.height};
    
    if (self.type==0) {
        self.priceLab.frame = (CGRect){10,self.codeLab.bottom+3,self.priceLab.width,self.priceLab.height};
    }else {
        self.priceLab.frame = (CGRect){self.customerLab.right+20,self.codeLab.bottom+3,self.priceLab.width,self.priceLab.height};
    }
    
    [self.proPriceLab sizeToFit];
    [self.proSaleLab sizeToFit];
    self.proImage.frame = (CGRect){10,self.priceLab.bottom+3,60,60};
    self.proNameLab.frame = (CGRect){self.proImage.right+10,self.proImage.top,self.width-self.proImage.right-15,18};
    self.proPriceLab.frame = (CGRect){self.proImage.right+10,self.proNameLab.bottom+3,self.proPriceLab.width,self.proPriceLab.height};
    self.proSaleLab.frame = (CGRect){self.proPriceLab.right+10,self.proNameLab.bottom+3,self.proSaleLab.width,self.proSaleLab.height};
    self.proTypeLab.frame = (CGRect){self.proImage.right+10,self.proPriceLab.bottom+3,self.width-self.proImage.right-15,18};
    
    self.lineView.frame = (CGRect){0,self.height-1,self.width,2};
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.codeLab.text = @"";
    self.customerLab.text = @"";
    self.priceLab.text = @"";
    self.orderObj = nil;
    self.timeLab.text = @"";
    self.proImage.image = nil;
    self.proNameLab.text = @"";
    self.proPriceLab.text = @"";
    self.proSaleLab.text = @"";
    self.proTypeLab.text = @"";
    
    [self cleanupBackView];
}

-(void)setOrderObj:(WQCustomerOrderObj *)orderObj {
    _orderObj = orderObj;
    
    self.codeLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderCode", @""),orderObj.orderId];
    
    self.priceLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderPrice", @""),orderObj.orderPrice];
    NSString *priceString = [NSString stringWithFormat:@"%.2f",orderObj.orderPrice];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.priceLab.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251/255.0 green:0/255.0 blue:41/255.0 alpha:1] range:NSMakeRange(self.priceLab.text.length-priceString.length, priceString.length)];
    self.priceLab.attributedText = attributedString;
    SafeRelease(attributedString);
    SafeRelease(priceString);
    
    self.timeLab.text = [NSString stringWithFormat:@"%@",orderObj.orderTime];
    
    self.customerLab.text = [Utility checkString:[NSString stringWithFormat:@"%@",orderObj.customerName]]?orderObj.customerName:@"";
    
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,orderObj.productImg]] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    self.proNameLab.text = orderObj.productName;
    
    self.proPriceLab.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"proprice", @""),orderObj.productPrice];
    
    if (orderObj.productSaleType ==0) {
        self.proSaleLab.text = @"";
    }else if (orderObj.productSaleType ==1) {
        self.proSaleLab.text = [NSString stringWithFormat:@"%d%@",(int)(orderObj.productDiscount),NSLocalizedString(@"proDiscount", @"")];
    }else if (orderObj.productSaleType ==2) {
        self.proSaleLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderSale", @""),orderObj.productReducePrice];
    }
    
    self.proTypeLab.text = [NSString stringWithFormat:NSLocalizedString(@"confirmSelectedPro", @""),orderObj.productColor,orderObj.productSize,orderObj.productNumber];
}

#pragma mark - property

-(UIImageView*)deleteGreyImageView {
    if (!_deleteGreyImageView) {
        _deleteGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame), (self.height-40)/2, 40, 40)];
        [_deleteGreyImageView setImage:[UIImage imageNamed:@"DeleteGrey"]];
        [_deleteGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_deleteGreyImageView];
    }
    return _deleteGreyImageView;
}

-(UIImageView*)deleteRedImageView {
    if (!_deleteRedImageView) {
        _deleteRedImageView = [[UIImageView alloc] initWithFrame:self.deleteGreyImageView.bounds];
        [_deleteRedImageView setImage:[UIImage imageNamed:@"DeleteRed"]];
        [_deleteRedImageView setContentMode:UIViewContentModeCenter];
        [self.deleteGreyImageView addSubview:_deleteRedImageView];
    }
    return _deleteRedImageView;
}

-(UIImageView*)editGreyImageView {
    if (!_editGreyImageView) {
        _editGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height-40)/2, 40, 40)];
        [_editGreyImageView setImage:[UIImage imageNamed:self.type==1?@"orderEditGrey":@"orderRemindGrey"]];
        [_editGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_editGreyImageView];
    }
    return _editGreyImageView;
}

-(UIImageView*)editRedImageView {
    if (!_editRedImageView) {
        _editRedImageView = [[UIImageView alloc] initWithFrame:self.editGreyImageView.bounds];
        [_editRedImageView setImage:[UIImage imageNamed:self.type==1?@"orderEditRed":@"orderRemindRed"]];
        [_editRedImageView setContentMode:UIViewContentModeCenter];
        [self.editGreyImageView addSubview:_editRedImageView];
    }
    return _editRedImageView;
}
-(void)cleanupBackView {
    [super cleanupBackView];
    [_deleteGreyImageView removeFromSuperview];
    _deleteGreyImageView = nil;
    [_deleteRedImageView removeFromSuperview];
    _deleteRedImageView = nil;
    [_editGreyImageView removeFromSuperview];
    _editGreyImageView = nil;
    [_editRedImageView removeFromSuperview];
    _editRedImageView = nil;
}

- (void)tappedWithObject:(id) sender {
    [Utility showImage:self.proImage];
}

#pragma mark -

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super animateContentViewForPoint:point velocity:velocity];
    
    CGFloat width = 50;
    
    if (point.x > 0) {
        [self.editGreyImageView setFrame:CGRectMake(MIN(CGRectGetMinX(self.contentView.frame) - self.editGreyImageView.width, 0), CGRectGetMinY(self.editGreyImageView.frame), self.editGreyImageView.width,self.editGreyImageView.height)];
        
        if (point.x >= width) {
            [self.editRedImageView setAlpha:1];
        }else {
            [self.editRedImageView setAlpha:0];
        }
    }else if (point.x < 0) {
        [self.deleteGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - self.deleteGreyImageView.width, CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.deleteGreyImageView.frame), self.deleteGreyImageView.width, self.deleteGreyImageView.height)];
        
        if (-point.x >= width) {
            [self.deleteRedImageView setAlpha:1];
        } else {
            [self.deleteRedImageView setAlpha:0];
        }
    }
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super resetCellFromPoint:point velocity:velocity];
    if (point.x > 0) {
        if (point.x <= self.contentView.height) {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.editGreyImageView setFrame:CGRectMake(-CGRectGetWidth(self.editGreyImageView.frame), CGRectGetMinY(self.editGreyImageView.frame), CGRectGetWidth(self.editGreyImageView.frame), CGRectGetHeight(self.editGreyImageView.frame))];
                             }];
        }else {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.editGreyImageView.layer setTransform:CATransform3DMakeScale(2, 2, 2)];
                                 [self.editGreyImageView setAlpha:0];
                                 [self.editRedImageView.layer setTransform:CATransform3DMakeScale(2, 2, 2)];
                                 [self.editRedImageView setAlpha:0];
                             }];
        }
    }else if (point.x < 0) {
        if (-point.x <= self.contentView.height) {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.deleteGreyImageView setFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), CGRectGetMinY(self.deleteGreyImageView.frame), self.deleteGreyImageView.width, self.deleteGreyImageView.height)];
                             }];
        } else {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.deleteGreyImageView.layer setTransform:CATransform3DMakeScale(2, 2, 2)];
                                 [self.deleteGreyImageView setAlpha:0];
                                 [self.deleteRedImageView.layer setTransform:CATransform3DMakeScale(2, 2, 2)];
                                 [self.deleteRedImageView setAlpha:0];
                             }];
        }
    }
}

@end
