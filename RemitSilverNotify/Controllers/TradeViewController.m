//
//  TradeViewController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "TradeViewController.h"
#import "TradeCell.h"
#import "TradeObject.h"
#import "LeftTradeController.h"
#import "RightTradeController.h"

@interface TradeViewController ()<UIScrollViewDelegate,
                                  UITableViewDataSource,
                                  UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorImageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *leftNoDataView;
@property (weak, nonatomic) IBOutlet UIView *rightNodataView;

@property (nonatomic, strong) HttpRequest *allTradeRequest;

@property (nonatomic, assign) int leftPage;
@property (nonatomic, strong) NSMutableArray *leftTradeArray;
@property (nonatomic, strong) NSMutableArray *rightTradeArray;

@property (nonatomic, strong) LeftTradeController *leftController;
@property (nonatomic, strong) RightTradeController *rightController;

@end

@implementation TradeViewController

#pragma mark - Lifecycel
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

    [self setup];
}

#define kTopHeight   98
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = CGRectMake(0, kTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight - TABBAR_HEIGHT);
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * 2, self.scrollView.bounds.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([RunTimeData sharedData].hasLogin) {
        [self createLeftView];
        [self createRightView];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Private methods
- (void)setup
{
    self.view.backgroundColor = UIRGBMAKE(239, 247, 246);
    
    self.leftTradeArray = [NSMutableArray array];
    self.rightTradeArray = [NSMutableArray array];
    
    self.leftPage = 1;
    self.leftButton.selected = YES;
    
    CGRect frame = self.indicatorImageView.frame;
    frame.size.width = SCREEN_WIDTH / 2;
    self.indicatorImageView.frame = frame;
    
    self.leftButton.frame = CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH / 2, 30);
    self.rightButton.frame = CGRectMake(SCREEN_WIDTH / 2, NAVI_HEIGHT, SCREEN_WIDTH / 2, 30);
    
    self.leftNoDataView.center = CGPointMake(SCREEN_WIDTH / 2, (SCREEN_HEIGHT-kTopHeight - TABBAR_HEIGHT) / 2);
    self.rightNodataView.center = CGPointMake(SCREEN_WIDTH / 2 + SCREEN_WIDTH, (SCREEN_HEIGHT-kTopHeight - TABBAR_HEIGHT) / 2);
    
    self.leftNoDataView.hidden = YES;
    self.rightNodataView.hidden = YES;
    
}

- (void)createLeftView
{
    if ( ! self.leftController) {
        self.leftController = [[LeftTradeController alloc] initWithNibName:@"LeftTradeController" bundle:nil];
        self.leftController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height);
        
        [self.scrollView addSubview:self.leftController.view];
    }
    
}

- (void)createRightView
{
    if ( ! self.rightController) {
        self.rightController = [[RightTradeController alloc] initWithNibName:@"RightTradeController" bundle:nil];
        self.rightController.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, self.scrollView.bounds.size.height);
        
        [self.scrollView addSubview:self.rightController.view];
    }
}

#pragma mark - TableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.leftTradeArray.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 143;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *allTradeIdentifier = @"AllTradeCell";
    TradeCell *cell = [tableView dequeueReusableCellWithIdentifier:allTradeIdentifier];
    
    cell.tradeObj = self.leftTradeArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Button events
- (IBAction)leftButtonClicked:(id)sender {
    if (self.leftButton.selected) {
        return;
    }
    
    self.leftButton.selected = YES;
    self.rightButton.selected = NO;
    
    CGRect frame = self.indicatorImageView.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorImageView.frame = frame;
    }];
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

- (IBAction)rightButtonClicked:(id)sender {
    if (self.rightButton.selected) {
        return;
    }
    
    self.rightButton.selected = YES;
    self.leftButton.selected = NO;
    
    CGRect frame = self.indicatorImageView.frame;
    frame.origin.x = SCREEN_WIDTH / 2;
    [UIView animateWithDuration:0.2 animations:^{
        self.indicatorImageView.frame = frame;
    }];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0) animated:YES];
}

#pragma mark - ScrollView delegate
/*
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = round(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    if (currentPage == 0) {
        self.leftButton.selected = YES;
        self.rightButton.selected = NO;
        
        CGRect frame = self.indicatorImageView.frame;
        frame.origin.x = 0;
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorImageView.frame = frame;
        }];

    } else if (currentPage == 1) {
        self.rightButton.selected = YES;
        self.leftButton.selected = NO;
        
        CGRect frame = self.indicatorImageView.frame;
        frame.origin.x = SCREEN_WIDTH / 2;
        [UIView animateWithDuration:0.25 animations:^{
            self.indicatorImageView.frame = frame;
        }];
    }
}
*/

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int currentPage = fabs(self.scrollView.contentOffset.x / self.scrollView.bounds.size.width);
    if (currentPage == 0) {
        [self leftButtonClicked:nil];
    } else if (currentPage == 1) {
        [self rightButtonClicked:nil];
    }
}

- (void)updateUIWithIndex:(int)index
{
    if (index == 0) {
        
    }
}

@end
