//
//  WQProImgItem.m
//  App
//
//  Created by 邱成西 on 15/4/8.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProImgItem.h"

@interface WQProImgItem ()

//@property (nonatomic, strong) UIImage *proImg;

@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation WQProImgItem

- (id)initWithFrame:(CGRect)frame andImage:(UIImage *)image{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        
        self.contentMode = UIViewContentModeScaleAspectFill;
        
        self.image = image;
        
        ///删除按钮
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.deleteBtn setImage:[UIImage imageNamed:@"DeleteRed"] forState:UIControlStateNormal];
        self.deleteBtn.frame = (CGRect){self.width-20,0,20,20};
        [self.deleteBtn addTarget:self action:@selector(deleteItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
    }
    return self;
}

-(void)deleteItem:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteProItem:)]) {
        [self.delegate deleteProItem:self];
    }
}

@end
