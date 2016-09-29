//
//  UICustomerBtn.m
//  App
//
//  Created by 邱成西 on 15/5/13.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "UICustomerBtn.h"

@implementation UICustomerBtn

- (BOOL)canBecomeFirstResponder {
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return (action == @selector(copy:));
}

-(void)copy:(id)sender{
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    pboard.string = self.titleLabel.text;
}


@end
