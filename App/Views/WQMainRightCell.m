//
//  WQMainRightCell.m
//  App
//
//  Created by 邱成西 on 15/4/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQMainRightCell.h"
#import "WQCellSelectedBackground.h"

@interface WQMainRightCell ()


@end

@implementation WQMainRightCell

-(void)dealloc {
    SafeRelease(_headerImageView);
    SafeRelease(_titleLab);
    SafeRelease(_detailLab);
    SafeRelease(_lineView);
    SafeRelease(_directionImage);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.titleLab];
        
        self.detailLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.detailLab.backgroundColor = [UIColor clearColor];
        self.detailLab.font = [UIFont systemFontOfSize:15];
        self.detailLab.textColor = [UIColor lightGrayColor];
        self.detailLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.detailLab];
        
        self.directionImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.directionImage.image = [UIImage imageNamed:@"photo_check_selected"];
        [self.contentView addSubview:self.directionImage];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        self.headerImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.headerImageView.image = [UIImage imageNamed:@"assets_placeholder_picture"];
        self.headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headerImageView.layer.cornerRadius = 6;
        self.headerImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.headerImageView];
        
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

-(void)setHeaderImageViewImage:(NSString *)header {
    [self.headerImageView setImageWithURL:[NSURL URLWithString:header] placeholderImage:[UIImage imageNamed:@"assets_placeholder_picture"]];
}

//头像固定为60x60
-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLab.frame = (CGRect){10,(self.contentView.height-18)/2,120,18};
    
    self.directionImage.frame = (CGRect){self.contentView.width-30,(self.contentView.height-20)/2,20,20};
    
    self.detailLab.frame = (CGRect){self.titleLab.right,13,self.contentView.width-self.titleLab.width-50,18};
    
    self.lineView.frame = (CGRect){10,self.height-1,self.width-10,2};
    
    self.headerImageView.frame = (CGRect){self.directionImage.left-70,5,60,60};
    
    self.textLabel.frame = (CGRect){0,0,self.contentView.width,self.contentView.height};
}



@end