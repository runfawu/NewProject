//
//  ScrollImageObject.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-9.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScrollImageObject : NSObject

@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *cententURL;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
