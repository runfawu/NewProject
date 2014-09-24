//
//  BaseViewController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIRGBMAKE(239, 247, 246);
    if (self.showBgImage) {
        [self createBgImageView];
    }
    [self configNavigationBar];
    
    if (self.showRightBarButtonItem) {
        [self configRightBarButtonItem];
    }
}

- (void)createBgImageView
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImageView.image = [UIImage imageNamed:@"main_bg"];
    [self.view addSubview:bgImageView];
    [self.view sendSubviewToBack:bgImageView];
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
    [rightButton addTarget:self action:@selector(clickRightBarButtonItem:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

- (void)configNavigationBar
{
    UIImage *image = [[UIImage imageNamed:@"tabbar_bg"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(-1, 0);
    shadow.shadowBlurRadius = 5;
    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:15],
                                                                    NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                    }; //NSShadowAttributeName : shadow
    if (self.enableBack) {
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setImage:[UIImage imageNamed:@"main_back.png"] forState:UIControlStateNormal];
        backButton.frame = CGRectMake(0, 12, 20, 19);
        [backButton addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)clickBack:(id)sender
{
    DLog(@"base controller click back");
}

- (void)clickRightBarButtonItem:(id)sender
{
    DLog(@"base controller click rightBarButtonItem");
}

@end
