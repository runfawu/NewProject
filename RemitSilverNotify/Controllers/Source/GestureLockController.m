//
//  KKViewController.m
//  KKGestureLockView
//
//  Created by Luke on 8/5/13.
//  Copyright (c) 2013 geeklu. All rights reserved.
//

#import "GestureLockController.h"
#import "KKGestureLockPreviewView.h"

@interface GestureLockController ()<KKGestureLockViewDelegate>

@property (weak, nonatomic) IBOutlet KKGestureLockView *lockView;
@property (weak, nonatomic) IBOutlet KKGestureLockPreviewView *boxView;
@property (weak, nonatomic) IBOutlet UIImageView *portraitImageView;
@property (weak, nonatomic) IBOutlet UIButton *forgetGestureButton;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (nonatomic, strong) NSString *firstPassword;
@property (nonatomic, assign) BOOL hasSet;
@property (nonatomic, assign) int remainChangeCount;



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

    self.remainChangeCount = 5;
    
    
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"dot_off"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"dot_on"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 10;
    self.lockView.delegate = self;
    self.lockView.contentInsets = UIEdgeInsetsMake(0, 40, 0, 40); //上左下右

    self.boxView.userInteractionEnabled = NO;
    self.boxView.normalGestureNodeImage = [UIImage imageNamed:@"one_box"];
    self.boxView.selectedGestureNodeImage = [UIImage imageNamed:@"dot_on"];
    
    if (_isFromAppDelegate) {
        self.portraitImageView.hidden = NO;
        self.forgetGestureButton.hidden = NO;
        self.boxView.hidden = YES;
        self.stateLabel.text = @"请输入手势密码";
    } else {
        self.portraitImageView.hidden = YES;
        self.forgetGestureButton.hidden = YES;
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.lockView.frame = CGRectMake(0, 140, SCREEN_WIDTH, SCREEN_HEIGHT- NAVI_HEIGHT - 140 - 60);
    self.forgetGestureButton.frame = CGRectMake(SCREEN_WIDTH/2 - 130/2, self.lockView.frame.size.height+self.lockView.frame.origin.y, 130, 30);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    DLog(@"gesture frame = %@", NSStringFromCGRect(self.view.frame));
    
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
    NSLog(@"%@",passcode);

    
    NSString *gesturePassword = [USER_DEFAULT objectForKey:kGesturePassword];
//    BOOL hasSetGesturePassword = [USER_DEFAULT boolForKey:kHasSetGesturePassword];
    
    if ( ! _isFromAppDelegate) {
        if (  _hasSet && [self.firstPassword isEqualToString:passcode]) {
            [self.view makeToast:@"绘制成功"];
//            if ( ! hasSetGesturePassword) {
//                [USER_DEFAULT setBool:YES forKey:kHasSetGesturePassword];
//            }
            [USER_DEFAULT setObject:passcode forKey:kGesturePassword];
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
    } else {
        if (gesturePassword) {
            if ([gesturePassword isEqualToString:passcode]) {
                [self dismiss];
            } else {
                _remainChangeCount --;
                self.stateLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%d次", _remainChangeCount];
                self.stateLabel.textColor = [UIColor redColor];
                if (_remainChangeCount == 0) {
                    [self.view makeToast:@"没机会了"];
                }
            }
            
        }
    }
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
