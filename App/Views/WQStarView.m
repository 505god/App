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

-(void)dealloc {
    SafeRelease(_viewColor);
    SafeRelease(_bottomView);
    SafeRelease(_topView);
    SafeRelease(_delegate);
    SafeRelease(_idxPath);
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.bottomView = [[UIView alloc] initWithFrame:self.bounds];
        self.topView = [[UIView alloc] initWithFrame:self.bounds];
        
        [self addSubview:self.bottomView];
        [self addSubview:self.topView];
        
        self.topView.clipsToBounds = YES;
        self.topView.userInteractionEnabled = NO;
        self.bottomView.userInteractionEnabled = NO;
        self.userInteractionEnabled = YES;
        
        ///手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:tap];
        [self addGestureRecognizer:pan];
        SafeRelease(tap);
        SafeRelease(pan);
        
        //
        CGFloat width = self.frame.size.width/7.0;
        self.starWidth = width;
        for(int i = 0;i<5;i++){
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width*ZOOM, width*ZOOM)];
            img.center = CGPointMake((i+1.5)*width, self.height/2);
            img.image = [UIImage imageNamed:@"bt_star_a"];
            [self.bottomView addSubview:img];
            UIImageView *img2 = [[UIImageView alloc] initWithFrame:img.frame];
            img2.center = img.center;
            img2.image = [UIImage imageNamed:@"bt_star_b"];
            [self.topView addSubview:img2];
            
            SafeRelease(img);SafeRelease(img2);
        }
        self.enable = YES;
    }
    return self;
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

-(void)setShowNormal:(BOOL)showNormal {
    _showNormal = showNormal;
    [self.bottomView setHidden:!showNormal];
}

-(void)setIdxPath:(NSIndexPath *)idxPath {
    _idxPath = idxPath;
}

-(void)tap:(UITapGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth)+1;
        self.topView.frame = CGRectMake(0, 0, self.starWidth*count, self.bounds.size.height);
        if(count>5){
            self.starNumber = 5;
        }else{
            self.starNumber = count-1;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(startView:number:)]) {
            [self.delegate startView:self number:self.starNumber];
        }
    }
}
-(void)pan:(UIPanGestureRecognizer *)gesture{
    if(self.enable){
        CGPoint point = [gesture locationInView:self];
        NSInteger count = (int)(point.x/self.starWidth);
        if(count>=0 && count<=5 && self.starNumber!=count){
            self.topView.frame = CGRectMake(0, 0, self.starWidth*(count+1), self.bounds.size.height);
            self.starNumber = count;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(startView:number:)]) {
                [self.delegate startView:self number:self.starNumber];
            }
        }
    }
}

@end
