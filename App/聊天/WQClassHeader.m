//
//  WQClassHeader.m
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassHeader.h"

#import "WQStarView.h"

@interface WQClassHeader ()

@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *arrawImage;

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) WQStarView *starView;
@property (nonatomic, strong) UILabel *starCountLab;
@end

@implementation WQClassHeader
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        [self.contextMenuView addSubview:self.nameLab];
        
        self.arrawImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.arrawImage.backgroundColor = [UIColor clearColor];
        [self.contextMenuView addSubview:self.arrawImage];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contextMenuView addSubview:self.lineView];

        self.starView = [[WQStarView alloc]initWithFrame:(CGRect){0,0,100,30} enable:NO];
        self.starView.enable = NO;
        self.starView.showNormal = YES;
        self.starView.userInteractionEnabled = NO;
        [self.contextMenuView addSubview:self.starView];
        [self.starView setHidden:YES];
        
        self.starCountLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.starCountLab.backgroundColor = [UIColor clearColor];
        [self.contextMenuView addSubview:self.starCountLab];
        [self.starCountLab setHidden:YES];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.arrawImage.image = isSelected?[UIImage imageNamed:@"headerDown"]:[UIImage imageNamed:@"headerUp"];
}

-(void)setASection:(NSInteger)aSection {
    _aSection = aSection;
}

-(void)setClassObj:(WQClassObj *)classObj {
    _classObj = classObj;
    
    self.nameLab.text = [NSString stringWithFormat:@"%@  (%ld)",classObj.className,classObj.levelClassCount];
}

-(void)setCusGroupObj:(WQCusGroupObj *)cusGroupObj {
    if (cusGroupObj != nil) {
        [self.nameLab setHidden:YES];
        _cusGroupObj = cusGroupObj;
        
        [self.starView setHidden:NO];
        self.starView.starNumber = cusGroupObj.cusGroupId;
        
        [self.starCountLab setHidden:NO];
        self.starCountLab.text = [NSString stringWithFormat:@"(%ld)",cusGroupObj.cusArray.count];
    }
}


-(void)layoutSubviews {
    [super layoutSubviews];
   
    self.contextMenuView.frame = (CGRect){0,0,self.width,self.height};
    
    self.starView.frame = (CGRect){0,7,self.starView.width,self.starView.height};
    self.starCountLab.frame = (CGRect){self.starView.right-10,12,self.width-self.starView.right,20};
    
    self.nameLab.frame = (CGRect){10,12,self.width-20,20};
    self.arrawImage.frame = (CGRect){self.width-30,12,20,20};
    
    self.lineView.frame = (CGRect){0,self.height-1,self.width,2};
}

#pragma mark - property

-(UIImageView*)deleteGreyImageView {
    if (!_deleteGreyImageView) {
        _deleteGreyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contextMenuView.frame), (self.height-40)/2, 40, 40)];
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

-(void)prepareForReuse {
    [super prepareForReuse];
    self.arrawImage.image = nil;
    self.nameLab.text = @"";
    self.classObj = nil;
    self.cusGroupObj = nil;
    self.starCountLab.text = @"";
    [self.starView setHidden:YES];
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
        [self.deleteGreyImageView setFrame:CGRectMake(MAX(CGRectGetMaxX(self.frame) - CGRectGetWidth(self.deleteGreyImageView.frame), CGRectGetMaxX(self.contextMenuView.frame)), CGRectGetMinY(self.deleteGreyImageView.frame), self.deleteGreyImageView.width, self.deleteGreyImageView.height)];
        if (-point.x >= CGRectGetHeight(self.contextMenuView.frame)) {
            [self.deleteRedImageView setAlpha:1];
        } else {
            [self.deleteRedImageView setAlpha:0];
        }
    }
}

-(void)resetCellFromPoint:(CGPoint)point velocity:(CGPoint)velocity {
    [super resetCellFromPoint:point velocity:velocity];
    if (point.x < 0) {
        if (-point.x <= CGRectGetHeight(self.contextMenuView.frame)) {
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
