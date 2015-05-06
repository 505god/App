//
//  WQProAttributrFooter.m
//  App
//
//  Created by 邱成西 on 15/4/9.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQProAttributrFooter.h"

@interface WQProAttributrFooter ()

@property (nonatomic, assign) UIButton *coverBtn;

@end

@implementation WQProAttributrFooter

-(void)dealloc {
    _coverBtn = nil;
    _footDelegate = nil;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *img = [[UIImageView alloc]initWithFrame:(CGRect){10,10,20,20}];
        img.image = [UIImage imageNamed:@"addProperty"];
        [self.contentView addSubview:img];
       
        UILabel *lab = [[UILabel alloc]initWithFrame:(CGRect){img.right+10,img.top,200,20}];
        lab.font = [UIFont systemFontOfSize:16];
        lab.backgroundColor = [UIColor clearColor];
        lab.text = NSLocalizedString(@"AddMarque", @"");
        [self.contentView addSubview:lab];
         SafeRelease(img);
        SafeRelease(lab);
        
        self.coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.coverBtn addTarget:self action:@selector(coverButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.coverBtn];
        
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.coverBtn.frame = (CGRect){0,0,self.contentView.width,self.contentView.height};
}

-(void)coverButtonTapped {
    if (self.footDelegate && [self.footDelegate respondsToSelector:@selector(addMoreProType)]) {
        [self.footDelegate addMoreProType];
    }
}
@end
