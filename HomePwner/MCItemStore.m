//
//  MCItemStore.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/18/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCItemStore.h"
#import "MCItem.h"

@interface MCItemStore ()

@property (nonatomic) NSMutableArray *privateItems;

@end


@implementation MCItemStore

+ (instancetype)sharedStore {
    
    static MCItemStore *sharedStore;
    
    // do i need to create sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

// if a programmer calls [[MCItemStore alloc] init], let him
// know the error in his ways
- (instancetype)init {
    [NSException raise:@"Singleton" format:@"Use + [MCItemStore sharedStore]"];
    return nil;
}

// the real (secret) initializer
- (instancetype)initPrivate {
    
    self = [super init];
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)allItems {
    return [self.privateItems copy];
}

- (MCItem *)createItem {
    
    MCItem *item = [MCItem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}

#pragma mark -DeleteRows

-(void)removeItem:(MCItem *)item {
    
    [self.privateItems removeObjectIdenticalTo:item];
}

#pragma mark -MoveRow

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    
    if (fromIndex == toIndex) {
        
        // get pointer to object being moved so you can reinsert it
        MCItem *item = self.privateItems[fromIndex];
        
        // remove item from array
        [self.privateItems removeObjectAtIndex:fromIndex];
        
        // insert item in array at new location
        [self.privateItems insertObject:item atIndex:toIndex];
    }
}

@end
