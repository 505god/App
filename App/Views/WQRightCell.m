//
//  WQRightCell.m
//  App
//
//  Created by 邱成西 on 15/4/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQRightCell.h"
#import "WQCellSelectedBackground.h"

@implementation WQRightCell

-(void)dealloc {
    SafeRelease(_lineView);
    SafeRelease(_classObj);
    SafeRelease(_colorObj);
    SafeRelease(_sizeObj);
    SafeRelease(_titleLab);
    SafeRelease(_deleteGreyImageView);
    SafeRelease(_deleteRedImageView);
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLab];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
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

-(UIImageView*)deleteGreyImageView {
    if (!_deleteGreyImageView) {
        _deleteGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame), 0, self.contentView.height, self.contentView.height)];
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

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLab.frame = (CGRect){10,(self.contentView.height-18)/2,self.contentView.width-20,18};
    
    self.lineView.frame = (CGRect){10,self.height-1,self.width-10,2};
    
    self.textLabel.frame = (CGRect){0,0,self.contentView.width,self.contentView.height};
}

//分类
-(void)setClassObj:(WQClassObj *)classObj {
    _classObj = classObj;
    self.titleLab.text = [NSString stringWithFormat:@"%@  (%d)",classObj.className,classObj.productCount];
}

//颜色
-(void)setColorObj:(WQColorObj *)colorObj {
    _colorObj = colorObj;
    self.titleLab.text = [NSString stringWithFormat:@"%@  (%d)",colorObj.colorName,colorObj.productCount];
}

//尺码
-(void)setSizeObj:(WQSizeObj *)sizeObj {
    _sizeObj = sizeObj;
    self.titleLab.text = [NSString stringWithFormat:@"%@  (%d)",sizeObj.sizeName,sizeObj.productCount];
}


-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self cleanupBackView];
}
-(void)cleanupBackView {
    [super cleanupBackView];
    [_deleteGreyImageView removeFromSuperview];
    _deleteGreyImageView = nil;
    [_deleteRedImageView removeFromSuperview];
    _deleteRedImageView = nil;
}

#pragma mark - 

-(void)animateContentViewForPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super animateContentViewForPoint:point velocity:velocity];
    if (point.x < 0) {
        [self.deleteGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetMaxX(self.contentView.frame)), CGRectGetMinY(self.deleteGreyImageView.frame), CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetHeight(self.deleteGreyImageView.frame))];
        if (-point.x >= CGRectGetHeight(self.frame)) {
            [self.deleteRedImageView setAlpha:1];
        } else {
            [self.deleteRedImageView setAlpha:0];
        }
    }
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super resetCellFromPoint:point velocity:velocity];
    if (point.x < 0) {
        if (-point.x <= CGRectGetHeight(self.frame)) {
            [UIView animateWithDuration:self.animationDuration
                             animations:^{
                                 [self.deleteGreyImageView setFrame:CGRectMake(CGRectGetMaxX(self.frame), CGRectGetMinY(self.deleteGreyImageView.frame), CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetHeight(self.deleteGreyImageView.frame))];
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
