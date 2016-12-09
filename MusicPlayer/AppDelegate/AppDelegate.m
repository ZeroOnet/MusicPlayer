//
//  AppDelegate.m
//  MusicPlayer
//
//  Created by FunctionMaker on 2016/11/2.
//  Copyright © 2016年 FunctionMaker. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[MusicViewController alloc] init]];
    _window.rootViewController = navVC;
    
    [_window makeKeyAndVisible];
    
    return YES;
}

@end
