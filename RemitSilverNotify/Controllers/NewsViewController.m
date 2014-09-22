//
//  ProfileViewController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    DLog(@"News frame = %@", NSStringFromCGRect(self.view.frame));
}

#pragma mark - Private methods
- (void)setup
{
    
    self.view.backgroundColor = UIRGBMAKE(239, 247, 246);
    
    UIImageView *colorImageView = [[UIImageView alloc] init];
    colorImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT);
    colorImageView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:colorImageView];
    [self.view sendSubviewToBack:colorImageView];
    
}


@end
