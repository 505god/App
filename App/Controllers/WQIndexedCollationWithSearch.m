//
//  WQIndexedCollationWithSearch.m
//  App
//
//  Created by 邱成西 on 15/2/5.
//  Copyright (c) 2015年 Just Do It. All rights reserved.
//

#import "WQIndexedCollationWithSearch.h"

@implementation WQIndexedCollationWithSearch

+ (id)currentCollation {
    UILocalizedIndexedCollation *collation =
    [UILocalizedIndexedCollation currentCollation];
    return [[self alloc] initWithCollation:collation];
}

- (id)initWithCollation:(UILocalizedIndexedCollation *)collation;
{
    if (self = [super init]) {
        _collation = collation;
    }
    return self;
}

#pragma mark -

- (NSInteger)sectionForObject:(id)object collationStringSelector:(SEL)selector {
    return
    [_collation sectionForObject:object collationStringSelector:selector];
}

- (NSInteger)sectionForSectionIndexTitleAtIndex:(NSInteger)indexTitleIndex {
    if (indexTitleIndex == 0) {
        
        return NSNotFound;
    }
    return [_collation sectionForSectionIndexTitleAtIndex:indexTitleIndex - 1];
}

- (NSArray *)sortedArrayFromArray:(NSArray *)array
          collationStringSelector:(SEL)selector {
    return [_collation sortedArrayFromArray:array
                    collationStringSelector:selector];
}

#pragma mark -
#pragma mark Accessors

- (NSArray *)sectionTitles;
{ return [_collation sectionTitles]; }

- (NSArray *)sectionIndexTitles;
{
    return [[NSArray arrayWithObject:UITableViewIndexSearch]
            arrayByAddingObjectsFromArray:[_collation sectionIndexTitles]];
}
@end
