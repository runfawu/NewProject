//
//  HttpRequest.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-5.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

-(void)dealloc
{
    DLog(@"httpRequester dealloc");
    [self.asiRequest clearDelegatesAndCancel];
    self.asiRequest = nil;
}

- (void)postRequestWithURLString:(NSString *)urlString
                          params:(NSMutableDictionary *)params
                    successBlock:(RequestSuccessfulBlock)successBlock
                    failureBlock:(RequestFailedBlock)failureBlock
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    CHECK_NETWORK_AND_SHOW_TOAST(window);
    
    
    
    self.successBlock = successBlock;
    self.failureBlock = failureBlock;
    
    if ( ! params) {
        params = [NSMutableDictionary dictionary];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error: nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    self.asiRequest = [ASIFormDataRequest requestWithURL:url];
    self.asiRequest.delegate = self;
    self.asiRequest.requestMethod = @"POST";
    self.asiRequest.timeOutSeconds = 10;
    [self.asiRequest addPostValue:jsonString forKey:@"data"];

    [ASIFormDataRequest setShouldUpdateNetworkActivityIndicator:YES];
    
    [self.asiRequest startAsynchronous];

    DLog(@"postURL = %@?data=%@", urlString, jsonString);
}

#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    DLog(@"服务器返回json = %@", request.responseString);
    id result = [NSJSONSerialization JSONObjectWithData:request.responseData options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:nil];
    if (self.successBlock) {
        self.successBlock(result);
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    DLog(@"asiRequest failed: %@", request.error.description);
    
    if (self.failureBlock) {
        self.failureBlock(request.error.description);
    }
}


@end
