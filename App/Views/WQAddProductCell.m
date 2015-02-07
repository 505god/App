//
//  WQAddProductCell.m
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQAddProductCell.h"

@interface WQAddProductCell ()



@property (nonatomic, strong) NSString *name;
@end

@implementation WQAddProductCell

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andName:(NSString *)name {
    _image = image;
    _name = name;
    self = [super initWithFrame:frame];
    if (self) {
        [self setProperty];
    }
    return self;
}

//设置Cell的属性
- (void)setProperty
{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.0;
    [self setBackgroundImage:_image forState:UIControlStateNormal];
    [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touched:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(unitCellTouched:)])
        [_delegate unitCellTouched:self];
}
@end
