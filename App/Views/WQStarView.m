//
//  WQStarView.m
//  App
//
//  Created by 邱成西 on 15/2/4.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQStarView.h"

#define ZOOM 0.8f

@interface WQStarView ()

@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIView *topView;
@property (nonatomic,assign) CGFloat starWidth;

@end

@implementation WQStarView

-(void)awakeFromNib {
    self.backgroundColor = [UIColor clearColor];
    
    self.bottomView = [[UIView alloc] initWithFrame:self.bounds];
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self addSubview:self.bottomView];
    [self addSubview:self.topView];
    
    self.topView.clipsToBounds = YES;
    self.topView.userInteractionEnabled = NO;
    self.bottomView.userInteractionEnabled = NO;
    self.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:tap];
    [self addGestureRecognizer:pan];
    
    //
    CGFloat width = self.frame.size.width/7.0;
    self.starWidth = width;
    for(int i = 0;i<5;i++){
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width*ZOOM, width*ZOOM)];
        img.center = CGPointMake((i+1.5)*width, self.frame.size.height/2);
        img.image = LOADIMAGE(@"bt_star_a", @"png");
        [self.bottomView addSubview:img];
        UIImageView *img2 = [[UIImageView alloc] initWithFrame:img.frame];
        img2.center = img.center;
        img2.image = LOADIMAGE(@"bt_star_b", @"png");
        [self.topView addSubview:img2];
    }
    self.enable = YES;
}

-(void)setViewColor:(UIColor *)backgroundColor{
    if(_viewColor!=backgroundColor){
        self.backgroundColor = backgroundColor;
        self.topView.backgroundColor = backgroundColor;
        self.bottomView.backgroundColor = backgroundColor;
    }
}
-(void)setStarNumber:(NSInteger)starNumber{
    if(_starNumber!=starNumber){
        _starNumber = starNumber;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*(starNumber+1), self.bounds.size.height);
    }
}
-(void)tap:(UITapGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth)+1;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*count, self.bounds.size.height);
        if(count>5){
            _starNumber = 5;
        }else{
            _starNumber = count-1;
        }
    }
}
-(void)pan:(UIPanGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth);
        if(count>=0 && count<=5 && _starNumber!=count){
            self.topView.frame = CGRectMake(0, 0, self.starWidth*(count+1), self.bounds.size.height);
            _starNumber = count;
        }
    }
}

@end
