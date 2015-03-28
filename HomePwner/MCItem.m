//
//  MCItem.m
//  RandomItems
//
//  Created by Matthew Chupp on 3/16/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCItem.h"

@implementation MCItem

#pragma mark ItemName
- (void)setItemName:(NSString *)str {

    _itemName = str;
    
}
- (NSString *)itemName {
    
    return _itemName;
    
}

#pragma mark SerialNumber
- (void)setSerialNumber:(NSString *)str {
    
    _serialNumber = str;
    
}
- (NSString *)serialNumber {
    
    return _serialNumber;
    
}

#pragma mark ValueInDollars
- (void)setValueInDollars:(int)v {
    
    _valueInDollars = v;
    
}
- (int)valueInDollars {
    
    return _valueInDollars;
    
}

#pragma mark dateCreated
- (NSDate *)dateCreated {
    
    return _dateCreated;
    
}


#pragma mark description
- (NSString *)description {
    NSString *descriptionString =
    [[NSString alloc] initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
     self.itemName, self.serialNumber, self.valueInDollars, self.dateCreated];

    return descriptionString; 
}

#pragma mark init
- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber {
    
    // call the superclass's designated initializer
    self = [super init];
    
    // did the superclass's designated initializer succeed?
    if (self) {
        // give the instance variables initial values
        _itemName = name;
        _serialNumber = sNumber;
        _valueInDollars = value;
        
        // set _dateCreated to current date and time
        _dateCreated = [[NSDate alloc] init];
        
        // create an NSUUID object - and get its string representation
        NSUUID *uuid = [[NSUUID alloc] init];
        NSString *key = [uuid UUIDString];
        _itemKey = key;
    }
    
    return self;
}

- (instancetype)initWithItemName:(NSString *)name {
    
    return [self initWithItemName: name
                   valueInDollars:0
                     serialNumber:@""];
}

#pragma mark class methods
+ (instancetype)randomItem {
    
    // create immutable array of three adjectives
    NSArray *randomAdjectiveList = @[@"Fluffy", @"Rusty", @"Shiny"];
    
    // create an immutable array of three nouns
    NSArray *randomNounList = @[@"Bear", @"Spork", @"Mac"];
    
    // get the indx of a random adjective/noun from the lists
    NSInteger adjectiveIndex = arc4random() % [randomAdjectiveList count];
    NSInteger nounIndex = arc4random() % [randomNounList count];
    
    //NSInteger = "long"
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounList objectAtIndex:nounIndex]];

    int randomValue = arc4random() % 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                                                '0' + arc4random() % 20,
                                                                'A' + arc4random() % 26,
                                                                '0' + arc4random() % 10,
                                                                'A' + arc4random() % 26,
                                                                '0' + arc4random() % 10];
    
    MCItem *newItem = [[self alloc] initWithItemName:randomName
                                      valueInDollars:randomValue
                                        serialNumber:randomSerialNumber];
    
    return newItem;
    
}

#pragma mark -Archiving 
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeObject:self.serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:self.dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:self.itemKey forKey:@"itemKey"];
    
    [aCoder encodeInteger:self.valueInDollars forKey:@"valueInDollars"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        _itemName = [aDecoder decodeObjectForKey:@"itemNam"];
        _serialNumber = [aDecoder decodeObjectForKey:@"serialNumber"];
        _dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
        _itemKey = [aDecoder decodeObjectForKey:@"itemKey"];
        
        _valueInDollars = [aDecoder decodeIntForKey:@"valueInDollars"];
    }
    return self;
}



@end
