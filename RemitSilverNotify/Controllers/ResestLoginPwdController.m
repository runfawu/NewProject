//
//  ResestLoginPwdController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-23.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "ResestLoginPwdController.h"

@interface ResestLoginPwdController ()

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *newerPasswordTextField;

@property (nonatomic, strong) HttpRequest *commitRequest;

@end

@implementation ResestLoginPwdController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enableBack = YES;
        self.showRightBarButtonItem = YES;
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
- (IBAction)closeKeyboard:(id)sender {
    [self.oldPasswordTextField resignFirstResponder];
    [self.newerPasswordTextField resignFirstResponder];
}

#pragma mark - Button events
- (void)commitNewPassword
{
    if (self.oldPasswordTextField.text.length == 0) {
        [self.view makeToast:@"请输入旧密码"];
        return;
    } else if (self.oldPasswordTextField.text.length < 8 || self.oldPasswordTextField.text.length > 16) {
        [self.view makeToast:@"请输入8-16位的旧密码"];
        return;
    } else if ( ! [Utility isValidPassword:self.oldPasswordTextField.text]) {
        [self.view makeToast:@"请输入8-16位数字与字符组合的旧密码"];
        return;
    }  else if (self.newerPasswordTextField.text.length == 0) {
        [self.view makeToast:@"请输入新密码"];
        return;
    } else if (self.newerPasswordTextField.text.length < 8 || self.newerPasswordTextField.text.length > 16) {
        [self.view makeToast:@"请输入8-16位的新密码"];
        return;
    } else if ( ! [Utility isValidPassword:self.newerPasswordTextField.text]) {
        [self.view makeToast:@"请输入8-16位数字与字符组合的新密码"];
        return;
    }
    
    [self requestDataOfResetLoginPassword];
}

- (void)requestDataOfResetLoginPassword
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/account/updateLoginPasswd.do", HOST_URL];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[RunTimeData sharedData].userInfoObj.userId forKey:@"userid"];
    [paramDict setObject:[RunTimeData sharedData].userInfoObj.token forKey:@"token"];
    //FIXME: 未经MD5加密
    [paramDict setObject:self.oldPasswordTextField.text forKey:@"oldpasswd"];
    [paramDict setObject:self.newerPasswordTextField.text forKey:@"newpasswd"]; //未经MD5加密
    
    __weak typeof(&*self) weakSelf = self;
    self.commitRequest = [[HttpRequest alloc] init];
    [self.commitRequest postRequestWithURLString:url params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.commitRequest = nil;
        NSDictionary *resultDict = result;
        if (IS_OK(resultDict)) {
            [weakSelf.view makeToast:@"修改登陆密码成功"];
            [self performSelector:@selector(clickBack:) withObject:nil afterDelay:1];
        } else {
            SHOW_ERROR_MESSAGE_TOAST(weakSelf.view);
        }
    } failureBlock:^(NSString *failureString) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.commitRequest = nil;
        SHOW_BAD_NET_TOAST(weakSelf.view);
    }];
}

#pragma mark - Override
- (void)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickRightBarButtonItem:(id)sender
{
    [self commitNewPassword];
}

@end
