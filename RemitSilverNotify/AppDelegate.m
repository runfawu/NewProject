//
//  AppDelegate.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "AppDelegate.h"
#import "GestureLockController.h"
#import "WelComeController.h"
#import "LoginController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIRGBMAKE(239, 247, 246);
    
    RunTimeData *userData = [RunTimeData sharedData];
    [userData readData];
    
    DLog(@"user data = %@", userData.userInfoObj.userId);
    
    self.mainController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    self.window.rootViewController = self.mainController;
    [self.window makeKeyAndVisible];
    
    [self checkoutGesturePassword];
    
    BOOL hasLaunched = [USER_DEFAULT boolForKey:kHasLaunched];
    if ( ! hasLaunched) {
        [USER_DEFAULT setBool:YES forKey:kHasLaunched];
        [USER_DEFAULT synchronize];
        
        [self.mainController presentWelcomePage];
    }
    
    
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
//    [[RunTimeData sharedData] saveData];
    
    DLog(@"applicationWillResignActive");
   
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DLog(@"applicationDidEnterBackground 杀掉程序了？");
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DLog(@"applicationWillEnterForeground");
    
    [[RunTimeData sharedData] readData];
    DLog(@"user data = %@", [RunTimeData sharedData].userInfoObj.userId);
    
    [self checkoutGesturePassword];
    
}

- (void)checkoutGesturePassword
{
    NSDictionary *accountDict = [USER_DEFAULT objectForKey:ACCOUNT_INFO];
    NSString *gesturePassword = accountDict[kGesturePassword];
    if (gesturePassword) {
        GestureLockView *lockView = [GestureLockView loadNibInstance];
        lockView.frame = self.window.bounds;
        lockView.delegate = self;
        
        [self.window addSubview:lockView];
    }
}

#pragma mark - Unlock gesturePassword
- (void)gestureLockViewDidFaild:(GestureLockView *)lockView
{
    [self.mainController presentLogin];
    [lockView removeFromSuperview];
}
     

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    DLog(@"applicationDidBecomeActive");
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    DLog(@"applicationWillTerminate 将要杀掉程序了？");
}

@end
