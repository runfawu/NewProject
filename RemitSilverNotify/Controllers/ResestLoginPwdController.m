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
@property (weak, nonatomic) IBOutlet UITextField *newPasswordTextField;

@end

@implementation ResestLoginPwdController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self configRightBarButtonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)configRightBarButtonItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(18, 0, 45, 26);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"main_confim_n"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"main_confim_h"] forState:UIControlStateHighlighted];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(commitP:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

@end
