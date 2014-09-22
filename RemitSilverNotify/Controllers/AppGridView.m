//
//  AppGridView.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-9.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "AppGridView.h"

@implementation AppGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

+ (AppGridView *)getInstance
{
    NSArray *nibsArray = [[NSBundle mainBundle] loadNibNamed:@"AppGridView" owner:self options:nil];
    AppGridView *instance = nibsArray[0];
    
    return instance;
}

@end
