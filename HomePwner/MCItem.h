//
//  MCItem.h
//  HomePwner
//
//  Created by Matthew Chupp on 4/9/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@class NSManagedObject;

@interface MCItem : NSManagedObject

@property (nonatomic, strong) NSDate * dateCreated;
@property (nonatomic, strong) NSString * itemKey;
@property (nonatomic, strong) NSString * itemName;
@property (nonatomic) double orderingValue;
@property (nonatomic, strong) NSString * serialNumber;
@property (nonatomic, strong) UIImage * thumbnail;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSManagedObject *assetType;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
