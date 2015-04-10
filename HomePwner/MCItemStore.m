//
//  MCItemStore.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/18/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCItemStore.h"
#import "MCItem.h"
#import "MCImageStore.h"

@import CoreData;

@interface MCItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic, strong) NSMutableArray *allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

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
//        _privateItems = [[NSMutableArray alloc] init];
//        NSString *path = [self itemArchivePath];
//        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
//        
//        // if the array hadn't been saved previously, creat a new empty one
//        if (!_privateItems) {
//            _privateItems = [[NSMutableArray alloc] init];
//        }
        
        // Read in Homepwner.xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Where does the SQLite file go?
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        
        NSError *error;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            [NSException raise:@"Open Failure" format:[error localizedDescription]];
        }
        
        // Create the managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    
    return self;
}

- (NSArray *)allItems {
    return [self.privateItems copy];
}

- (MCItem *)createItem {
    
    //MCItem *item = [MCItem randomItem];
    //MCItem *item = [[MCItem alloc] init];
    
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [self.privateItems count], order);
    
    MCItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"MCItem"
                                                 inManagedObjectContext:self.context];
    item.orderingValue = order;
    
    [self.privateItems addObject:item];
    
    return item;
}

#pragma mark -DeleteRows

-(void)removeItem:(MCItem *)item {
    
    NSString *key = item.itemKey;
    
    [[MCImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
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

#pragma mark -Archiving 
- (NSString *)itemArchivePath {
    
    // make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    // get the one document directory from that list
    NSString *documentDirectory = [documentDirectories firstObject];
    
    //return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

- (BOOL)saveChanges {
    
//    NSString *path = [self itemArchivePath];
//    
//    // Returns YES on success
//    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
    
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (void)loadAllItems {
    
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [NSEntityDescription entityForName:@"MCItem"
                                             inManagedObjectContext:self.context];
        
        request.entity = e;
        
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue"
                                            ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError *error;
        NSArray * result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

@end
