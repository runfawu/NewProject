//
//  KKViewController.m
//  KKGestureLockView
//
//  Created by Luke on 8/5/13.
//  Copyright (c) 2013 geeklu. All rights reserved.
//

#import "GestureLockController.h"
#import "KKGestureLockPreviewView.h"

CGRect autoPositionToIphone4(CGRect rect)
{
    CGRect newRect = rect;
    newRect.origin.y -= 30;
    
    return newRect;
}

@interface GestureLockController ()<KKGestureLockViewDelegate>

@property (weak, nonatomic) IBOutlet KKGestureLockView *lockView;
@property (weak, nonatomic) IBOutlet KKGestureLockPreviewView *boxView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic, strong) NSString *firstPassword;
@property (nonatomic, assign) BOOL hasSet;




@end

@implementation GestureLockController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enableBack = YES;
        self.title = @"手势密码";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"dot_off"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"dot_on"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 10;
    self.lockView.delegate = self;

    self.boxView.userInteractionEnabled = NO;
    self.boxView.normalGestureNodeImage = [UIImage imageNamed:@"one_box"];
    self.boxView.selectedGestureNodeImage = [UIImage imageNamed:@"dot_on"];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (iPhone4) {
        self.stateLabel.frame = autoPositionToIphone4(self.stateLabel.frame);
        self.boxView.frame = autoPositionToIphone4(self.boxView.frame);
        self.lockView.frame = autoPositionToIphone4(self.lockView.frame);
    }

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{
//    NSLog(@"%@",passcode);
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode{
    DLog(@"设置的lockPassCode = %@",passcode);
    
    if (passcode.length < 7) { //0,1,2,3
        [self.view makeToast:@"手势密码至少4位，请重新设置"];
        return;
    }
    if (  _hasSet && [self.firstPassword isEqualToString:passcode]) {
        [self.view makeToast:@"绘制成功"];
        
        NSMutableDictionary *accountDict = [NSMutableDictionary dictionaryWithDictionary:[USER_DEFAULT objectForKey:ACCOUNT_INFO]];
        [accountDict setObject:passcode forKey:kGesturePassword];
        [USER_DEFAULT setObject:accountDict forKey:ACCOUNT_INFO];
        [USER_DEFAULT synchronize];
        
        [self performSelector:@selector(clickBack:) withObject:nil afterDelay:0.5];
    }
    
    if ( ! _hasSet) {
        self.firstPassword = passcode;
        _hasSet = YES;
        self.stateLabel.text = @"请再次绘制解锁图案";
    }
    
    if ( _hasSet && ! [self.firstPassword isEqualToString:passcode]) {
        self.stateLabel.text = @"与上次输入不一致，请重新设置";
        self.boxView.passcode = nil;
        _hasSet = NO;
        return;
    }
    
    self.boxView.passcode = passcode;
}


- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickBack:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
