//
//  AppDelegate.m
//  PlayerKitDemo
//
//  Created by majiancheng on 2017/12/8.
//  Copyright © 2017年 majiancheng. All rights reserved.
//

#import "AppDelegate.h"

#import "PlayerCategroiesTableController.h"
#import "MCNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    PlayerCategroiesTableController *playerCategroiesTableController = [[PlayerCategroiesTableController alloc] initWithParams:nil];
    MCNavigationController *navigationController = [[MCNavigationController alloc] initWithRootViewController:playerCategroiesTableController];
    self.window.rootViewController = navigationController;

    [self.window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
}


- (void)applicationWillTerminate:(UIApplication *)application {
}


@end
