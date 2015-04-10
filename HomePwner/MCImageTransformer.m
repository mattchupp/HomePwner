//
//  MCImageTransformer.m
//  HomePwner
//
//  Created by Matthew Chupp on 4/8/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "MCImageTransformer.h"


@implementation MCImageTransformer

+ (Class)transformedValueClass {
    
    return [NSData class];
}

- (id)transformedValue:(id)value {
    
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value {
    
    return [UIImage imageWithData:value];
}

@end
