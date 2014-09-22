//
//  AppObject.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-9.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppObject : NSObject

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *busicode;
@property (nonatomic, strong) NSString *businame;
@property (nonatomic, strong) NSString *picsrc;
@property (nonatomic, strong) NSString *linksrc;
@property (nonatomic, strong) NSString *areacode;
@property (nonatomic, strong) NSString *areaname;

@property (nonatomic, strong) NSString *actiontype; /**< 增加减少app类型，0为增加，1为减少*/

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
