//
//  LoginController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-10.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "LoginController.h"
#import "RegisterController.h"
#import "UserInfoObject.h"
#import "RunTimeData.h"

@interface LoginController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIImageView *userNameImageView;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageView;
@property (nonatomic) BOOL flag;

@property (nonatomic, strong) HttpRequest *loginRequest;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation LoginController

#pragma mark - Lifecycle
- (void)dealloc
{
    DLog(@"LoginController dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.showNavi = YES;
        self.enableBack = YES;
        self.title = @"登陆";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userNameImageView.layer.cornerRadius = 6;
    self.userNameImageView.clipsToBounds = YES;
    self.passwordImageView.layer.cornerRadius = 6;
    self.userNameImageView.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.userNameTextField.text = @"13450268906";//@"mlx";  //@"18680471060";
    self.passwordTextField.text = @"a12322a1707fc963f06c66561f2e18a7";  //@"dfm870565013";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - UITextField
- (IBAction)closeKeyboard:(id)sender {
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.frame = frame;
    }];
    
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
    [self.passwordTextField becomeFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (iPhone4) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = frame;
        }];
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (self.passwordTextField == textField) {
        CGRect frame = self.view.frame;
        frame.origin.y = 64;
        [UIView animateWithDuration:0.25 animations:^{
            self.view.frame = frame;
        }];
    }
    
    
    return YES;
}

#pragma mark - Button events
- (IBAction)login:(id)sender {
    if (self.userNameTextField.text.length == 0) {
        [self.view makeToast:@"请输入账号"];
        return;
    }
    if (self.passwordTextField.text.length == 0) {
        [self.view makeToast:@"请输入密码"];
        return;
    }
    [self requestDataOfLogin];
}

- (IBAction)forgetPassword:(id)sender {
    RegisterController *registerController = [[RegisterController alloc] initWithNibName:@"RegisterController" bundle:nil];
    registerController.state = FunctionStateForgetPwd;
    registerController.title = @"忘记密码";
    __weak typeof(self) weakSelf = self;
    registerController.mobileBlock = ^(NSString *mobile) {
        weakSelf.userNameTextField.text = mobile;
    };
    
    [self.navigationController pushViewController:registerController animated:YES];
}

- (IBAction)rigester:(id)sender {
    RegisterController *registerController = [[RegisterController alloc] initWithNibName:@"RegisterController" bundle:nil];
    registerController.state = FunctionStateRegister;
    registerController.title = @"注册";
    __weak typeof(self) weakSelf = self;
    registerController.mobileBlock = ^(NSString *mobile) {
        weakSelf.userNameTextField.text = mobile;
    };
    
    [self.navigationController pushViewController:registerController animated:YES];
    
}

#pragma mark - Request data
- (void)requestDataOfLogin
{
    CHECK_NETWORK_AND_SHOW_TOAST(self.view);
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/account/login.do", HOST_URL];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:self.userNameTextField.text forKey:@"userid"];
    [paramDict setObject:self.passwordTextField.text forKey:@"passwd"];
    
    self.loginRequest = [[HttpRequest alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.loginRequest postRequestWithURLString:url params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.loginRequest = nil;
        [weakSelf parseDataOfLogin:result];
        DLog(@"login success = %@", result);
    } failureBlock:^(NSString *failureString) {
        weakSelf.loginRequest = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        SHOW_BAD_NET_TOAST(weakSelf.view);
    }];
}

- (void)parseDataOfLogin:(id)result
{
    NSDictionary *resultDict = result;
    if (IS_OK(resultDict)) {
        NSString *sex = resultDict[@"sex"];
        NSString *userName = resultDict[@"username"];
        NSString *picBase64 = resultDict[@"picbase64"];
        NSString *token = resultDict[@"token"];
        NSString *userId = resultDict[@"userid"];
        NSString *barCode = resultDict[@"barcode"];
        NSString *headPhotoURL = resultDict[@"headPhotoUrl"];
        DLog(@"userName = %@, id = %@, sex = %@, picBase64 = %@, token = %@, barCode = %@, headPhotoURL = %@", userName, userId, sex, picBase64, token, barCode, headPhotoURL);
        
        UserInfoObject *userInfo = [[UserInfoObject alloc] init];
        userInfo.sex = sex;
        userInfo.userName = userName;
        userInfo.picBase64 = picBase64;
        userInfo.token = token;
        userInfo.userId = userId;
        userInfo.barCode = barCode;
        userInfo.headPhotoURL = headPhotoURL;
    
        RunTimeData *userModel = [RunTimeData sharedData];
        userModel.userInfoObj = userInfo;
        userModel.hasLogin = YES;
        [USER_DEFAULT setBool:YES forKey:kDidAddOrDeleteAppNotification];
        [USER_DEFAULT synchronize];
        
        if (self.loginBlock) {
            self.loginBlock(3);
        }
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    } else {
        SHOW_ERROR_MESSAGE_TOAST(self.view);
    }
}

#pragma mark - Override
- (void)clickBack:(id)sender
{
    if (self.loginBlock) {
        self.loginBlock(2);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
