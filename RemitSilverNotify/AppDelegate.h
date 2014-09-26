//
//  AppDelegate.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "GestureLockView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, GestureLockViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) MainViewController *mainController;


@end
