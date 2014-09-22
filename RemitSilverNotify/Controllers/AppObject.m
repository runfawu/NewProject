//
//  AppObject.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-9.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "AppObject.h"

@implementation AppObject

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.areacode = dict[@"areacode"];
        self.areaname = dict[@"areaname"];
        self.busicode = dict[@"busicode"];
        self.businame = dict[@"businame"];
        self.linksrc = dict[@"linksrc"];
        self.picsrc = dict[@"picsrc"];
        self.actiontype = kAddAction;
    }
    
    return self;
}

@end
