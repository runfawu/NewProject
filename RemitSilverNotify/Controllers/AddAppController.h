//
//  AddAppController.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "BaseViewController.h"

@interface AddAppController : BaseViewController

@property (nonatomic, strong) NSArray *appArray; /**< 界面要显示的app array */
@property (nonatomic, strong) NSMutableArray *existedAppArray;

@end


