//
//  ApplicationsController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "ApplicationsController.h"
#import "AppTitleCell.h"
#import "SortAppObject.h"
#import "AppContentCell.h"
#import "AppGridView.h"
#import "UIButton+WebCache.h"
#import "RetryView.h"
#import "AppWebController.h"

@interface ApplicationsController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sortAppArray;
@property (nonatomic, strong) HttpRequest *sortAppRequest;
@property (nonatomic, strong) RetryView *retryView;

@end

@implementation ApplicationsController

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
    [self requestDataOfSortApp];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, NAVI_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVI_HEIGHT - TABBAR_HEIGHT);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Private methods
- (void)setup
{
    self.view.backgroundColor = UIRGBMAKE(239, 247, 246);
    self.sortAppArray = [NSMutableArray array];
    [self.tableView registerNib:[UINib nibWithNibName:@"AppTitleCell" bundle:nil] forCellReuseIdentifier:@"AppTitleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"AppContentCell" bundle:nil] forCellReuseIdentifier:@"AppContentCell"];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.view.userInteractionEnabled = YES;
    self.retryView = [RetryView loadNibInstance];
    [self.retryView.retryButton addTarget:self action:@selector(repostRequest) forControlEvents:UIControlEventTouchUpInside];
    self.retryView.frame = CGRectMake(0, 0, self.retryView.frame.size.width, self.retryView.frame.size.height);
    self.retryView.center = CGPointMake(SCREEN_HEIGHT / 2, (SCREEN_HEIGHT-NAVI_HEIGHT) / 2);
    [self.view addSubview:self.retryView];
    self.retryView.hidden = YES;
    
}

#pragma mark - Request data
- (void)requestDataOfSortApp
{
    CHECK_NETWORK_AND_SHOW_TOAST(self.view);
    DLog(@"333333333333333333");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/app/getAllApps.do", HOST_URL]; // /app/getAllApp.do
    
    __weak typeof(self) weakSelf = self;
    
    self.sortAppRequest = [[HttpRequest alloc] init];
    [self.sortAppRequest postRequestWithURLString:url params:nil successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        DLog(@"Applictaions所有应用列表 ＝ %@", result);
        weakSelf.sortAppRequest = nil;
        [weakSelf parseDataOfSortApp:result];
    } failureBlock:^(NSString *failureString) {
        weakSelf.tableView.hidden = YES;
        weakSelf.retryView.hidden = NO;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        SHOW_BAD_NET_TOAST(weakSelf.view);
        weakSelf.sortAppRequest = nil;
    }];
    
}

#pragma mark - Parse data
- (void)parseDataOfSortApp:(id)result
{
    NSDictionary *resultDict = (NSDictionary *)result;
    if (IS_OK(resultDict)) {
        self.retryView.hidden = YES;
        self.tableView.hidden = NO;
        NSArray *dataArray = resultDict[@"allapps"];
        for (NSDictionary *dict in dataArray) {
            SortAppObject *sortAppObj = [[SortAppObject alloc] initWithDict:dict];
            [self.sortAppArray addObject:sortAppObj];
        }
        [self.tableView reloadData];
    } else {
        self.tableView.hidden = YES;
        self.retryView.hidden = NO;
        SHOW_ERROR_MESSAGE_TOAST(self.view);
    
    }
}

#pragma mark - TableView dataSource && delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sortAppArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SortAppObject *sortObj = self.sortAppArray[section];
    if (sortObj.shouldOpen) {
        return 2;
    }
    return 1;
}

static const int column = 4;
static const int gridWith = 80;
static const int gridHeight = 80;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 60;
    }
    SortAppObject *sortObj = self.sortAppArray[indexPath.section];
    if (sortObj.appArray.count > 0) {
        int value = sortObj.appArray.count % column > 0 ? 1 : 0;
        int line = (int)sortObj.appArray.count / column + value;
        
        return line * gridHeight + 10;
    }
    return 0;
}

#define kAppGridViewTag     520

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        static NSString *identifier = @"AppTitleCell";
        AppTitleCell *titleCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        titleCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        SortAppObject *sortObj = self.sortAppArray[indexPath.section];
        titleCell.titleLabel.text = sortObj.typeName;
        
        return titleCell;
        
    } else {
        static NSString *identifier = @"AppContentCell";
        AppContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:identifier];
        contentCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        for (UIView *subview in contentCell.contentView.subviews) {
            [subview removeFromSuperview];
        }
        
        SortAppObject *sortObj = self.sortAppArray[indexPath.section];
        NSArray *appArray = sortObj.appArray;
        
        CGFloat contextWidth = self.tableView.bounds.size.width;
        CGFloat contextHeight = ((appArray.count-1)/column + 1 ) * (gridHeight + 0);
        CGFloat xGap = (contextWidth - column * gridWith) / (column + 1);
        CGFloat yGap = (contextHeight - ((appArray.count-1)/column + 1) * gridHeight) / ((appArray.count-1)/column + 2);
        
        for (int i = 0; i < appArray.count; i ++) {
            CGFloat X = xGap + i % column * (gridWith + xGap);
            CGFloat Y = yGap + i / column * (gridHeight + yGap);
            
            AppObject *appObj = appArray[i];
            
            AppGridView *gridView = [AppGridView getInstance];
            gridView.frame = CGRectMake(X, Y, gridWith, gridHeight);
            gridView.tag = kAppGridViewTag + i;
            gridView.stateLabel.text = appObj.businame;
            
            [gridView.thumbButton setImageWithURL:[NSURL URLWithString:appObj.picsrc] placeholderImage:nil];
            [gridView.thumbButton addTarget:self action:@selector(clickedAppThumb:) forControlEvents:UIControlEventTouchUpInside];
            
            [contentCell.contentView addSubview:gridView];
            
        }
        
        return contentCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SortAppObject *sortObj = self.sortAppArray[indexPath.section];
    AppTitleCell *titleCell = (AppTitleCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    
    
    NSMutableArray* indexPathsArray = [NSMutableArray array];
    NSIndexPath* insertIndexPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
    [indexPathsArray addObject:insertIndexPath];
    DLog(@"...");
    if (indexPath.row == 0) {
        if ( ! sortObj.shouldOpen) {
            sortObj.shouldOpen = YES;
            [titleCell changeArrowWithUp:NO];
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
            [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        } else {
            sortObj.shouldOpen = NO;
            [titleCell changeArrowWithUp:YES];
            
            [self.tableView beginUpdates];
            [self.tableView deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView endUpdates];
        }
        
    }
}

#pragma mark - Button events
- (void)repostRequest
{
    DLog(@"retry button......");
    [self requestDataOfSortApp];
}

- (void)clickedAppThumb:(UIButton *)button
{
    if ( ! [RunTimeData sharedData].hasLogin) {
        [self.view makeToast:@"您还未登陆，请先登陆"];
        return;
    }
    AppGridView *gridView = (AppGridView *)button.superview;
    NSInteger index = gridView.tag - kAppGridViewTag;
    
    AppContentCell *contentCell = (AppContentCell *)button.superview.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:contentCell];
    SortAppObject *sortObj = self.sortAppArray[indexPath.section];
    
    AppObject *appObj = sortObj.appArray[index];
    DLog(@"点的第%d个section, 第%d个app, name = %@", (int)indexPath.section, (int)index, (NSString *)appObj.businame);
    
    AppWebController *webController = [[AppWebController alloc] initWithNibName:@"AppWebController" bundle:nil];
    webController.urlString = appObj.linksrc;
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.view.window.layer addAnimation:transition forKey:nil];
    
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webController];
    [self.view.window.rootViewController presentViewController:navi animated:NO completion:nil];
}


@end
