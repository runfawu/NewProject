//
//  SafetyViewController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-23.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "SafetyViewController.h"

@interface SafetyViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation SafetyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.enableBack = YES;
        self.title = @"安全中心";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button events
- (IBAction)buttonClicked:(UIButton *)sender {
    switch (sender.tag) {
        case 720: //手势密码锁定
        {
            
        }
            break;
        case 721: //修改登陆密码
        {
            
        }
            break;
        case 722: //修改备付金密码
        {
            
        }
            break;
        default:
            break;
    }
}


#pragma mark - Override
- (void)clickBack:(id)sender
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
