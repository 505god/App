//
//  WQProductActionCell.m
//  App
//
//  Created by 邱成西 on 15/2/7.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductActionCell.h"

#import "WQCellSelectedBackground.h"

@interface WQProductActionCell ()

@end

@implementation WQProductActionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WQProductActionCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        WQCellSelectedBackground *selectedBackgroundView = [[WQCellSelectedBackground alloc] initWithFrame:CGRectZero];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor lightGrayColor] CGColor]];
        [self setSelectedBackgroundViewGradientColors:colors];
    }
    return self;
}

- (void)setSelectedBackgroundViewGradientColors:(NSArray*)colors {
    [(WQCellSelectedBackground*)self.selectedBackgroundView setSelectedBackgroundGradientColors:colors];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)switchBtnPressed:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(setProductHot:)]) {
        [self.delegate setProductHot:self.switchBtn.isOn];
    }
}
@end
