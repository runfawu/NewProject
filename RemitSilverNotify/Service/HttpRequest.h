//
//  HttpRequest.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-5.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

typedef void (^RequestSuccessfulBlock)(id result);
typedef void (^RequestFailedBlock)(NSString * failureString);

@interface HttpRequest : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic, strong) ASIFormDataRequest *asiRequest;
@property (nonatomic, copy) RequestSuccessfulBlock successBlock;
@property (nonatomic, copy) RequestFailedBlock failureBlock;

- (void)postRequestWithURLString:(NSString *)urlString
                          params:(NSMutableDictionary *)params
                    successBlock:(RequestSuccessfulBlock)successBlock
                    failureBlock:(RequestFailedBlock)failureBlock;

@end
