//
//  WQIndexedCollationWithSearch.h
//  App
//
//  Created by 邱成西 on 15/2/5.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import <Foundation/Foundation.h>

//通讯录  检索
@interface WQIndexedCollationWithSearch : NSObject

@property (nonatomic, strong) UILocalizedIndexedCollation *collation;
@property (nonatomic, readonly) NSArray *sectionTitles;
@property (nonatomic, readonly) NSArray *sectionIndexTitles;


+ (id)currentCollation;
- (id)initWithCollation:(UILocalizedIndexedCollation *)collation;

- (NSInteger)sectionForObject:(id)object collationStringSelector:(SEL)selector;
- (NSInteger)sectionForSectionIndexTitleAtIndex:(NSInteger)indexTitleIndex;
- (NSArray *)sortedArrayFromArray:(NSArray *)array
          collationStringSelector:(SEL)selector;
@end
