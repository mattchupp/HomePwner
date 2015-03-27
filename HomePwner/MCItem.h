//
//  MCItem.h
//  RandomItems
//
//  Created by Matthew Chupp on 3/16/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MCItem : NSObject
{
    NSString *_itemName;
    NSString *_serialNumber;
    int _valueInDollars;
    NSDate *_dateCreated;
}
@property (nonatomic, copy) NSString *itemKey;

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

@end
