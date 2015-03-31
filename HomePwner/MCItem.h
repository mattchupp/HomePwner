//
//  MCItem.h
//  RandomItems
//
//  Created by Matthew Chupp on 3/16/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MCItem : NSObject <NSCoding>
{
    NSString *_itemName;
    NSString *_serialNumber;
    int _valueInDollars;
    NSDate *_dateCreated;
}
@property (nonatomic, copy) NSString *itemKey;
@property (strong, nonatomic) UIImage *thumbnail; 

+ (instancetype)randomItem; 

// designated initializer for MCITEM
-(instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;
-(instancetype)initWithItemName:(NSString *)name;

- (void)setItemName:(NSString *)str;
- (NSString *)itemName;

- (void)setSerialNumber:(NSString *)str;
- (NSString *)serialNumber;

- (void)setValueInDollars:(int)v;
- (int)valueInDollars;

- (NSDate *)dateCreated;

- (void)setThumbnailFromImage:(UIImage *)image;

@end
