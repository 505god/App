//
//  WQTapImg.h
//  App
//
//  Created by 邱成西 on 15/2/3.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQTapImgDelegate;

@interface WQTapImg : UIImageView

@property (nonatomic, strong) id identifier;

@property (nonatomic, assign) id<WQTapImgDelegate> delegate;

@end

@protocol WQTapImgDelegate <NSObject>

- (void)tappedWithObject:(id) sender;
@end