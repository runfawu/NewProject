//
//  RetryView.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-16.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RetryView : UIView

@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIButton *retryButton;

+ (RetryView *)loadNibInstance;

@end
