//
//  MCImageViewController.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/31/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "MCImageViewController.h"


@interface MCImageViewController () 

@property (strong, nonatomic) UIPopoverController *imagePopover; 

@end

@implementation MCImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)loadView {
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.view = imageView; 
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // We must cast the view to the UIImageView so the compiler knows it
    // is okay to send it setImage:
    UIImageView *imageView = (UIImageView *)self.view;
    imageView.image = self.image; 
}

@end
