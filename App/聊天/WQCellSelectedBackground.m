//
//  WQCellSelectedBackground.m
//  App
//
//  Created by 邱成西 on 15/2/8.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQCellSelectedBackground.h"

#import <QuartzCore/QuartzCore.h>

@interface WQCellSelectedBackground ()

@property (nonatomic, assign) float prevLayerHeight;

@end

@implementation WQCellSelectedBackground

- (BOOL) isOpaque
{
    return YES;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    if (self.frame.size.height!=self.prevLayerHeight)
    {
        for (int i=0; i<[self.layer.sublayers count]; i++)
        {
            id layer = [self.layer.sublayers objectAtIndex:i];
            if ([layer isKindOfClass:[CAGradientLayer class]])
            {
                [layer removeFromSuperlayer];
            }
        }
    }
    
    self.selectedBackgroundGradientColors = @[[self.selectedBackgroundGradientColors objectAtIndex:0],[self.selectedBackgroundGradientColors objectAtIndex:0]];
    
    // draw the selected background gradient
    CAGradientLayer *gradient = [CAGradientLayer layer];
    [gradient setFrame:CGRectMake(0,0,self.frame.size.width,self.frame.size.height)];
    [gradient setStartPoint:CGPointMake(0, 0)];
    [gradient setEndPoint:CGPointMake(0, 1)];
    
    [self.layer insertSublayer:gradient atIndex:0];
    [gradient setColors:self.selectedBackgroundGradientColors];
    
    [super drawRect:rect];
    
    self.prevLayerHeight = self.frame.size.height;
}

@end
