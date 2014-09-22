//
//  RetryView.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-16.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "RetryView.h"

@implementation RetryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (RetryView *)loadNibInstance
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"RetryView" owner:self options:nil];
    RetryView *view = nibArray[0];
    
    return view;
}

@end
