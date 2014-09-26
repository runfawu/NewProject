//
//  GestureLockView.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-25.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "GestureLockView.h"
#import "UIImageView+WebCache.h"

@implementation GestureLockView

- (void)dealloc
{
    DLog(@"GestureLockView dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.portraitImageView.layer.cornerRadius = self.portraitImageView.frame.size.height / 2;
    self.portraitImageView.clipsToBounds = YES;
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:[RunTimeData sharedData].userInfoObj.picBase64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
    self.portraitImageView.image = [UIImage imageWithData:imageData];
    
    self.lockView.normalGestureNodeImage = [UIImage imageNamed:@"dot_off"];
    self.lockView.selectedGestureNodeImage = [UIImage imageNamed:@"dot_on"];
    self.lockView.lineColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    self.lockView.lineWidth = 10;
    self.lockView.delegate = self;
    
    self.remainChangeCount = 5;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat lockViewWidth = self.lockView.frame.size.width;
    CGFloat lockViewHeight = self.lockView.frame.size.height;
    self.lockView.frame = CGRectMake(SCREEN_WIDTH/2 - lockViewWidth/2, SCREEN_HEIGHT-180-lockViewHeight/2, lockViewWidth, lockViewHeight);
    
    CGRect frame = self.forgetButton.frame;
    frame.origin.y = self.lockView.frame.origin.y + self.lockView.frame.size.height + 15;
    self.forgetButton.frame = frame;
}

+ (GestureLockView *)loadNibInstance
{
    NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"GestureLockView" owner:self options:nil];
    GestureLockView *instance = nibArray[0];
    
    
    return instance;
}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didBeginWithPasscode:(NSString *)passcode{

}

- (void)gestureLockView:(KKGestureLockView *)gestureLockView didEndWithPasscode:(NSString *)passcode{
    DLog(@"解锁密码 ＝ %@",passcode);
    
    NSDictionary *accountDict = [USER_DEFAULT objectForKey:ACCOUNT_INFO];
    NSString *gesturePassword = accountDict[kGesturePassword];
    if ([gesturePassword isEqualToString:passcode]) {
        [self postLoginRequest];
    } else {
        _remainChangeCount --;
        self.stateLabel.text = [NSString stringWithFormat:@"密码错误，还可以再输入%d次", _remainChangeCount];
        self.stateLabel.textColor = [UIColor redColor];
        if (_remainChangeCount == 0) {
            if ([self.delegate respondsToSelector:@selector(gestureLockViewDidFaild:)]) {
                [self.delegate gestureLockViewDidFaild:self];
            }
        }
    }
}

- (void)removeFromWindow
{
    CGRect frame = self.frame;
    frame.origin.y = frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = frame;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)forgetGesturePassword:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(gestureLockViewDidFaild:)]) {
        [self.delegate gestureLockViewDidFaild:self];
    }
}


//放在这里做登陆请求感觉怪怪的...
#pragma mark - Login request
- (void)postLoginRequest
{
    CHECK_NETWORK_AND_SHOW_TOAST(self);
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    NSDictionary *accountDict = [USER_DEFAULT objectForKey:ACCOUNT_INFO];
    NSString *userName = accountDict[kUserName];
    NSString *password = accountDict[kPassword];
    
    NSString *url = [NSString stringWithFormat:@"%@/account/login.do", HOST_URL];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userName forKey:@"userid"];
    [paramDict setObject:password forKey:@"passwd"];
    
    self.loginRequest = [[HttpRequest alloc] init];
    __weak typeof(self) weakSelf = self;
    [self.loginRequest postRequestWithURLString:url params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        weakSelf.loginRequest = nil;
        [weakSelf parseDataOfLogin:result];
        DLog(@"unlock gesture login success = %@", result);
    } failureBlock:^(NSString *failureString) {
        weakSelf.loginRequest = nil;
        [MBProgressHUD hideHUDForView:weakSelf animated:YES];
        SHOW_BAD_NET_TOAST(weakSelf);
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
        
        UserInfoObject *userInfo = [[UserInfoObject alloc] init];
        userInfo.sex = sex;
        userInfo.userName = userName;
        userInfo.picBase64 = picBase64;
        userInfo.token = token;
        userInfo.userId = userId;
        userInfo.barCode = barCode;
        userInfo.headPhotoURL = headPhotoURL;
        
        RunTimeData *userModel = [RunTimeData sharedData];
        userModel.hasLogin = YES;
        userModel.userInfoObj = userInfo;
        [userModel saveData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kGestureLockLoginDidSuccessNotification object:nil userInfo:nil];
        
        [self removeFromWindow];
    } else {
        SHOW_ERROR_MESSAGE_TOAST(self);
    }
}

@end
