//
//  MCImageStore.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/22/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCImageStore.h"

@interface MCImageStore ()

@property (nonatomic, strong) NSMutableDictionary *dictionary;

@end


@implementation MCImageStore

+ (instancetype)sharedStore {
    
    static MCImageStore *sharedStore;
    
//    if (!sharedStore) {
//        sharedStore = [[self alloc] initPrivate];
//    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{sharedStore = [[self alloc] initPrivate]; });
    
    return sharedStore;
}

// no one should call init
- (instancetype)init {
    [NSException raise:@"Singleton" format:@"Use +[MCImageStore sharedStore]"];
    return nil;
}

// secret designated initializer
- (instancetype)initPrivate {
    
    self = [super init];
    
    if (self) {
        _dictionary = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)setImage:(UIImage *)image forKey:(NSString *)key {
//    [self.dictionary setObject:image forKeyedSubscript:key];
    self.dictionary[key] = image;
}

- (UIImage *)imageForKey:(NSString *)key {
//    return [self.dictionary objectForKey:key];
    return self.dictionary[key];
}

- (void)deleteImageForKey:(NSString *)key {
    if (!key) {
        return;
    }
    [self.dictionary removeObjectForKey:key];
}

@end
