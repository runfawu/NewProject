//
//  QRDetailController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-22.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "QRDetailController.h"

@interface QRDetailController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation QRDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enableBack = YES;
        self.title = @"二维码详情";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
