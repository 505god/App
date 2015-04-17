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

@property (nonatomic, strong) UIImageView *customerImg;

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
        [self.contextMenuView addSubview:self.arrawImage];
        
        self.codeLab = [self returnLab];
        [self.contextMenuView addSubview:self.codeLab];
        
        self.timeLab = [self returnLab];
        self.timeLab.font = [UIFont systemFontOfSize:12];
        self.timeLab.textColor = [UIColor lightGrayColor];
        [self.contextMenuView addSubview:self.timeLab];
        
        self.priceLab = [self returnLab];
        [self.contextMenuView addSubview:self.priceLab];
        
        self.customerLab = [self returnLab];
        self.customerLab.font = [UIFont systemFontOfSize:14];
        [self.contextMenuView addSubview:self.customerLab];
        
        self.customerImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.customerImg.image = [UIImage imageNamed:@"addProperty"];
        self.customerImg.backgroundColor = [UIColor clearColor];
        [self.contextMenuView addSubview:self.customerImg];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contextMenuView addSubview:self.lineView];
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
    
    self.customerLab.text = [Utility checkString:orderObj.customerName]?orderObj.customerName:@"";
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.arrawImage.image = isSelected?[UIImage imageNamed:@"headerDown"]:[UIImage imageNamed:@"headerUp"];
}

-(void)setASection:(NSInteger)aSection {
    _aSection = aSection;
}

-(void)setType:(NSInteger)type {
    _type = type;
    
    if (type ==0) {
        self.customerLab.hidden = YES;
    }else {
        self.customerLab.hidden = NO;
    }
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.arrawImage.image = nil;
    self.customerLab.text = nil;
    self.orderObj = nil;
    self.codeLab.text = nil;
    self.priceLab.text = nil;
    self.timeLab.text = nil;
    
    [self cleanupBackView];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.contextMenuView.frame = (CGRect){0,0,self.width,self.height};
    
    [self.codeLab sizeToFit];
    [self.priceLab sizeToFit];
    [self.timeLab sizeToFit];
    [self.customerLab sizeToFit];
    
    if (self.type==0) {
        self.codeLab.frame = (CGRect){10,(self.height-self.codeLab.height-self.priceLab.height-5)/2,self.codeLab.width,self.codeLab.height};
    }else {
        self.codeLab.frame = (CGRect){10,(self.height-self.codeLab.height-self.priceLab.height-self.customerLab.height-10)/2,self.codeLab.width,self.codeLab.height};
    }
    
    self.priceLab.frame = (CGRect){10,self.codeLab.bottom+5,self.priceLab.width,self.priceLab.height};
    
    self.customerLab.frame = (CGRect){10,self.priceLab.bottom+5,self.customerLab.width,self.customerLab.height};
    
    self.timeLab.frame = (CGRect){self.width-self.timeLab.width-10,self.codeLab.top,self.timeLab.width,self.timeLab.height};
    
    self.arrawImage.frame = (CGRect){self.width-30,self.timeLab.bottom+(self.height-self.timeLab.bottom-20)/2,20,20};
    
    self.lineView.frame = (CGRect){0,self.height-1,self.width,2};
}

#pragma mark - property

-(UIImageView*)deleteGreyImageView {
    if (!_deleteGreyImageView) {
        _deleteGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.frame), 0, self.height, self.height)];
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
        _editGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.height)];
        [_editGreyImageView setImage:[UIImage imageNamed:@"CheckmarkGrey"]];
        [_editGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_editGreyImageView];
    }
    return _editGreyImageView;
}

-(UIImageView*)editRedImageView {
    if (!_editRedImageView) {
        _editRedImageView = [[UIImageView alloc] initWithFrame:self.editGreyImageView.bounds];
        [_editRedImageView setImage:[UIImage imageNamed:@"CheckmarkGreen"]];
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


#pragma mark -

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super animateContentViewForPoint:point velocity:velocity];
    if (point.x > 0) {
        [self.editGreyImageView setFrame:CGRectMake(MIN(CGRectGetMinX(self.contextMenuView.frame) - self.editGreyImageView.width, 0), CGRectGetMinY(self.editGreyImageView.frame), self.editGreyImageView.width,self.editGreyImageView.height)];
        
        if (point.x >= self.contextMenuView.height) {
            [self.editRedImageView setAlpha:1];
        }else {
            [self.editRedImageView setAlpha:0];
        }
    }else if (point.x < 0) {
        [self.deleteGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - self.deleteGreyImageView.width, CGRectGetMaxX(self.contextMenuView.frame)), CGRectGetMinY(self.deleteGreyImageView.frame), self.deleteGreyImageView.width, self.deleteGreyImageView.height)];
        
        DLog(@"%f",MAX(CGRectGetMaxX(self.frame) - self.deleteGreyImageView.width, CGRectGetMaxX(self.contextMenuView.frame)));
        
        if (-point.x >= self.contextMenuView.height) {
            [self.deleteRedImageView setAlpha:1];
        } else {
            [self.deleteRedImageView setAlpha:0];
        }
    }
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super resetCellFromPoint:point velocity:velocity];
    if (point.x > 0) {
        if (point.x <= self.contextMenuView.height) {
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
        if (-point.x <= self.contextMenuView.height) {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.deleteGreyImageView setFrame:CGRectMake(CGRectGetMaxX(self.contextMenuView.frame), CGRectGetMinY(self.deleteGreyImageView.frame), self.deleteGreyImageView.width, self.deleteGreyImageView.height)];
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
