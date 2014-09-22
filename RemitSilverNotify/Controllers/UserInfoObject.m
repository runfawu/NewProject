//
//  UserInfoObject.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#define kSex            @"sex"
#define kUserName       @"userName"
#define kPicBase64      @"picBase64"
#define kToken          @"token"
#define kUserId         @"userId"
#define kBarCode        @"barCode"
#define kHeadPhotoURL   @"headPhotoURL"

#import "UserInfoObject.h"

/*
 *sex;
 @property (nonatomic, strong) NSString *userName;
 @property (nonatomic, strong) NSString *picBase64;
 @property (nonatomic, strong) NSString *token;
 @property (nonatomic, strong) NSString *userId;
 @property (nonatomic, strong) NSString *barCode;
 @property (nonatomic, strong) NSString *headPhotoURL;
 */

@implementation UserInfoObject

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.sex = [aDecoder decodeObjectForKey:kSex];
        self.userName = [aDecoder decodeObjectForKey:kUserName];
        self.picBase64 = [aDecoder decodeObjectForKey:kPicBase64];
        self.token = [aDecoder decodeObjectForKey:kToken];
        self.userId = [aDecoder decodeObjectForKey:kUserId];
        self.barCode = [aDecoder decodeObjectForKey:kBarCode];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.sex forKey:kSex];
    [aCoder encodeObject:self.userName forKey:kUserName];
    [aCoder encodeObject:self.picBase64 forKey:kPicBase64];
    [aCoder encodeObject:self.token forKey:kToken];
    [aCoder encodeObject:self.userId forKey:kUserId];
    [aCoder encodeObject:self.barCode forKey:kBarCode];
    [aCoder encodeObject:self.headPhotoURL forKey:kHeadPhotoURL];
}

@end
