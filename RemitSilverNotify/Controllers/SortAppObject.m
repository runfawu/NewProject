//
//  SortAppObject.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "SortAppObject.h"

@implementation SortAppObject

/*
 @property (nonatomic, strong) NSString *userid;
 @property (nonatomic, strong) NSString *busicode;
 @property (nonatomic, strong) NSString *businame;
 @property (nonatomic, strong) NSString *picsrc;
 @property (nonatomic, strong) NSString *linksrc;
 @property (nonatomic, strong) NSString *areacode;
 @property (nonatomic, strong) NSString *areaname;
 */

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.typeId = dict[@"typeid"];
        self.typeName = dict[@"typename"];
        self.shouldOpen = NO;
        
        id obj = dict[@"apps"];
        self.appArray = [NSMutableArray array];
        if ( ! [obj isKindOfClass:NSNull.class ]) {
            NSArray *appArray = obj;
            if (appArray.count > 0) {
                for (NSDictionary *dict in appArray) {
                    AppObject *appObj = [[AppObject alloc] init];
                    appObj.busicode = dict[@"busicode"];
                    appObj.businame = dict[@"businame"];
                    appObj.picsrc = dict[@"picsrc"];
                    appObj.linksrc = dict[@"linksrc"];
                    appObj.areacode = dict[@"areacode"];
                    appObj.areaname = dict[@"areaname"];
                    //appObj.actiontype = kDefaultAction;
                    [self.appArray addObject:appObj];
                }
            }
        }
    }
    
    return self;
}

@end
