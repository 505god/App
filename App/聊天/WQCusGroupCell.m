//
//  WQCusGroupCell.m
//  App
//
//  Created by 邱成西 on 15/6/12.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCusGroupCell.h"
#import "WQCellSelectedBackground.h"

#import "WQStarView.h"

@interface WQCusGroupCell ()

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) WQStarView *starView;

@property (nonatomic, strong) UIImageView *accessView;

@end

@implementation WQCusGroupCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        

        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        self.starView = [[WQStarView alloc]initWithFrame:(CGRect){0,0,100,30} enable:NO];
        self.starView.enable = NO;
        self.starView.showNormal = YES;
        [self.contentView addSubview:self.starView];
        
        self.accessView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.accessView.contentMode = UIViewContentModeScaleAspectFit;
        [self.accessView setImage:[UIImage imageNamed:@"selectedNormal"]];
        [self.contentView addSubview:self.accessView];
        
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

-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = (CGRect){0,0,self.width,self.height};

    self.starView.frame = (CGRect){-5,(self.height-self.starView.height)/2,self.starView.width,self.starView.height};
    
    self.accessView.frame = (CGRect){self.contentView.width-30,(self.contentView.height-20)/2,20,20};
    
    self.lineView.frame = (CGRect){0,-1,self.contentView.width,2};
}

-(void)prepareForReuse {
    [super prepareForReuse];
}

-(void)setIdxPath:(NSIndexPath *)idxPath {
    _idxPath = idxPath;
    
    self.starView.starNumber = idxPath.row;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    if (isSelected) {
        [self.accessView setImage:[UIImage imageNamed:@"selectedAct"]];
    }else {
        [self.accessView setImage:[UIImage imageNamed:@"selectedNormal"]];
    }
}
@end
