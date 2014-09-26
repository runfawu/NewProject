//
//  GestureLockView.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-25.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKGestureLockView.h"

@class GestureLockView;
@protocol GestureLockViewDelegate <NSObject>

- (void)gestureLockViewDidFaild:(GestureLockView *)lockView;

@end

@interface GestureLockView : UIView<KKGestureLockViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet KKGestureLockView *lockView;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (nonatomic, assign) int remainChangeCount;
@property (nonatomic, weak) id<GestureLockViewDelegate> delegate;

@property (nonatomic, strong) HttpRequest *loginRequest;

+ (GestureLockView *)loadNibInstance;

@end
