//
//  MainViewController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#define kBottomButtonCount    5
#define kBaseButtonTag        100

#import "MainViewController.h"
#import "NewsViewController.h"
#import "ApplicationsController.h"
#import "HomeViewController.h"
#import "TradeViewController.h"
#import "MoreViewController.h"
#import "WelComeController.h"
#import "LoginController.h"
#import "RunTimeData.h"

@interface MainViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *tabbarImageView;

@property (weak, nonatomic) IBOutlet UIButton *newsButton;
@property (weak, nonatomic) IBOutlet UIButton *appsButton;
@property (weak, nonatomic) IBOutlet UIButton *homeButton;
@property (weak, nonatomic) IBOutlet UIButton *tradeButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic, strong) NewsViewController *newsController;
@property (nonatomic, strong) ApplicationsController *appsController;
@property (nonatomic, strong) HomeViewController *homeController;
@property (nonatomic, strong) TradeViewController *tradeController;
@property (nonatomic, strong) MoreViewController *moreController;

@property (nonatomic) NSInteger lastIndex;

@end

@implementation MainViewController

#pragma mark - Lifecycle
- (void)dealloc
{
    DLog(@"MianViewController dealloc");
}

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
    [self initScrollView];
    [self setup];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.mainScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TABBAR_HEIGHT);
    self.tabbarImageView.frame = CGRectMake(0, SCREEN_HEIGHT - TABBAR_HEIGHT, SCREEN_WIDTH, TABBAR_HEIGHT);

    CGFloat centerButtonWidth = 70;
    CGFloat centerButtonHeight = 70;
    CGFloat centerButtonY = SCREEN_HEIGHT - centerButtonHeight;
    
    CGFloat eachFourButtonWidth = (SCREEN_WIDTH - 70) / 4;
    CGFloat eachFourButtonHeight = TABBAR_HEIGHT;
    CGFloat eachFourButtonY = SCREEN_HEIGHT - eachFourButtonHeight;
    
    self.newsButton.frame = CGRectMake(0, eachFourButtonY, eachFourButtonWidth, eachFourButtonHeight);
    self.appsButton.frame = CGRectMake(eachFourButtonWidth, eachFourButtonY, eachFourButtonWidth, eachFourButtonHeight);
    self.moreButton.frame = CGRectMake(SCREEN_WIDTH - eachFourButtonWidth, eachFourButtonY, eachFourButtonWidth, eachFourButtonHeight);
    self.tradeButton.frame = CGRectMake(SCREEN_WIDTH - 2 * eachFourButtonWidth, eachFourButtonY, eachFourButtonWidth, eachFourButtonHeight);
    self.homeButton.frame = CGRectMake(SCREEN_WIDTH / 2 - centerButtonWidth / 2, centerButtonY, centerButtonWidth, centerButtonHeight);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Private methods
- (void)initScrollView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGFloat width = SCREEN_WIDTH;
    CGFloat height = SCREEN_HEIGHT - 49;
    self.mainScrollView.contentSize = CGSizeMake(width * kBottomButtonCount, height);
    
    self.newsController = [[NewsViewController alloc] initWithNibName:@"NewsViewController" bundle:nil];
    self.newsController.view.frame = CGRectMake(0 * width, 0, width, height);
    
    self.appsController = [[ApplicationsController alloc] initWithNibName:@"ApplicationsController" bundle:nil];
    self.appsController.view.frame = CGRectMake(1 * width, 0, width, height);
    if (iPhone4) {
        self.appsController.view.frame = CGRectMake(1 * width, 0, width, height + 88);
    }
    
    self.homeController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    self.homeController.view.frame = CGRectMake(2 * width, 0, width, height);
    
    self.tradeController = [[TradeViewController alloc] initWithNibName:@"TradeViewController" bundle:nil];
    self.tradeController.view.frame = CGRectMake(3 * width, 0, width, height);
    
    self.moreController = [[MoreViewController alloc] initWithNibName:@"MoreViewController" bundle:nil];
    self.moreController.view.frame = CGRectMake(4 * width, 0, width, height);
    if (iPhone4) {
        self.moreController.view.frame = CGRectMake(4 * width, 0, width, height + 88);
    }
    
    [self.mainScrollView addSubview:self.newsController.view];
    [self.mainScrollView addSubview:self.appsController.view];
    [self.mainScrollView addSubview:self.homeController.view];
    [self.mainScrollView addSubview:self.tradeController.view];
    [self.mainScrollView addSubview:self.moreController.view];
}

- (void)setup
{
    self.lastIndex = 2;
    self.homeButton.selected = YES;
    self.mainScrollView.contentOffset = CGPointMake(2 * CGRectGetWidth(self.mainScrollView.frame), 0);
    
    [self.newsButton setImage:[UIImage imageNamed:@"tabbar_profile_sel"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.appsButton setImage:[UIImage imageNamed:@"tabbar_apps_sel"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.homeButton setImage:[UIImage imageNamed:@"tabbar_home_sel"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.tradeButton setImage:[UIImage imageNamed:@"tabbar_trade_sel"] forState:UIControlStateHighlighted | UIControlStateSelected];
    [self.moreButton setImage:[UIImage imageNamed:@"tabbar_more_sel"] forState:UIControlStateHighlighted | UIControlStateSelected];
}

- (void)changeButtonImageState:(NSInteger)index
{
    UIButton *lastButton = (UIButton *)[self.view viewWithTag:kBaseButtonTag + _lastIndex];
    lastButton.selected = NO;
    UIButton *thisButton = (UIButton *)[self.view viewWithTag:kBaseButtonTag + index];
    thisButton.selected = YES;
    self.lastIndex = index;
}

#pragma mark - Button events
- (IBAction)bottomButtonClicked:(UIButton *)sender {
    if (sender.selected) {
        return;
    }
    
    switch (sender.tag) {
        case 100:
        {
            
        }
            break;
        case 101:
        {
            
        }
            break;
        case 102:
        {
            
        }
            break;
        case 103:
        {
            BOOL hasLogin = [RunTimeData sharedData].hasLogin;
            if ( ! hasLogin) {
                LoginController *loginController = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
                UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginController];
                __weak typeof(self) weakSelf = self;
                loginController.loginBlock = ^ (int index){
                    [weakSelf.mainScrollView setContentOffset:CGPointMake(index * self.mainScrollView.frame.size.width, 0) animated:YES];
                    [weakSelf changeButtonImageState:index];
                };
                [self.view.window.rootViewController presentViewController:navi animated:YES completion:nil];
                
                return;
            }
        }
            break;
        case 104:
        {
            
        }
            break;
        default:
            break;
    }
    
    NSInteger index = sender.tag - kBaseButtonTag;
    [self changeButtonImageState:index];
    [self.mainScrollView setContentOffset:CGPointMake(index * CGRectGetWidth(self.mainScrollView.frame), 0) animated:YES];

}

- (void)presentToLoginController
{
    LoginController *loginController = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginController];
    __weak typeof(self) weakSelf = self;
    loginController.loginBlock = ^ (int index){
        [weakSelf.mainScrollView setContentOffset:CGPointMake(index * self.mainScrollView.frame.size.width, 0) animated:YES];
        [weakSelf changeButtonImageState:index];
    };
    [self.view.window.rootViewController presentViewController:navi animated:YES completion:nil];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    int currentPage = fabs(scrollView.contentOffset.x) / scrollView.frame.size.width;
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = round(scrollView.contentOffset.x) / scrollView.frame.size.width;
    [self changeButtonImageState:currentPage];
    if (currentPage == 3 &&  ! [RunTimeData sharedData].hasLogin) {
        LoginController *loginController = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginController];
        __weak typeof(self) weakSelf = self;
        loginController.loginBlock = ^ (int index){
            [weakSelf.mainScrollView setContentOffset:CGPointMake(index * self.mainScrollView.frame.size.width, 0) animated:YES];
            [weakSelf changeButtonImageState:index];
        };
        [self.view.window.rootViewController presentViewController:navi animated:YES completion:nil];
    }
}

#pragma mark - Present welcomePage
- (void)presentLogin
{
    
}

- (void)hideTabbarView
{
    self.newsButton.hidden = YES;
    self.appsButton.hidden = YES;
    self.homeButton.hidden = YES;
    self.tradeButton.hidden = YES;
    self.moreButton.hidden = YES;
    self.tabbarImageView.hidden = YES;
}

- (void)presentWelcomePage
{
    WelComeController *welcomeController = [[WelComeController alloc] initWithNibName:@"WelComeController" bundle:nil];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self presentViewController:welcomeController animated:NO completion:nil];
}

@end
