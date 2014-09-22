//
//  RegisterController.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "BaseViewController.h"

typedef NS_ENUM(NSUInteger, FunctionState) {
    FunctionStateRegister = 250,
    FunctionStateForgetPwd
};
typedef void (^MobileBlock)(NSString *mobile);

@interface RegisterController : BaseViewController

@property (nonatomic, assign) FunctionState state;
@property (nonatomic, copy) MobileBlock mobileBlock;

@end
