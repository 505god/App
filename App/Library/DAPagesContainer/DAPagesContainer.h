//
//  DAPageContainerScrollView.h
//  DAPagesContainerScrollView
//
//  Created by Daria Kopaliani on 5/29/13.
//  Copyright (c) 2013 Daria Kopaliani. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DAPagesContainer : UIViewController

@property (strong, nonatomic) NSArray *viewControllers;
@property (assign, nonatomic) NSUInteger selectedIndex;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;

@end
