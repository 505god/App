//
//  WQClassCell.m
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassCell.h"

#import "WQCellSelectedBackground.h"
#import <QuartzCore/QuartzCore.h>

@interface WQClassCell ()

@property (nonatomic, strong) UIImageView *proImage;
@property (nonatomic, strong) UILabel *priceLab;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *saleLab;
@end

@implementation WQClassCell
-(void)dealloc {
    SafeRelease(_proImage);
    SafeRelease(_priceLab);
    SafeRelease(_nameLab);
    SafeRelease(_saleLab);
    SafeRelease(_productObj);
    
    SafeRelease(_hotSaleGreyImageView);
    SafeRelease(_hotSaleGreenImageView);
    SafeRelease(_hotSaleView);
    SafeRelease(_toSaleGreyImageView);
    SafeRelease(_toSaleRedImageView);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = COLOR(213, 213, 213, 1);
        
        self.proImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        self.proImage.backgroundColor = [UIColor clearColor];
        self.proImage.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.proImage.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.proImage];
        
        self.priceLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.priceLab.backgroundColor = [UIColor clearColor];
        self.priceLab.textColor = COLOR(251, 0, 41, 1);
        [self.contentView addSubview:self.priceLab];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nameLab];
        
        self.saleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.saleLab.backgroundColor = [UIColor clearColor];
        self.saleLab.font = [UIFont systemFontOfSize:12];
        self.saleLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.saleLab];
        
        self.hotSaleView = [[UIView alloc] initWithFrame:(CGRect){self.contentView.width,0,4,self.contentView.height}];
        self.hotSaleView.backgroundColor = COLOR(251, 0, 41, 1);
        self.hotSaleView.hidden = NO;
        [self.contentView addSubview:self.hotSaleView];
        
        
        WQCellSelectedBackground *selectedBackgroundView = [[WQCellSelectedBackground alloc] initWithFrame:CGRectZero];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor colorWithRed:220/255. green:220/255. blue:220/255. alpha:1] CGColor]];
        [self setSelectedBackgroundViewGradientColors:colors];
    }
    return self;
}

- (void)setSelectedBackgroundViewGradientColors:(NSArray*)colors {
    [(WQCellSelectedBackground*)self.selectedBackgroundView setSelectedBackgroundGradientColors:colors];
}

-(void)setProductObj:(WQProductObj *)productObj {
    _productObj = productObj;
    
    [self.proImage setImageWithURL:[NSURL URLWithString:productObj.productImage] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
    
    self.priceLab.text = productObj.productPrice;
    
    self.nameLab.text = productObj.productName;
    
    self.saleLab.text = [NSString stringWithFormat:@"%@%d",NSLocalizedString(@"HasSale", @""),productObj.productSaleCount];
    
    [self setIsHotSale:productObj.productIsHot];
    
    self.isToSale = productObj.productIsSale;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //(60,60)
    self.proImage.frame = (CGRect){10,5,60,60};
    [Utility roundView:self.proImage];
    
    self.priceLab.frame = (CGRect){self.proImage.right+10,8,self.contentView.width-80,18};
    
    self.nameLab.frame = (CGRect){self.proImage.right+10,self.priceLab.bottom+2,self.contentView.width-80,18};
    
    self.saleLab.frame = (CGRect){self.proImage.right+10,self.nameLab.bottom+2,self.contentView.width-80,14};
    
    self.hotSaleView.frame = self.isHotSale?(CGRect){self.contentView.width-4,0,4,self.contentView.height}:(CGRect){self.contentView.width,0,4,self.contentView.height};
}

#pragma mark - 

-(UIImageView*)hotSaleGreyImageView {
    if (!_hotSaleGreyImageView) {
        _hotSaleGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.height, self.contentView.height)];
        [_hotSaleGreyImageView setImage:[UIImage imageNamed:@"CheckmarkGrey"]];
        [_hotSaleGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_hotSaleGreyImageView];
    }
    return _hotSaleGreyImageView;
}

-(UIImageView*)hotSaleGreenImageView {
    if (!_hotSaleGreenImageView) {
        _hotSaleGreenImageView = [[UIImageView alloc] initWithFrame:self.hotSaleGreyImageView.bounds];
        [_hotSaleGreenImageView setImage:[UIImage imageNamed:@"CheckmarkGreen"]];
        [_hotSaleGreenImageView setContentMode:UIViewContentModeCenter];
        [self.hotSaleGreyImageView addSubview:_hotSaleGreenImageView];
    }
    return _hotSaleGreenImageView;
}

-(UIImageView*)toSaleGreyImageView {
    if (!_toSaleGreyImageView) {
        _toSaleGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), 0, self.contentView.height, self.contentView.height)];
        [_toSaleGreyImageView setImage:[UIImage imageNamed:@"DeleteGrey"]];
        [_toSaleGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_toSaleGreyImageView];
    }
    return _toSaleGreyImageView;
}

-(UIImageView*)toSaleRedImageView {
    if (!_toSaleRedImageView) {
        _toSaleRedImageView = [[UIImageView alloc] initWithFrame:self.toSaleGreyImageView.bounds];
        [_toSaleRedImageView setImage:[UIImage imageNamed:@"DeleteRed"]];
        [_toSaleRedImageView setContentMode:UIViewContentModeCenter];
        [self.toSaleGreyImageView addSubview:_toSaleRedImageView];
    }
    return _toSaleRedImageView;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    [self cleanupBackView];
}

-(void)cleanupBackView {
    [super cleanupBackView];
    [_hotSaleGreyImageView removeFromSuperview];
    _hotSaleGreyImageView = nil;
    [_hotSaleGreenImageView removeFromSuperview];
    _hotSaleGreenImageView = nil;
    [_toSaleGreyImageView removeFromSuperview];
    _toSaleGreyImageView = nil;
    [_toSaleRedImageView removeFromSuperview];
    _toSaleRedImageView = nil;
}

#pragma mark - 

-(void)setIsHotSale:(BOOL)isHotSale{
    _isHotSale = isHotSale;
    
    if (isHotSale) {
        [self.contentView bringSubviewToFront:self.hotSaleView];
        self.hotSaleView.hidden = NO;
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.hotSaleView.frame = (CGRect){self.contentView.width-4,0,4,self.contentView.height};
                         }];
    }else {
        [UIView animateWithDuration:0.25
                         animations:^{
                             self.hotSaleView.frame = (CGRect){self.contentView.width,0,4,self.contentView.height};
                         }completion:^(BOOL finished) {
                             self.hotSaleView.hidden = YES;
                         }];
    }
}

-(void)setIsToSale:(BOOL)isToSale {
    _isToSale = isToSale;
    
    if (isToSale) {
        [self.proImage.layer setBorderWidth:0];
    }else {
        [self.proImage.layer setBorderWidth:1];
        [self.proImage.layer setBorderColor:[UIColor darkGrayColor].CGColor];
    }
}

#pragma mark - 
-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super animateContentViewForPoint:point velocity:velocity];
    if (point.x > 0) {
        // set the checkmark's frame to match the contentView
        [self.hotSaleGreyImageView setFrame:CGRectMake(MIN(CGRectGetMinX(self.contentView.frame) - self.hotSaleGreyImageView.width, 0), CGRectGetMinY(self.hotSaleGreyImageView.frame), self.hotSaleGreyImageView.width, self.hotSaleGreyImageView.height)];
        if (point.x >= self.contentView.height && self.isHotSale == NO) {
            [self.hotSaleGreenImageView setAlpha:1];
        } else if (self.isHotSale == NO) {
            [self.hotSaleGreenImageView setAlpha:0];
        } else if (point.x >= self.contentView.height && self.isHotSale == YES) {
            // already a favourite; animate the green checkmark drop when swiped far enough for the action to kick in when user lets go
            if (self.hotSaleGreyImageView.alpha == 1) {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     CATransform3D rotate = CATransform3DMakeRotation(-0.4, 0, 0, 1);
                                     [self.hotSaleGreenImageView.layer setTransform:CATransform3DTranslate(rotate, -10, 20, 0)];
                                     [self.hotSaleGreenImageView setAlpha:0];
                                 }];
            }
        } else if (self.isHotSale == YES) {
            // already a favourite; but user panned back to a lower value than the action point
            CATransform3D rotate = CATransform3DMakeRotation(0, 0, 0, 1);
            [self.hotSaleGreenImageView.layer setTransform:CATransform3DTranslate(rotate, 0, 0, 0)];
            [self.hotSaleGreenImageView setAlpha:1];
        }
    } else if (point.x < 0) {
        [self.toSaleGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.contentView.frame) - self.toSaleGreyImageView.width, CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.toSaleGreyImageView.frame), self.toSaleGreyImageView.width, self.toSaleGreyImageView.height)];
        
        if ((0-point.x) >= self.contentView.height && self.isToSale == NO) {
            [self.toSaleRedImageView setAlpha:1];
        }else if (self.isToSale == NO) {
            [self.toSaleRedImageView setAlpha:0];
        } else if ((0-point.x) >= self.contentView.height && self.isToSale == YES) {
            if (self.toSaleRedImageView.alpha == 1) {
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     CATransform3D rotate = CATransform3DMakeRotation(-0.4, 0, 0, 1);
                                     [self.toSaleRedImageView.layer setTransform:CATransform3DTranslate(rotate, -10, 20, 0)];
                                     [self.toSaleRedImageView setAlpha:0];
                                 }];
            }
        }else if (self.isToSale == YES) {
            CATransform3D rotate = CATransform3DMakeRotation(0, 0, 1, 1);
            [self.toSaleRedImageView.layer setTransform:CATransform3DTranslate(rotate, 0, 0, 0)];
            [self.toSaleRedImageView setAlpha:1];
        }
    }
}

// user did not swipe far enough, animate the checkmark back with the contentView animation
-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super resetCellFromPoint:point velocity:velocity];
    if (point.x > 0 && point.x <= self.contentView.height) {
        [UIView animateWithDuration:self.animationDuration
                         animations:^{
                             [self.hotSaleGreyImageView setFrame:CGRectMake(-self.hotSaleGreyImageView.width, CGRectGetMinY(self.hotSaleGreyImageView.frame), self.hotSaleGreyImageView.width, self.hotSaleGreyImageView.height)];
                         }];
    } else if (point.x < 0 && (0-point.x) <= self.contentView.height) {
        
        [UIView animateWithDuration:self.animationDuration
                         animations:^{
                             [self.toSaleGreyImageView setFrame:CGRectMake(self.contentView.width, CGRectGetMinY(self.toSaleGreyImageView.frame), self.toSaleGreyImageView.width, self.toSaleGreyImageView.height)];
                         }];
    }
}

@end
