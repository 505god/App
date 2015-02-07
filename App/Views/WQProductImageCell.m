//
//  WQProductImageCell.m
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProductImageCell.h"

#import "WQProImagesV.h"

@interface WQProductImageCell ()<WQProImagesVDelegate>

//添加图片
@property (nonatomic, strong) WQProImagesV *unitView;

@end

@implementation WQProductImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"WQProductImageCell" owner:self options: nil];
        self = [arrayOfViews objectAtIndex:0];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        
        
        self.unitView = [[WQProImagesV alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 110)];
        self.unitView.delegate = self;
        [self addSubview:self.unitView];
        
    }
    return self;
}

-(void)addProductImages:(NSArray *)images {
    [images enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIImage *image = (UIImage *)obj;
        [self.unitView addNewUnit:image withName:@""];
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - WQProImagesVDelegate

-(void)addNewProduct {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNewProductWithCell:)]) {
        [self.delegate addNewProductWithCell:self];
    }
}

//添加产品图片
-(void)addNewImage:(UIImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(addNewProductImage:)]) {
        [self.delegate addNewProductImage:image];
    }
}

//删除产品图片
-(void)removeImage:(UIImage *)image {
    if (self.delegate && [self.delegate respondsToSelector:@selector(removeProductImage:)]) {
        [self.delegate removeProductImage:image];
    }
}
@end
