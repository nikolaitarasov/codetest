//
//  AppDelegate.m
//  codetest
//
//  Created by Nikolai Tarasov on 9/12/16.
//  Copyright © 2016 Nikolai Tarasov. All rights reserved.
//

#import "AppDelegate.h"
#import "CustomerListViewController.h"
#import "ProfileTableViewController.h"

@interface AppDelegate ()

@end

@import UIKit;
@import Firebase;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:(45.0/255.0) green:(152.0/255.0) blue:(231.0/255.0) alpha:1.0]];
    
    [FIRApp configure];
    
    // If User is signed in go directly to Customer List View
    /*FIRUser *user = [FIRAuth auth].currentUser;
    if (user != nil) {
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UITabBarController* tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"UITabBarController"];
        CustomerListViewController* vc1 = [[CustomerListViewController alloc] init];
        ProfileTableViewController* vc2 = [[ProfileTableViewController alloc] init];
        UINavigationController *firstNavigationController = [storyboard instantiateViewControllerWithIdentifier:@"UINavigationController2"];
        UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:vc2];
        [firstNavigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [secondNavigationController.navigationBar
         setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        [tabBarController setViewControllers:@[firstNavigationController, secondNavigationController] animated:NO];
        tabBarController.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.window.rootViewController = tabBarController;
    }*/
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
