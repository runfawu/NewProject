//
//  GestureLockView.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-25.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGestureLockView.h"

@interface GestureLockView : UIView<KKGestureLockViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet KKGestureLockView *lockView;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;

+ (GestureLockView *)loadNibInstance;

@end
