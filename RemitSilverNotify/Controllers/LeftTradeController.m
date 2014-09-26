//
//  LeftTradeController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-17.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "LeftTradeController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"
#import "EGOViewCommon.h"
#import "NoDataCell.h"
#import "TradeCell.h"
#import "AppWebController.h"

@interface LeftTradeController ()<EGORefreshTableDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HttpRequest *tradeRequest;
@property (nonatomic, strong) NSMutableArray *tradeArray;
@property (nonatomic, assign) int page;
@property (nonatomic, assign) BOOL isPullDown;
@property (nonatomic, assign) BOOL reloading;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) EGORefreshTableFooterView *refreshFooterView;

@end

@implementation LeftTradeController

#pragma mark - Lifecycle
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kGestureLockLoginDidSuccessNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestDataOfAllTrade) name:kGestureLockLoginDidSuccessNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self creatRefreshHeaderView];
    [self setup];
    [self requestDataOfAllTrade];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark - Private methods
- (void)setup
{
    self.view.backgroundColor = UIRGBMAKE(239, 247, 246);
    self.tableView.hidden = YES;
    self.page = 1;
    self.tradeArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"TradeCell" bundle:nil] forCellReuseIdentifier:@"aTradeCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoDataCell" bundle:nil] forCellReuseIdentifier:@"aNoDataCell"];
}

#pragma mark - Reqeust data
- (void)requestDataOfAllTrade
{
    CHECK_NETWORK_AND_SHOW_TOAST(self.view);
    DLog(@"44444444444444444");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/order/getPersonalTradeDetail.do", HOST_URL];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:[RunTimeData sharedData].userInfoObj.userId forKey:@"userid"];
    [paramDict setObject:[Utility getFormerDateWithMonthAgo:-6] forKey:@"screatedate"];
    [paramDict setObject:[Utility getFormerDateWithMonthAgo:0] forKey:@"ecreatedate"];
    [paramDict setObject:@"" forKey:@"spaydate"];
    [paramDict setObject:@"" forKey:@"epaydate"];
    [paramDict setObject:[NSString stringWithFormat:@"%d", _page] forKey:@"pagenum"];
    [paramDict setObject:[NSString stringWithFormat:@"%d", 10] forKey:@"pagesize"];
    [paramDict setObject:[RunTimeData sharedData].userInfoObj.token forKey:@"token"];
    
    __weak typeof(&*self) weakSelf = self;
    
    self.tradeRequest = [[HttpRequest alloc] init];
    [self.tradeRequest postRequestWithURLString:url params:paramDict successBlock:^(id result) {
        DLog(@"全部交易明细 ＝ %@", result);
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        [weakSelf finishReloadingData];
        [weakSelf parseDataOfAllTrade:result];
        weakSelf.tradeRequest = nil;
        
    } failureBlock:^(NSString *failureString) {
        [weakSelf finishReloadingData];
        weakSelf.tradeRequest = nil;
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        SHOW_BAD_NET_TOAST(weakSelf.view);
    }];
}

- (void)parseDataOfAllTrade:(id)result
{
    NSDictionary *resultDict = result;
    if (IS_OK(resultDict)) {
        if (self.isPullDown) {
            [self.tradeArray removeAllObjects];
        }
        NSArray *dataArray = resultDict[@"tradedetails"];
        if (dataArray.count > 0) {
            for (NSDictionary *dict in dataArray) {
                TradeObject *obj = [[TradeObject alloc] initWithDict:dict];
                [self.tradeArray addObject:obj];
            }
        }
        
        if (self.page > [resultDict[@"totoalpagecnt"] intValue]) {
            [self.refreshFooterView removeFromSuperview];
            self.refreshFooterView = nil;
            [self.view makeToast:@"没有更多数据" duration:1.2 position:@"center"];
        }
        
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        if (self.tradeArray.count > 0) {
            [self setFooterView];
        }
    } else {
        SHOW_ERROR_MESSAGE_TOAST(self.view);
    }
}


#pragma mark - UITableView dataSource && delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.tradeArray.count > 0) {
        return self.tradeArray.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tradeArray.count > 0) {
        return kTradeCellHeight;
    }
    return self.view.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tradeArray.count > 0) {
        static NSString *identifier = @"aTradeCell";
        TradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.tradeObj = self.tradeArray[indexPath.row];
        
        return cell;
        
    } else {
        static NSString *identifier = @"aNoDataCell";
        NoDataCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.tradeArray.count > 0) {
        TradeCell *cell = (TradeCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        AppWebController *webController = [[AppWebController alloc] initWithNibName:@"AppWebController" bundle:nil];
        webController.urlString = cell.tradeObj.paylinkurl;
        
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webController];
        [self.view.window.rootViewController presentViewController:navi animated:NO completion:nil];
    }
    
}

#pragma mark - EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    [self beginReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView *)view
{
    return self.reloading;
}

- (NSDate *)egoRefreshTableDataSourceLastUpdated:(UIView *)view
{
    return [NSDate date];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.refreshHeaderView) {
        [self.refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    }
    if (self.refreshFooterView) {
        [self.refreshFooterView egoRefreshScrollViewDidScroll:self.tableView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.refreshHeaderView) {
        [self.refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
    }
    if (self.refreshFooterView) {
        [self.refreshFooterView egoRefreshScrollViewDidEndDragging:self.tableView];
    }
}

- (void)beginReloadData:(EGORefreshPos)aRefreshPos
{
    self.reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        self.page = 1;
        self.isPullDown = YES;
        [self requestDataOfAllTrade];
        
    } else if (aRefreshPos == EGORefreshFooter) {
        self.page ++;
        self.isPullDown = NO;
        [self requestDataOfAllTrade];
    }
}

- (void)finishReloadingData
{
    self.reloading = NO;
    
	if (self.refreshHeaderView) {
        [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if (self.refreshFooterView) {
        [self.refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
}

- (void)creatRefreshHeaderView
{
    self.refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -self.view.frame.size.height, self.tableView.frame.size.width, self.view.frame.size.height)];
    self.refreshHeaderView.delegate = self;
    
    [self.tableView addSubview:self.refreshHeaderView];
    [self.refreshHeaderView refreshLastUpdatedDate];
}

- (void)setFooterView
{
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    
    if (self.refreshFooterView && [self.refreshFooterView superview]) {
        self.refreshFooterView.frame = CGRectMake(0, height, self.tableView.frame.size.width,self.view.frame.size.height);
    } else {
        self.refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, height,self.tableView.frame.size.width, self.view.frame.size.height)];
        self.refreshFooterView.delegate = self;
        self.refreshFooterView.backgroundColor = [UIColor clearColor];
        
        [self.tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


@end
