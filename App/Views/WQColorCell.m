//
//  WQColorCell.m
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQColorCell.h"

@interface WQColorCell ()

@property (nonatomic, weak) IBOutlet UILabel *nameLab;

@end

@implementation WQColorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WQColorCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setColorObj:(WQColorObj *)colorObj {
    _colorObj = colorObj;
    
    self.nameLab.text = colorObj.colorName;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    [self.checkButton setSelected:isSelected];
}

-(IBAction)selectedCheckBtn:(id)sender {
    [self.checkButton setSelected:!self.checkButton.selected];
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedColor:animated:)]) {
        [self.delegate selectedColor:self.colorObj animated:self.checkButton.selected];
    }
}
@end
