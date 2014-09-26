//
//  WelComeController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-9.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "WelComeController.h"

@interface WelComeController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;

@end

@implementation WelComeController

- (void)dealloc
{
    DLog(@"WelComeController dealloc");
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
    [self configWelcomeImageView];
}

static const int welcomeImageCount = 3;
- (void)configWelcomeImageView
{
    for (int i = 0; i < welcomeImageCount; i ++) {
        NSString *imageNameString = iPhone5 ? @"welcome_4.0_" : @"welcome_3.5_";
        NSString *imageName = [NSString stringWithFormat:@"%@%d.png", imageNameString, i];
        UIImage *image = [UIImage imageNamed:imageName];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.scrollView addSubview:imageView];
        
        if (i == welcomeImageCount - 1) {
            UIButton *surfButton = [UIButton buttonWithType:UIButtonTypeCustom];
            surfButton.frame = CGRectMake(0, 0, 150, 36);
            CGFloat value = iPhone5 ? 70.0 : 55.0;
            surfButton.center = CGPointMake(SCREEN_WIDTH / 2, imageView.frame.size.height - value);
            [surfButton setTitle:@"立即体验" forState:UIControlStateNormal];
            surfButton.titleLabel.font = [UIFont systemFontOfSize:15];
            [surfButton setBackgroundImage:[UIImage imageNamed:@"login_login_n"] forState:UIControlStateNormal];
            [surfButton setBackgroundImage:[UIImage imageNamed:@"login_login_h"] forState:UIControlStateHighlighted];
            [surfButton addTarget:self action:@selector(surfingInTheAppNow:) forControlEvents:UIControlEventTouchUpInside];
            
            imageView.userInteractionEnabled = YES;
            [imageView addSubview:surfButton];
        }
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * welcomeImageCount, SCREEN_HEIGHT);
    
    [self configPageControl];
}

- (void)configPageControl
{
    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(0, 0, 100, 20);
    self.pageControl.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 20);
    self.pageControl.numberOfPages = welcomeImageCount;
    [self.view addSubview:self.pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint offset = scrollView.contentOffset;
    self.pageControl.currentPage = round(offset.x / scrollView.frame.size.width);
}

- (void)surfingInTheAppNow:(UIButton *)button
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    __weak typeof(&*self) weakSelf = self;
    [self dismissViewControllerAnimated:NO completion:^{
        if ([weakSelf.delegate respondsToSelector:@selector(welcomControllerShouldEnterMainPage:)]) {
            [weakSelf.delegate welcomControllerShouldEnterMainPage:weakSelf];
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
