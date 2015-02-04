//
//  WQCustomerCell.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCustomerCell.h"

#import "WQStarView.h"

@interface WQCustomerCell ()

@property (nonatomic, weak) IBOutlet UIImageView *headerImg;
@property (nonatomic, weak) IBOutlet UILabel *nameLab;
@property (nonatomic, weak) IBOutlet WQStarView *starV;

@end

@implementation WQCustomerCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WQCustomerCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCustomerObj:(WQCustomerObj *)customerObj {
    if (_customerObj != customerObj) {
        _customerObj = nil;
        _customerObj = customerObj;
        
        self.nameLab.text = customerObj.customerName;
        self.starV.starNumber = customerObj.customerDegree;
    }
}
@end
