//
//  WQCustomerDetailCell.m
//  App
//
//  Created by 邱成西 on 15/4/14.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerDetailCell.h"
#import "WQCellSelectedBackground.h"

@interface WQCustomerDetailCell ()

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *detailLab;
@end

@implementation WQCustomerDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];

        self.titleLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.titleLab.backgroundColor = [UIColor clearColor];
        self.titleLab.font = [UIFont systemFontOfSize:15];
        self.titleLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.titleLab];
        
        self.detailLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.detailLab.backgroundColor = [UIColor clearColor];
        self.detailLab.font = [UIFont systemFontOfSize:12];
        self.detailLab.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.detailLab];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        
        WQCellSelectedBackground *selectedBackgroundView = [[WQCellSelectedBackground alloc] initWithFrame:CGRectZero];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor colorWithRed:220/255. green:220/255. blue:220/255. alpha:1] CGColor]];
        [self setSelectedBackgroundViewGradientColors:colors];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setSelectedBackgroundViewGradientColors:(NSArray*)colors {
    [(WQCellSelectedBackground*)self.selectedBackgroundView setSelectedBackgroundGradientColors:colors];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    self.titleLab.frame = (CGRect){10,(self.contentView.height-20)/2,100,20};
    
    self.detailLab.frame = (CGRect){self.titleLab.right+10,(self.contentView.height-20)/2,200,20};
    
    self.lineView.frame = (CGRect){10,self.contentView.height-1,self.contentView.width-10,2};
}

-(void)setDictionary:(NSDictionary *)dictionary {
    _dictionary = dictionary;
    
    NSArray *array = [dictionary allKeys];
    
    self.titleLab.text = array[0];
    
    self.detailLab.text = [Utility checkString:[dictionary objectForKey:array[0]]]?[dictionary objectForKey:array[0]]:@"";
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
    self.titleLab.text = @"";
    self.detailLab.text = @"";
}
@end
