//
//  WQProductColorCell.m
//  App
//
//  Created by 邱成西 on 15/2/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductColorCell.h"

#import "WQCellSelectedBackground.h"

@interface WQProductColorCell ()<WQTapImgDelegate>

@end

@implementation WQProductColorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WQProductColorCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        WQCellSelectedBackground *selectedBackgroundView = [[WQCellSelectedBackground alloc] initWithFrame:CGRectZero];
        [self setSelectedBackgroundView:selectedBackgroundView];
        
        NSMutableArray *colors = [NSMutableArray array];
        [colors addObject:(id)[[UIColor lightGrayColor] CGColor]];
        [self setSelectedBackgroundViewGradientColors:colors];
        
        self.productImgView.delegate = self;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setSelectedBackgroundViewGradientColors:(NSArray*)colors {
    [(WQCellSelectedBackground*)self.selectedBackgroundView setSelectedBackgroundGradientColors:colors];
}
-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    
    self.stockTxt.idxPath = indexPath;
}

-(void)setColorObj:(WQColorObj *)colorObj {
    _colorObj = colorObj;
    
    self.colorLab.text = colorObj.colorName;
    
    if (colorObj.stockCount==0) {
        self.stockTxt.text = @"";
    }else {
        self.stockTxt.text = [NSString stringWithFormat:@"%d",colorObj.stockCount];
    }
    
    if (colorObj.productImg != nil) {
        self.productImgView.image = colorObj.productImg;
    }
}

//点击添加产品图片
- (void)tappedWithObject:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addProductImage:)]) {
        [self.delegate addProductImage:self];
    }
}
@end
