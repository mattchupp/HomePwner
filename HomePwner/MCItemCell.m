//
//  MCItemCell.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/31/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCItemCell.h"

@implementation MCItemCell

- (IBAction)showImage:(id)sender {
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end

