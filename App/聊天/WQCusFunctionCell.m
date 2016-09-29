//
//  WQCusFunctionCell.m
//  App
//
//  Created by 邱成西 on 15/6/12.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCusFunctionCell.h"
#import "WQCellSelectedBackground.h"

@interface WQCusFunctionCell ()

@property (nonatomic, strong) UIImageView *lineView;

@end

@implementation WQCusFunctionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.textColor = [UIColor blackColor];
        
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



-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    self.textLabel.frame = (CGRect){0,(self.contentView.height-24)/2,self.contentView.width,24};
    
    self.lineView.frame = (CGRect){0,self.contentView.height-1,self.contentView.width,2};
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
}
@end
