//
//  WQPopView.m
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQPopView.h"

@implementation WQPopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent: 0.75f];
        self.layer.cornerRadius = 4.0f;
        self.textLabe = [[UILabel alloc] initWithFrame:CGRectZero];
        self.textLabe.numberOfLines = 0;
        self.textLabe.font = [UIFont systemFontOfSize:17];
        self.textLabe.textColor = [UIColor whiteColor];
        self.textLabe.textAlignment = NSTextAlignmentCenter;
        self.textLabe.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabe];
        self.queueCount = 0;
    }
    return self;
}

- (void)setText:(NSString *) text {
    self.textLabe.frame = CGRectMake(0, 0, 250, 10);
    self.textLabe.text = text;
    
    self.queueCount ++;
    self.alpha = 1.0f;
    
    [self.textLabe sizeToFit];
    CGRect frame = CGRectMake(5, 5, self.textLabe.frame.size.width, self.textLabe.frame.size.height);
    self.textLabe.frame = frame;
    
    frame =  CGRectMake((self.parentView.frame.size.width - frame.size.width)/2, self.frame.origin.y, self.textLabe.frame.size.width+10, self.textLabe.frame.size.height+10);
    self.frame = frame;
    
    frame.origin.y -= 50;
    
    [UIView animateWithDuration:1
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0.5f;
                         self.frame = frame;
                     }completion:^(BOOL finished){
                         [UIView animateWithDuration:0.5
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              self.alpha = 0;
                                          }completion:^(BOOL finished){
                                              if (self.queueCount == 1) {
                                                  [self removeFromSuperview];
                                              }
                                              self.queueCount--;
                                              
                                          }];
                         
                     }];
    
    
}
@end
