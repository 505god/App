//
//  WQProductColorCell.m
//  App
//
//  Created by 邱成西 on 15/2/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductColorCell.h"
#import "WQNewProductVC.h"
#import "WQSizeObj.h"


#import "WQCellSelectedBackground.h"

#define ImageSize 60

#define SizeTag 6000

#define LabelTag 8000

#define CELL_HEIGHT self.contentView.frame.size.height
#define CELL_WIDTH self.contentView.frame.size.width

@interface WQProductColorCell ()<WQTapImgDelegate>



@end

@implementation WQProductColorCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        //产品图片
        self.productImgView = [[WQTapImg alloc]initWithFrame:CGRectZero];
        self.productImgView.delegate = self;
        self.productImgView.image = [UIImage imageNamed:@"add_attention_btn"];
        [self.contentView addSubview:self.productImgView];
        
        //颜色名称
        self.colorNameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.colorNameLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.colorNameLab];
        
        //箭头
        self.directionImg = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.directionImg.image = [UIImage imageNamed:@"settingDirection"];
        [self.contentView addSubview:self.directionImg];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.productImgView.frame = (CGRect){10,(CELL_HEIGHT-ImageSize)/2,ImageSize,ImageSize};
    
    self.colorNameLab.frame = (CGRect){80,(CELL_HEIGHT-self.colorNameLab.height)/2,self.colorNameLab.width,self.colorNameLab.height};
    
    self.directionImg.frame = (CGRect){CELL_WIDTH-32,(CELL_HEIGHT-25)/2,25,25};
    
    //尺码和库存
    CGFloat height = 30;
    for (int i=0; i<self.colorObj.sizeArray.count; i++) {
        UILabel *sizeNameLab = (UILabel *)[self.contentView viewWithTag:LabelTag+i];
        DLog(@"%f",self.contentView.frame.size.width);
        sizeNameLab.frame = (CGRect){self.colorNameLab.right,self.colorObj.sizeArray.count<=2?(CELL_HEIGHT-self.colorObj.sizeArray.count*height)/2+height*i:height*i,80,height};
        
        WQProductText *stockTxt = (WQProductText *)[self.contentView viewWithTag:SizeTag+i];
        stockTxt.frame = (CGRect){sizeNameLab.right,sizeNameLab.top+2,75,height-4};
    }
    
    //点击背景
    WQCellSelectedBackground *selectedBackgroundView = [[WQCellSelectedBackground alloc] initWithFrame:CGRectZero];
    [self setSelectedBackgroundView:selectedBackgroundView];
    
    NSMutableArray *colors = [NSMutableArray array];
    [colors addObject:(id)[[UIColor lightGrayColor] CGColor]];
    [self setSelectedBackgroundViewGradientColors:colors];
}

- (void)setSelectedBackgroundViewGradientColors:(NSArray*)colors {
    [(WQCellSelectedBackground*)self.selectedBackgroundView setSelectedBackgroundGradientColors:colors];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
}

-(void)setColorObj:(WQColorObj *)colorObj {
    _colorObj = colorObj;

    self.colorNameLab.text = colorObj.colorName;
    [self.colorNameLab sizeToFit];
    
    if (colorObj.productImg != nil) {
        self.productImgView.image = colorObj.productImg;
    }else {
        self.productImgView.image = [UIImage imageNamed:@"add_attention_btn"];
    }
    
    for (UIView *view in self.contentView.subviews){
        if (view.tag>=6000) {
            [view removeFromSuperview];
        }
    }
    
    //尺码和库存====建议 height=30
    if(colorObj.sizeArray.count>0) {
        for (int i=0; i<colorObj.sizeArray.count; i++) {
            WQSizeObj *sizeObj = (WQSizeObj *)colorObj.sizeArray[i];
            
            //尺码名称
            UILabel *sizeNameLab = [[UILabel alloc]initWithFrame:CGRectZero];
            sizeNameLab.backgroundColor = [UIColor clearColor];
            sizeNameLab.textAlignment = NSTextAlignmentRight;
            sizeNameLab.lineBreakMode = NSLineBreakByTruncatingMiddle;
            sizeNameLab.text = [NSString stringWithFormat:@"%@:",sizeObj.sizeName];
            sizeNameLab.font = [UIFont systemFontOfSize:15];
            sizeNameLab.tag = LabelTag +i;
            [self.contentView addSubview:sizeNameLab];
            
            //库存
            WQProductText *stockTxt = [[WQProductText alloc]initWithFrame:CGRectZero];
            stockTxt.delegate = self.productVC;
            stockTxt.placeholder = @"库存数量";
            stockTxt.borderStyle = UITextBorderStyleRoundedRect;
            stockTxt.keyboardType = UIKeyboardTypeNumberPad;
            stockTxt.tag = SizeTag +i;
            stockTxt.idxPath = self.indexPath;
            stockTxt.backgroundColor = COLOR(220, 220, 220, 1);
            stockTxt.font = [UIFont systemFontOfSize:15];
            if (sizeObj.stockCount==0) {
                stockTxt.text = @"";
            }else {
                stockTxt.text = [NSString stringWithFormat:@"%d",sizeObj.stockCount];
            }
            [self.contentView addSubview:stockTxt];
            
            SafeRelease(sizeNameLab);
            SafeRelease(stockTxt);
        }
        
    }
}

//点击添加产品图片
- (void)tappedWithObject:(id) sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addProductImage:)]) {
        [self.delegate addProductImage:self];
    }
}
@end
