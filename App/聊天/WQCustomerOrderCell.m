//
//  WQCustomerOrderCell.m
//  App
//
//  Created by 邱成西 on 15/4/15.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerOrderCell.h"

#import "WQTapImg.h"
#import "RKNotificationHub.h"

@interface WQCustomerOrderCell ()<WQTapImgDelegate>

@property (nonatomic, strong) UIImageView *customerImg;
@property (nonatomic, strong) UILabel *customerLab;
//订单
@property (nonatomic, strong) UILabel *codeLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *lineView1;
//产品
@property (nonatomic, strong) WQTapImg *proImage;
@property (nonatomic, strong) UILabel *proNameLab;
@property (nonatomic, strong) UILabel *proPriceLab;
@property (nonatomic, strong) UILabel *proSaleLab;
@property (nonatomic, strong) UILabel *proTypeLab;
@property (nonatomic, strong) UIImageView *lineView2;
//总价
@property (nonatomic, strong) UILabel *priceLab;

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, strong) UIButton *alertBtn;
@property (nonatomic, strong) UIButton *editPriceBtn;
@property (nonatomic, strong) UIButton *deliveryBtn;
@property (nonatomic, strong) UIButton *receiveBtn;

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) RKNotificationHub *notificationHub;
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
        self.timeLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.timeLab];
        
        self.lineView1 = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView1.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView1];
        
        //产品
        self.proImage = [[WQTapImg alloc]initWithFrame:CGRectZero];
        self.proImage.delegate = self;
        self.proImage.clipsToBounds = YES;
        self.proImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.proImage];
        
        self.proNameLab = [self returnLab];
        self.proNameLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.proNameLab];
        
        self.proPriceLab = [self returnLab];
        self.proPriceLab.textColor = COLOR(251, 0, 41, 1);
        self.proPriceLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.proPriceLab];
        
        self.proSaleLab = [self returnLab];
        self.proSaleLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.proSaleLab];
        
        self.proTypeLab = [self returnLab];
        self.proTypeLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.proTypeLab];
        
        self.lineView2 = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView2.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView2];
        
        //总价
        self.priceLab = [self returnLab];
        self.priceLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.priceLab];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        self.notificationHub = [[RKNotificationHub alloc]initWithView:self.contentView];
        [self.notificationHub setCount:-1];
        
        self.customerImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.customerImg.image = [UIImage imageNamed:@"customer"];
        [self.contentView addSubview:self.customerImg];
        
        self.customerLab = [self returnLab];
        [self.contentView addSubview:self.customerLab];
    }
    return self;
}

-(UILabel *)returnLab {
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectZero];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:14];
    return lab;
}

/*
 type:
 * 全部 0
 * 待付款 1
 * 待发货 2
 * 待收货 3
 * 已完成 4
 * 客户 9
 */
-(void)setType:(NSInteger)type {
    _type = type;
    
    [self.customerImg setHidden:NO];
    [self.customerLab setHidden:NO];
    if (type==1) {
        [self.contentView addSubview:self.alertBtn];
        [self.contentView addSubview:self.editPriceBtn];
    }else if (type==2){
        [self.contentView addSubview:self.deliveryBtn];
    }else if (type==9) {
        [self.customerImg setHidden:YES];
        [self.customerLab setHidden:YES];
    }
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    [self.codeLab sizeToFit];
    [self.timeLab sizeToFit];
    [self.priceLab sizeToFit];
    self.codeLab.frame = (CGRect){10,20,self.codeLab.width,15};
    
    [self.notificationHub setCircleAtFrame:(CGRect){self.codeLab.right,self.codeLab.top-10,10,10}];
    
    self.lineView1.frame = (CGRect){10,self.codeLab.bottom+9,self.width-20,2};
    
    self.proImage.frame = (CGRect){10,self.lineView1.bottom+9,80,80};
    self.proNameLab.frame = (CGRect){self.proImage.right+10,self.proImage.top,self.width-self.proImage.right-20,15};
    self.proSaleLab.frame = (CGRect){self.proImage.right+10,self.proNameLab.bottom+5,self.width-self.proImage.right-20,15};
    self.proTypeLab.frame = (CGRect){self.proImage.right+10,self.proSaleLab.bottom+5,self.width-self.proImage.right-20,15};
    
    self.customerImg.frame = (CGRect){self.proImage.right+10,self.proTypeLab.bottom+5,15,15};
    self.customerLab.frame = (CGRect){self.customerImg.right+5,self.proTypeLab.bottom+5,self.width-self.customerImg.right-10,16};
    
    self.proPriceLab.frame = (CGRect){self.proImage.right+10,self.proImage.bottom,self.width-self.proImage.right-20,15};
    
    self.lineView2.frame = (CGRect){5,self.proPriceLab.bottom+5,self.width-10,2};
    
    self.timeLab.frame = (CGRect){10,self.lineView2.bottom+9,self.timeLab.width,16};
    self.priceLab.frame = (CGRect){self.width-self.priceLab.width-10,self.lineView2.bottom+9,self.priceLab.width,16};
    
    if (self.type==1) {
        self.alertBtn.frame = (CGRect){10,self.priceLab.bottom+10,120,30};
        self.editPriceBtn.frame = (CGRect){self.width-130,self.priceLab.bottom+10,120,30};
    }else if (self.type==2){
        self.deliveryBtn.frame = (CGRect){self.width-130,self.priceLab.bottom+10,120,30};
    }
    
    self.lineView.frame = (CGRect){0,self.height-1,self.width,2};
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.codeLab.text = @"";
    self.timeLab.text = @"";
    self.customerLab.text = @"";
    self.orderObj = nil;
    self.priceLab.text = @"";
    self.proImage.image = nil;
    self.proNameLab.text = @"";
    self.proPriceLab.text = @"";
    self.proSaleLab.text = @"";
    self.proTypeLab.text = @"";
    [self.notificationHub setCount:-1];
    [self.cancelBtn removeFromSuperview];
    [self.payBtn removeFromSuperview];
    [self.alertBtn removeFromSuperview];
    [self.editPriceBtn removeFromSuperview];
    [self.deliveryBtn removeFromSuperview];
    [self.receiveBtn removeFromSuperview];
    self.cancelBtn = nil;
    self.payBtn = nil;
    self.alertBtn = nil;
    self.editPriceBtn = nil;
    self.deliveryBtn = nil;
    self.receiveBtn = nil;
}

-(void)dealloc {
    SafeRelease(_cancelBtn);
    SafeRelease(_payBtn);
    SafeRelease(_alertBtn);
    SafeRelease(_receiveBtn);
    SafeRelease(_deliveryBtn);
    SafeRelease(_editPriceBtn);
    SafeRelease(_delegate)
    SafeRelease(_timeLab);
    SafeRelease(_codeLab);
    SafeRelease(_orderObj);
    SafeRelease(_priceLab);
    SafeRelease(_proImage.delegate);
    SafeRelease(_proImage);
    SafeRelease(_proNameLab);
    SafeRelease(_proPriceLab);
    SafeRelease(_proTypeLab);
    SafeRelease(_proSaleLab);
    SafeRelease(_indexPath);
    
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
-(void)setOrderObj:(WQCustomerOrderObj *)orderObj {
    _orderObj = orderObj;
    
    self.codeLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderCode", @""),orderObj.orderId];
    self.timeLab.text = [NSString stringWithFormat:@"%@",orderObj.orderTime];
    
    NSString *priceString = [NSString stringWithFormat:@"%@%.2f",[self returnMoneyWithType:orderObj.productMoneyType],orderObj.orderPrice];
    self.priceLab.text = [NSString stringWithFormat:@"%@ %@%.2f",NSLocalizedString(@"totalPrice", @""),[self returnMoneyWithType:orderObj.productMoneyType],orderObj.orderPrice];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.priceLab.text];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251/255.0 green:0/255.0 blue:41/255.0 alpha:1] range:NSMakeRange(self.priceLab.text.length-priceString.length, priceString.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, self.priceLab.text.length-priceString.length)];
    self.priceLab.attributedText = attributedString;
    SafeRelease(attributedString);
    SafeRelease(priceString);
    
    [self.proImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",Host,orderObj.productImg]] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    self.proNameLab.text = [NSString stringWithFormat:@"%@",orderObj.productName];
    
    self.proPriceLab.text = [NSString stringWithFormat:@"%@ %.2f",[self returnMoneyWithType:orderObj.productMoneyType],orderObj.productPrice];;
    
    if (orderObj.productSaleType ==0) {
        self.proSaleLab.text = @"";
    }else if (orderObj.productSaleType ==1) {
        self.proSaleLab.text = [NSString stringWithFormat:@"%@:%.2f",NSLocalizedString(@"saleDisCount", @""),orderObj.productReducePrice];
    }else if (orderObj.productSaleType ==2) {
        self.proSaleLab.text = [NSString stringWithFormat:NSLocalizedString(@"orderSale", @""),orderObj.productReducePrice];
    }
    
    self.proTypeLab.text = [NSString stringWithFormat:NSLocalizedString(@"confirmSelectedPro", @""),orderObj.productColor,orderObj.productSize,orderObj.productNumber];
    
    self.customerLab.text = orderObj.customerName;
    
    if (orderObj.remindDeliveryRedPoint==1 || orderObj.finishRedPoint==1) {
        [self.notificationHub setCount:0];
        [self.notificationHub bump];
    }else {
        [self.notificationHub setCount:-1];
    }
    
}

#pragma mark -
-(void)cancelOrder {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelOrderWithCell:orderObj:)]) {
        [self.delegate cancelOrderWithCell:self orderObj:self.orderObj];
    }
}

-(void)payOrder {
    if (self.delegate && [self.delegate respondsToSelector:@selector(payOrderWithCell:orderObj:)]) {
        [self.delegate payOrderWithCell:self orderObj:self.orderObj];
    }
}
-(void)editPriceOrder {
    if (self.delegate && [self.delegate respondsToSelector:@selector(editPriceOrderWithCell:orderObj:)]) {
        [self.delegate editPriceOrderWithCell:self orderObj:self.orderObj];
    }
}
-(void)alertOrder {
    if (self.delegate && [self.delegate respondsToSelector:@selector(alertOrderWithCell:orderObj:)]) {
        [self.delegate alertOrderWithCell:self orderObj:self.orderObj];
    }
}
-(void)deliveryOrder {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deliveryOrderWithCell:orderObj:)]) {
        [self.delegate deliveryOrderWithCell:self orderObj:self.orderObj];
    }
}
-(void)receiveOrder {
    if (self.delegate && [self.delegate respondsToSelector:@selector(receiveOrderWithCell:orderObj:)]) {
        [self.delegate receiveOrderWithCell:self orderObj:self.orderObj];
    }
}


#pragma mark - property

-(UIButton *)cancelBtn {
    if (!_cancelBtn) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn setTitle:NSLocalizedString(@"cancelOrder", @"") forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR(251, 0, 41, 1) forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:COLOR(244, 242, 242, 1) forState:UIControlStateHighlighted];
        [_cancelBtn setBackgroundColor:COLOR(244, 242, 242, 1)];
        [_cancelBtn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        _cancelBtn.layer.cornerRadius = 2;
        _cancelBtn.layer.masksToBounds = YES;
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _cancelBtn;
}
-(UIButton *)payBtn {
    if (!_payBtn) {
        _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payBtn setTitle:NSLocalizedString(@"payOrder", @"") forState:UIControlStateNormal];
        [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_payBtn setTitleColor:COLOR(244, 242, 242, 1) forState:UIControlStateHighlighted];
        [_payBtn setBackgroundColor:COLOR(251, 0, 41, 1)];
        
        [_payBtn addTarget:self action:@selector(payOrder) forControlEvents:UIControlEventTouchUpInside];
        _payBtn.layer.cornerRadius = 2;
        _payBtn.layer.masksToBounds = YES;
        _payBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _payBtn;
}
-(UIButton *)alertBtn {
    if (!_alertBtn) {
        _alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertBtn setTitle:NSLocalizedString(@"RemindOrder", @"") forState:UIControlStateNormal];
        [_alertBtn setTitleColor:COLOR(251, 0, 41, 1) forState:UIControlStateNormal];
        [_alertBtn setTitleColor:COLOR(244, 242, 242, 1) forState:UIControlStateHighlighted];
        [_alertBtn setBackgroundColor:COLOR(244, 242, 242, 1)];
        [_alertBtn addTarget:self action:@selector(alertOrder) forControlEvents:UIControlEventTouchUpInside];
        _alertBtn.layer.cornerRadius = 2;
        _alertBtn.layer.masksToBounds = YES;
        _alertBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _alertBtn;
}
-(UIButton *)editPriceBtn {
    if (!_editPriceBtn) {
        _editPriceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editPriceBtn setTitle:NSLocalizedString(@"changeOrder", @"") forState:UIControlStateNormal];
        [_editPriceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_editPriceBtn setTitleColor:COLOR(244, 242, 242, 1) forState:UIControlStateHighlighted];
        [_editPriceBtn setBackgroundColor:COLOR(251, 0, 41, 1)];
        [_editPriceBtn addTarget:self action:@selector(editPriceOrder) forControlEvents:UIControlEventTouchUpInside];
        _editPriceBtn.layer.cornerRadius = 2;
        _editPriceBtn.layer.masksToBounds = YES;
        _editPriceBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _editPriceBtn;
}
-(UIButton *)deliveryBtn {
    if (!_deliveryBtn) {
        _deliveryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deliveryBtn setTitle:NSLocalizedString(@"deliveryOrder", @"") forState:UIControlStateNormal];
        [_deliveryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_deliveryBtn setTitleColor:COLOR(244, 242, 242, 1) forState:UIControlStateHighlighted];
        [_deliveryBtn setBackgroundColor:COLOR(251, 0, 41, 1)];
        [_deliveryBtn addTarget:self action:@selector(deliveryOrder) forControlEvents:UIControlEventTouchUpInside];
        _deliveryBtn.layer.cornerRadius = 2;
        _deliveryBtn.layer.masksToBounds = YES;
        _deliveryBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _deliveryBtn;
}
-(UIButton *)receiveBtn {
    if (!_receiveBtn) {
        _receiveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_receiveBtn setTitle:NSLocalizedString(@"receiveOrder", @"") forState:UIControlStateNormal];
        [_receiveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_receiveBtn setTitleColor:COLOR(244, 242, 242, 1) forState:UIControlStateHighlighted];
        [_receiveBtn setBackgroundColor:COLOR(251, 0, 41, 1)];
        [_receiveBtn addTarget:self action:@selector(receiveOrder) forControlEvents:UIControlEventTouchUpInside];
        _receiveBtn.layer.cornerRadius = 2;
        _receiveBtn.layer.masksToBounds = YES;
        _receiveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _receiveBtn;
}

- (void)tappedWithObject:(id) sender {
    [Utility showImage:self.proImage];
}
@end
