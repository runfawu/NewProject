//
//  MainViewController.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LoginType) {
    LoginTypeToTrade = 10,
    LoginTypeToMain
};

@interface MainViewController : UIViewController

@property (nonatomic, assign) LoginType loginType;

- (void)presentWelcomePage;
- (void)presentLogin;
- (void)hideTabbarView;

@end
