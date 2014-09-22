//
//  UserInfoModel.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#define kUserInfoArchive   @"userInfoArchive"

#import "RunTimeData.h"

@implementation RunTimeData

+ (RunTimeData *)sharedData
{
    static RunTimeData *_instance = nil;
    static dispatch_once_t oneTaken;
    
    dispatch_once(&oneTaken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (void)saveData
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.userInfoObj forKey:kUserInfoArchive];
    [archiver finishEncoding];
    
    NSString *dataFilePath = [self getDataFilePath];
    [data writeToFile:dataFilePath atomically:YES];
}

- (void)readData
{
    NSString *dataFilePath = [self getDataFilePath];
    NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
    
    if (data.length > 0) {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.userInfoObj = [unarchiver decodeObjectForKey:kUserInfoArchive];
    }
}

- (NSString *)getDataFilePath
{
    NSString *homePath = NSHomeDirectory();
    DLog(@"homePath = %@", homePath);
    NSString *documentPath = [homePath stringByAppendingPathComponent:@"Documents"];
    NSString *dataFilePath = [documentPath stringByAppendingPathComponent:@"userInfo.data"];
    
    return dataFilePath;
}

@end
