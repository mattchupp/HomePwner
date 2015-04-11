//
//  MCDetailViewController.h
//  HomePwner
//
//  Created by Matthew Chupp on 3/20/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MCItem;

@interface MCDetailViewController : UIViewController <UIViewControllerRestoration>

- (instancetype)initForNewItem:(BOOL)isNew;

@property (nonatomic, strong) MCItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

@end
