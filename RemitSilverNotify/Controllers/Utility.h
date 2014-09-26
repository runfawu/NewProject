//
//  Utility.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

+ (BOOL)isValidMobile:(NSString *)mobile;
+ (BOOL)isNetworkReachable;
+ (BOOL)isValidPassword:(NSString *)password;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (NSString *)getFormerDateWithMonthAgo:(NSInteger)monthAgo;
+ (UIImage *)makeRoundedImage:(UIImage *)image radius:(float)radius;

@end
