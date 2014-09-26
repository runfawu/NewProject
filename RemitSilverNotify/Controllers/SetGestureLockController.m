//
//  SetGestureLockController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-25.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "SetGestureLockController.h"
#import "GestureLockController.h"

@interface SetGestureLockController ()
@property (weak, nonatomic) IBOutlet UISwitch *gestureSwitch;
@property (weak, nonatomic) IBOutlet UIView *setLockView;
@property (weak, nonatomic) IBOutlet UILabel *setStateLabel;

@end

@implementation SetGestureLockController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enableBack = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSDictionary *accountDict = [USER_DEFAULT objectForKey:ACCOUNT_INFO];
    NSString *gesturePassword = accountDict[kGesturePassword];
    if (gesturePassword) {
        self.gestureSwitch.on = YES;
        self.setLockView.alpha = 1;
    }
}

- (void)setup
{
    self.setLockView.alpha = 0;
}

- (IBAction)gestureSwitchValueChanged:(UISwitch *)sender {
    if (sender.on) {
        NSDictionary *accountDict = [USER_DEFAULT objectForKey:ACCOUNT_INFO];
        NSString *gesturePassword = accountDict[kGesturePassword];
        if ( ! gesturePassword) {
            self.setStateLabel.text = @"设置手势密码";
        }
        [UIView animateWithDuration:0.25 animations:^{
            self.setLockView.alpha = 1;
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.setLockView.alpha = 0;
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setLockButtonClicked:(id)sender {
    GestureLockController *gestureController = [[GestureLockController alloc] initWithNibName:@"GestureLockController" bundle:nil];

    [self.navigationController pushViewController:gestureController animated:YES];
    
}

- (void)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
