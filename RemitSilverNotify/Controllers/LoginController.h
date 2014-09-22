//
//  LoginController.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-10.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "BaseViewController.h"

typedef void (^LoginBlock)(int index);

@interface LoginController : BaseViewController

@property (nonatomic, copy) LoginBlock loginBlock;

@end
