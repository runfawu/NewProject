//
//  RegisterController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-11.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTextField;

@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) HttpRequest *verifyCodeRequest;
@property (nonatomic, strong) HttpRequest *registerRequest;
@property (nonatomic, strong) NSString *mobile;

@end

@implementation RegisterController

#pragma mark - Lifecycle
- (void)dealloc
{

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.showNavi = YES;
        self.enableBack = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Private methods
- (BOOL)isValidMobile
{
    if (self.userNameTextField.text.length == 0) {
        [self.view makeToast:@"请输入手机号"];
        return NO;
    }
    if ( ! [Utility isValidMobile:self.userNameTextField.text]) {
        [self.view makeToast:@"请输入正确的手机号"];
        return NO;
    }
    
    return YES;
}

- (BOOL)isValidPassword
{
    if (self.passwordTextField.text.length < 8 || self.passwordTextField.text.length > 16) {
        [self.view makeToast:@"请输入8-16位的密码"];
        return NO;
    }
    
    return YES;
}

- (void)countDown:(UIButton *)button
{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(timer, ^{
        if(timeout <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                               button.userInteractionEnabled = YES;
                           });
        } else {
            int seconds = timeout % 61;
            dispatch_async(dispatch_get_main_queue(), ^{
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                NSString *title = [NSString stringWithFormat:@"%@秒",strTime];
                [button setTitle:title forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timer);
}

- (void)changeFrameWithYValue:(CGFloat)YValue
{
    CGRect frame = self.view.frame;
    frame.origin.y = YValue;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
    }];
}

#pragma mark - TextField
- (IBAction)closeKeyboard:(id)sender {
    [self changeFrameWithYValue:NAVI_HEIGHT];
    
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPwdTextField resignFirstResponder];
    [self.verifyCodeTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (iPhone4) {
        [self changeFrameWithYValue:-66];
    } else if (iPhone5) {
        [self changeFrameWithYValue:20];
    }
    
    return YES;
}

#pragma mark - Button events
- (IBAction)getVerifyCode:(UIButton *)sender {
    if ([self isValidMobile]) {
        [self countDown:sender];
        [self requestDataOfVerifyCode];
    }
}

- (IBAction)registerNewAccount:(UIButton *)sender {
    if ([self isValidMobile] && [self isValidPassword]) {
        if ( ! [Utility isValidPassword:self.passwordTextField.text]) {
            [self.view makeToast:@"请输入8-16位数字与字符组合的密码"];
            return;
        }
        if (self.confirmPwdTextField.text.length == 0) {
            [self.view makeToast:@"请输入确认密码"];
            return;
        }
        if ( ! [self.confirmPwdTextField.text isEqualToString:self.passwordTextField.text]) {
            [self.view makeToast:@"两次输入的密码不一致,请重新输入"];
            return;
        }
        
        if (self.verifyCodeTextField.text.length == 0) {
            [self.view makeToast:@"请输入短信验证码"];
            return;
        }
        
        [self requestDataOfRegister];
    }
}

#pragma mark - Request data
- (void)requestDataOfVerifyCode
{
    [self showHUDWithView:self.view labelText:nil];
    
    NSString *url = [NSString stringWithFormat:@"%@/account/getRandCode.do", HOST_URL];
    
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.userNameTextField.text forKey:@"mobileno"];
    if (self.state == FunctionStateRegister) {
        [paramDict setObject:@"0" forKey:@"actiontype"]; //0为手机注册时获取，1为找回支付密码时获取
    } else if (self.state == FunctionStateForgetPwd) {
        [paramDict setObject:@"1" forKey:@"actiontype"];
    }
    
    __weak typeof(self) weakSelf = self;
    self.verifyCodeRequest = [[HttpRequest alloc] init];
    [self.verifyCodeRequest postRequestWithURLString:url params:paramDict successBlock:^(id result) {
        [weakSelf hideHUD];
        [weakSelf parseDataOfVerifyCode:result];
        DLog(@"获取验证码success = %@", result);
    } failureBlock:^(NSString *failureString) {
        [weakSelf hideHUD];
        [weakSelf.view makeToast:@"连接服务器失败,请检查网络连接"];
    }];
    
}

- (void)requestDataOfRegister
{
    DLog(@"请求注册接口");
    [self showHUDWithView:self.view labelText:nil];
    
    NSString *url = [NSString stringWithFormat:@"%@/account/regist.do", HOST_URL];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.userNameTextField.text forKey:@"userid"];
    [paramDict setObject:self.verifyCodeTextField.text forKey:@"checkcode"];
    [paramDict setObject:self.confirmPwdTextField.text forKey:@"passwd"];
    
    __weak typeof(self) weakSelf = self;
    
    self.registerRequest = [[HttpRequest alloc] init];
    [self.registerRequest postRequestWithURLString:url params:paramDict successBlock:^(id result) {
        [weakSelf hideHUD];
        [weakSelf parseDataOfRegister:result];
        DLog(@"regiester success = %@", result);
    } failureBlock:^(NSString *failureString) {
        [weakSelf hideHUD];
        SHOW_BAD_NET_TOAST(weakSelf.view);
    }];
}

#pragma mark - Parse data
- (void)parseDataOfVerifyCode:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    if (IS_OK(resultDict)) {
        [self.view makeToast:@"验证码已发送"];
    } else {
        SHOW_ERROR_MESSAGE_TOAST(self.view);
    }
}

- (void)parseDataOfRegister:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    if (IS_OK(resultDict)) {
        NSString *success = resultDict[@"retmsg"];
        [self.view makeToast:success];
        self.mobile = resultDict[@"userid"];
    } else {
        SHOW_ERROR_MESSAGE_TOAST(self.view);
    }
}

#pragma mark - MBHUD loading
- (void)showHUDWithView:(UIView *)view labelText:(NSString *)labelText
{
    if ([Utility isNetworkReachable]) {
        if (_hud == nil) {
            _hud = [[MBProgressHUD alloc] initWithView:view];
        }
        _hud.removeFromSuperViewOnHide = YES;
        [view addSubview:_hud];
        _hud.labelText = labelText;
        [_hud show:YES];
    }
}

- (void)hideHUD
{
    if (_hud) {
        [_hud hide:YES];
    }
}


#pragma mark - Override
- (void)clickBack:(id)sender
{
    if (self.mobile && self.mobileBlock) {
        self.mobileBlock(self.mobile);
    }
    [self.navigationController popViewControllerAnimated:YES];
}


@end
