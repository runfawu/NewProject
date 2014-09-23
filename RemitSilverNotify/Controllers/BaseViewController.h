//
//  BaseViewController.h
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

//@property (nonatomic) BOOL showNavi;
@property (nonatomic) BOOL enableBack;
@property (nonatomic) BOOL showBgImage;

- (void)clickBack:(id)sender;

@end
