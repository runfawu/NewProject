//
//  QRDetailController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-22.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "QRDetailController.h"

@interface QRDetailController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation QRDetailController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enableBack = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.URLString = [self.URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];;
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLString]]];
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    
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

#pragma mark - WebView delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    return YES;
}

- (void)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
