//
//  AppDelegate.m
//  HomePwner
//
//  Created by Matthew Chupp on 3/18/15.
//  Copyright (c) 2015 MattChupp. All rights reserved.
//

#import "AppDelegate.h"
#import "MCItemsViewController.h"
#import "MCItemStore.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // override point
    
    // create a MCItemsViewController
    MCItemsViewController *itemsViewController = [[MCItemsViewController alloc] init];
    
    // create an instance of a UINavigationController
    // its stack contains only itemsViewController
    UINavigationController *navController = [[UINavigationController alloc]
                                                initWithRootViewController:itemsViewController];
    
    // place navigation controllers in view hierarchy and remove itemsViewController
    // as the root view controller
    self.window.rootViewController = navController;
    
    // place the MCItemsViewController's table view in the window hierarchy
    // self.window.rootViewController = itemsViewController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    BOOL success = [[MCItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the MCItems");
    } else {
        NSLog(@"Cound not save any of the MCItems");
    }
    
}


@end
