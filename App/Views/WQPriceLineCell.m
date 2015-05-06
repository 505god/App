//
//  WQPriceLineCell.m
//  App
//
//  Created by 邱成西 on 15/4/21.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQPriceLineCell.h"

@interface WQPriceLineCell ()

@property (nonatomic, strong) UIImageView *lineView;

@property (nonatomic, strong) UIView *circleView;
@end

@implementation WQPriceLineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        self.textLabel.font = [UIFont systemFontOfSize:15];
        self.textLabel.backgroundColor = [UIColor clearColor];
//        self.textLabel.textColor = [UIColor lightGrayColor];
        
        self.detailTextLabel.font = [UIFont systemFontOfSize:15];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"hLine"];
        [self.contentView addSubview:self.lineView];
     
        self.circleView = [[UIView alloc]initWithFrame:CGRectZero];
        self.circleView.backgroundColor = COLOR(251, 0, 41, 1);
        [self.contentView addSubview:self.circleView];
    }
    return self;
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.textLabel sizeToFit];
    [self.detailTextLabel sizeToFit];
    
    self.contentView.frame = (CGRect){0,0,self.width,self.height};
    
    self.lineView.frame = (CGRect){(self.width-2)/2,0,2,self.height};
    
    self.circleView.frame = (CGRect){(self.width-10)/2,(self.height-10)/2,10,10};
    [Utility roundView:self.circleView];
    
    if (self.indexPath.row%2==0) {
        self.detailTextLabel.frame = (CGRect){self.lineView.left-self.detailTextLabel.width-5,(self.height-self.detailTextLabel.height)/2,self.detailTextLabel.width,self.detailTextLabel.height};
        self.textLabel.frame = (CGRect){self.detailTextLabel.left-self.textLabel.width-5,(self.height-self.textLabel.height)/2,self.textLabel.width,self.textLabel.height};
    }else {
        self.textLabel.frame = (CGRect){self.lineView.right+5,(self.height-self.textLabel.height)/2,self.textLabel.width,self.textLabel.height};
        self.detailTextLabel.frame = (CGRect){self.textLabel.right+5,(self.height-self.detailTextLabel.height)/2,self.detailTextLabel.width,self.detailTextLabel.height};
    }
}

-(void)setPriceLineObj:(WQPricelineObj *)priceLineObj {
    _priceLineObj = priceLineObj;
    
    self.textLabel.text = priceLineObj.time;
    self.detailTextLabel.text = priceLineObj.price;
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.textLabel.text = @"";
    self.detailTextLabel.text = @"";
}
@end
