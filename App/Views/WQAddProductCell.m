//
//  WQAddProductCell.m
//  App
//
//  Created by 邱成西 on 15/2/6.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQAddProductCell.h"
#import "UIButton+AFNetworking.h"

@interface WQAddProductCell ()



@property (nonatomic, strong) NSString *name;
@end

@implementation WQAddProductCell

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image andName:(NSString *)name andImageUrl:(NSURL *)imageUrl{
    _image = image;
    _name = name;
    self = [super initWithFrame:frame];
    if (self) {
        if (image) {
            [self setBackgroundImage:_image forState:UIControlStateNormal];
        }else {
            [self setImageForState:UIControlStateNormal withURL:imageUrl];
        }
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        [self addTarget:self action:@selector(touched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)touched:(id)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(unitCellTouched:)])
        [_delegate unitCellTouched:self];
}
@end
