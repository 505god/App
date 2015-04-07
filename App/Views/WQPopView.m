//
//  WQPopView.m
//  App
//
//  Created by 邱成西 on 15/2/10.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQPopView.h"

static WQPopView *instancePop;

@implementation WQPopView

- (instancetype)initWithImageName:(NSString*)imageName message:(NSString *)string
{
    self = [super init];
    if (self) {
        self.hidden = NO;
        self.alpha = 1.0f;
        self.windowLevel = UIWindowLevelStatusBar + 1.0f;
        
        self.backgroundColor = [UIColor colorWithRed:0x17/255.0f green:0x17/255.0 blue:0x17/255.0 alpha:0.9];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4;
        
        UIImage *img = [UIImage imageNamed:imageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
        imageView.backgroundColor = [UIColor clearColor];
        [self addSubview:imageView];
        
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.numberOfLines = 0;
        label.text = string;
        [label sizeToFit];
        [self addSubview:label];
        
        
        if (imageView.width<label.width) {
            self.width = label.width + 20;
        }else{
            self.width = imageView.width + 20;
        }
        
        if (img) {
            self.height = label.height +imageView.height+ 40;
        }else{
            self.height = label.height+ 20;
        }
        self.left = ([UIScreen mainScreen].bounds.size.width - self.width)/2;
        self.top = ([UIScreen mainScreen].bounds.size.height - self.height)/2;
        
        if (img) {
            imageView.centerX = self.width/2;
            imageView.top = 15;
            label.centerX = self.width/2;
            label.top = imageView.bottom+10;
        }else{
            label.centerX = self.width/2;
            label.top = 10;
        }
        
        
        SafeRelease(imageView);
        SafeRelease(label);
    }
    return self;
}

+ (void)showWithImageName:(NSString*)imageName message:(NSString *)string;
{
    instancePop = [[WQPopView alloc] initWithImageName:imageName message:string];
    instancePop.alpha = 0;
    [UIView animateWithDuration:.25 animations:^{
        instancePop.alpha = 1;
    }];
    [instancePop performSelector:@selector(animationHide) withObject:nil afterDelay:2];
}

- (void)animationHide {
    [UIView animateWithDuration:.3 animations:^{
        instancePop.alpha = 0;
    } completion:^(BOOL finished) {
        instancePop = nil;
    }];
}

+(void)hiddenImage:(void (^)(BOOL finish))compleBlock {
    [UIView animateWithDuration:.25 animations:^{
        instancePop.alpha = 0;
    } completion:^(BOOL finished) {
        instancePop = nil;
        compleBlock(YES);
    }];
}
@end
