//
//  WelComeController.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-9.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WelComeController;
@protocol WelComeControllerDelegate <NSObject>

- (void)welcomControllerShouldEnterMainPage:(WelComeController *)wecomeController;

@end

@interface WelComeController : UIViewController

@property (nonatomic, weak) id<WelComeControllerDelegate> delegate;

@end
