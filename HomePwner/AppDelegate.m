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


- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // override point
    
    if (!self.window.rootViewController) {
    
        // create a MCItemsViewController
        MCItemsViewController *itemsViewController = [[MCItemsViewController alloc] init];
        
        // create an instance of a UINavigationController
        // its stack contains only itemsViewController
        UINavigationController *navController = [[UINavigationController alloc]
                                                    initWithRootViewController:itemsViewController];
        
        // Give the navigation controller a restorations identifier that is
        // the same name as the class
        navController.restorationIdentifier = NSStringFromClass([navController class]);
        
        // place navigation controllers in view hierarchy and remove itemsViewController
        // as the root view controller
        self.window.rootViewController = navController;
        
        // place the MCItemsViewController's table view in the window hierarchy
        // self.window.rootViewController = itemsViewController;
    }

    //self.window.backgroundColor = [UIColor whiteColor];
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

- (BOOL)application:(UIApplication *)application
willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
shouldSaveApplicationState:(NSCoder *)coder {
    return YES;
}

- (BOOL)application:(UIApplication *)application
shouldRestoreApplicationState:(NSCoder *)coder {
    return YES;
}

- (UIViewController *)application:(UIApplication *)application
viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents
                            coder:(NSCoder *)coder {
    
    // Create a new navigation controller
    UIViewController *vc = [[UINavigationController alloc] init];
    
    // The last object in the path array is the restoration
    // identifier for this view controller
    vc.restorationIdentifier = [identifierComponents lastObject];
    
    if ([identifierComponents count] == 1) {
        // If there is only 1 identifier component, then
        // this is the root view controller
        self.window.rootViewController = vc;
    }
    else {
        // Else, it is the navigation controller for a new item,
        // so you need to set its modal presentation style
        vc.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    return vc; 
}


@end





















