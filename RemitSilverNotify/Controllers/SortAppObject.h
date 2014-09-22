//
//  SortAppObject.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppObject.h"

@interface SortAppObject : NSObject

@property (nonatomic, strong) NSString *typeId;
@property (nonatomic, strong) NSString *typeName;
@property (nonatomic, strong) NSMutableArray *appArray;
@property (nonatomic, assign) BOOL shouldOpen;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
