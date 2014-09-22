//
//  Utility.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "Utility.h"
#import "Reachability.h"

@implementation Utility

+ (BOOL)isValidMobile:(NSString *)mobile
{
    NSString *phoneRegex = @"^1([3-5]|7|8)\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}

+ (BOOL)isValidPassword:(NSString *)password
{
    NSString *pwdRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pwdRegex];
    
    return [predicate evaluateWithObject:password];
}

+ (BOOL)isNetworkReachable
{
    DLog(@"网络检查。。。。。。");
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

+ (UIImage *)createImageWithColor:(UIColor *)color rect:(CGRect)rect
{
    CGRect rectRE = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rectRE);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *)getFormerDateWithMonthAgo:(NSInteger)monthAgo
{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMdd";
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:monthAgo];
    NSDate *monthAgoDate = [calendar dateByAddingComponents:components toDate:currentDate options:0];
    
    NSString *monthAgoTime = [formatter stringFromDate:monthAgoDate];
    
    return monthAgoTime;
}

+ (UIImage *)makeRoundedImage:(UIImage *)image radius:(float)radius
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}


@end