//
//  MCImageStore.h
//  HomePwner
//
//  Created by Matthew Chupp on 3/22/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h> 

@interface MCImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
