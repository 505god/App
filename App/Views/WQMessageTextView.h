//
//  WQMessageTextView.h
//  App
//
//  Created by 邱成西 on 15/5/2.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQDismissiveTextView.h"

@interface WQMessageTextView : WQDismissiveTextView

@property (strong, nonatomic) NSString *placeHolder;
@property (strong, nonatomic) UIColor *placeHolderTextColor;

- (NSUInteger)numberOfLinesOfText;
+ (NSUInteger)maxCharactersPerLine;
+ (NSUInteger)numberOfLinesForMessage:(NSString *)text;
@end
