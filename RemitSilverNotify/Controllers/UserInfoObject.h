//
//  UserInfoObject.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoObject : NSObject<NSCoding>

@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *picBase64;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *barCode;
@property (nonatomic, strong) NSString *headPhotoURL;



@end
