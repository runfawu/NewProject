//
//  UserInfoModel.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoObject.h"

@interface RunTimeData : NSObject

@property (nonatomic, strong) UserInfoObject *userInfoObj;
@property (nonatomic, assign) BOOL hasLogin;

+ (RunTimeData *)sharedData;
- (void)saveData;
- (void)readData;

@end
