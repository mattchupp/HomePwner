//
//  MCItemStore.h
//  HomePwner
//
//  Created by Matthew Chupp on 3/18/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MCItem;

@interface MCItemStore : NSObject

@property (nonatomic, readonly, copy) NSArray *allItems;

+ (instancetype)sharedStore;
- (MCItem *)createItem;
- (void)removeItem:(MCItem *)item;
- (void)moveItemAtIndex:(NSUInteger)fromIndex
                toIndex:(NSUInteger)toIndex;

@end
