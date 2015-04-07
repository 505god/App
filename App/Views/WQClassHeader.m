//
//  WQClassHeader.m
//  App
//
//  Created by 邱成西 on 15/4/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQClassHeader.h"

@interface WQClassHeader ()

@property (nonatomic, strong) UIButton *coverButton;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIImageView *arrawImage;

@property (nonatomic, strong) UIImageView *lineView;
@end

@implementation WQClassHeader
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coverButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.coverButton addTarget:self action:@selector(coverButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.coverButton];
        
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nameLab];
        
        self.arrawImage = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.arrawImage.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.arrawImage];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        longPress.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longPress];
        SafeRelease(longPress);
        
        self.lineView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.lineView.image = [UIImage imageNamed:@"line"];
        [self.contentView addSubview:self.lineView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)setIsSelected:(BOOL)isSelected {
    _isSelected = isSelected;
    
    self.arrawImage.image = isSelected?[UIImage imageNamed:@"navigationbar_arrow_down"]:[UIImage imageNamed:@"navigationbar_arrow_up"];
}

-(void)setASection:(NSInteger)aSection {
    _aSection = aSection;
}

-(void)setClassObj:(WQClassObj *)classObj {
    _classObj = classObj;
    
    self.nameLab.text = [NSString stringWithFormat:@"%@  (%d)",classObj.className,classObj.productCount];
}


- (void)coverButtonTapped {
    if ([self.classDelegate respondsToSelector:@selector(headerDidSelectCoverOption:)]) {
        [self.classDelegate headerDidSelectCoverOption:self];
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)recognizer {
    //长按开始
    if(recognizer.state == UIGestureRecognizerStateBegan) {
        if ([self.classDelegate respondsToSelector:@selector(headerDidLongPressedOption:)]) {
            [self.classDelegate headerDidLongPressedOption:self];
        }
    }//长按结束
    else if(recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        
    }
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    self.coverButton.frame = CGRectMake(0, 0, self.width, self.height);
    self.nameLab.frame = (CGRect){10,12,self.width-20,20};
    self.arrawImage.frame = (CGRect){self.width-30,12,20,20};
    
    self.lineView.frame = (CGRect){10,self.height-1,self.width-10,2};
}

-(void)prepareForReuse {
    [super prepareForReuse];
    self.arrawImage.image = nil;
    self.nameLab.text = nil;
    self.classObj = nil;
}
@end
