//
//  SafetyViewController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-23.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "SafetyViewController.h"
#import "ResestLoginPwdController.h"
#import "QRDetailController.h"
#import "SetGestureLockController.h"

@interface SafetyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation SafetyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enableBack = YES;
        self.title = @"安全中心";
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
        self.statusLabel.text = @"开启";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setup
{
    self.view.backgroundColor = UIRGBMAKE(239, 247, 246);
}

#pragma mark - Button events
//手势密码锁定
- (IBAction)gestureLockButtonClicked:(UIButton *)sender {
    SetGestureLockController *gestureLockController = [[SetGestureLockController alloc] initWithNibName:@"SetGestureLockController" bundle:nil];
    
    [self.navigationController pushViewController:gestureLockController animated:YES];
    
}

- (IBAction)setSecretButtonClicked:(id)sender {
}

- (IBAction)fillInIdentifyButtonClicked:(id)sender {
}

- (IBAction)resetLoginPassword:(id)sender {
    ResestLoginPwdController *loginPwdController = [[ResestLoginPwdController alloc] initWithNibName:@"ResestLoginPwdController" bundle:nil];
    
    [self.navigationController pushViewController:loginPwdController animated:YES];
}

//找回备付金密码
- (IBAction)resetPaymentPassword:(id)sender {
    QRDetailController *webViewController = [[QRDetailController alloc] initWithNibName:@"QRDetailController" bundle:nil];
    //http://ip:port:/inpay_mbphone/page/getPage.do?data={pbusicode=100005}
    webViewController.URLString = [NSString stringWithFormat:@"%@/page/getPage.do?data={pbusicode=100005}", HOST_URL];
    webViewController.title = @"修改备付金密码";
    
    [self.navigationController pushViewController:webViewController animated:YES];
}


#pragma mark - Override
- (void)clickBack:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}



@end
