//
//  WQProductSaleHeader.h
//  App
//
//  Created by 邱成西 on 15/4/20.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQSwipTableHeader.h"

@interface WQProductSaleHeader : WQSwipTableHeader

@property (nonatomic, assign) NSInteger aSection;
@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong) NSString *textString;
@end
