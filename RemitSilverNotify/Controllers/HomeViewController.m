//
//  HomeViewController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-4.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#define kScrollImageButtonTag   200
#define kAppGridViewTag         300
#define kAddAppObjBusicode      @"-1010"

static const int timerInterval = 8;
static const int column = 4;
static const int gridWith = 80;
static const int gridHeight = 80;

#import "HomeViewController.h"
#import "HttpRequest.h"
#import "ScrollImageObject.h"
#import "UIButton+WebCache.h"
#import "AppObject.h"
#import "AppGridView.h"
#import "RunTimeData.h"
#import "UserInfoObject.h"
#import "LoginController.h"
#import "SortedAppController.h"
#import "AppWebController.h"
#import "UIButton+EnlargeTouchArea.h"

@interface HomeViewController ()<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *appTableView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *moreChoiseButton;

@property (nonatomic, strong) HttpRequest    *testRequest;
@property (nonatomic, strong) NSMutableArray *scrollImageArray;
@property (nonatomic, strong) UIPageControl  *pageControl;
@property (nonatomic, strong) NSTimer        *scrollImageTimer;
@property (nonatomic, assign) NSInteger      count;
@property (nonatomic, assign) BOOL           flag;
@property (nonatomic, strong) HttpRequest    *defaultAppRequest;
@property (nonatomic, strong) NSMutableArray *appArray;
@property (nonatomic, strong) HttpRequest    *personalAppRequest;
@property (nonatomic, strong) NSMutableArray *defaultAppArray;

@end

@implementation HomeViewController

#pragma mark - Lifecycle
- (void)dealloc
{
    DLog(@".............");
}

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
    [self requestDataOfScrollImages];
    [self requestDataOfDefaultApp];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.appTableView.frame = CGRectMake(0, 164, SCREEN_WIDTH, SCREEN_HEIGHT - 164 - 49);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    BOOL needUpdateApp = [USER_DEFAULT boolForKey:kDidAddOrDeleteAppNotification];
    if (needUpdateApp && [RunTimeData sharedData].hasLogin) {
        [self.loginButton setTitle:[RunTimeData sharedData].userInfoObj.userId forState:UIControlStateNormal];
        [self requestDataOfPersonalApps];
        [USER_DEFAULT removeObjectForKey:kDidAddOrDeleteAppNotification];
        [USER_DEFAULT synchronize];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    DLog(@"homeVC view didAppear");
    
    if (self.scrollImageTimer) {
        [self.scrollImageTimer invalidate];
        self.scrollImageTimer = nil;
    }
    self.scrollImageTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                                             target:self
                                                           selector:@selector(autoScrollImage:)
                                                           userInfo:nil
                                                            repeats:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.scrollImageTimer) {
        [self.scrollImageTimer invalidate];
        self.scrollImageTimer = nil;
    }
}

#pragma mark - Private methods
- (void)setup
{
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bgImageView.image = [UIImage imageNamed:@"main_bg"];
    [super.view addSubview:bgImageView];
    [super.view sendSubviewToBack:bgImageView];
    
    self.scrollImageArray = [NSMutableArray array];
    self.appArray = [NSMutableArray array];
    self.defaultAppArray = [NSMutableArray array];
    
    self.appTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.moreChoiseButton setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
}

- (void)createScrollImageButton
{
    NSMutableArray *tempImagesArray = [NSMutableArray array];
    [tempImagesArray addObject:[self.scrollImageArray lastObject]];
    [tempImagesArray addObjectsFromArray:self.scrollImageArray];
    [tempImagesArray addObject:[self.scrollImageArray firstObject]];
    
    CGFloat width = self.scrollView.bounds.size.width;
    CGFloat height = self.scrollView.frame.size.height;
    for (int i = 0; i < tempImagesArray.count; i ++) {
        UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        imageButton.frame = CGRectMake(i * width, 0, width, height);
        ScrollImageObject *obj = tempImagesArray[i];
        //FIXME: 有接口后需要修复下面这行代码
        //[imageButton setImageWithURL:[NSURL URLWithString:obj.imageURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"reservedImage"]];
        [imageButton setImage:[UIImage imageNamed:obj.imageURL] forState:UIControlStateNormal];
        imageButton.adjustsImageWhenHighlighted = NO;
        [imageButton addTarget:self action:@selector(clickedScrollImageButton:) forControlEvents:UIControlEventTouchUpInside];
        imageButton.tag = kScrollImageButtonTag + i;
        
        [self.scrollView addSubview:imageButton];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * tempImagesArray.count, self.scrollView.bounds.size.height);
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0) animated:NO];

    self.pageControl = [[UIPageControl alloc] init];
    self.pageControl.frame = CGRectMake(self.scrollView.frame.size.width-self.scrollImageArray.count*18, self.scrollView.frame.size.height + self.scrollView.frame.origin.y - 23, self.scrollImageArray.count*18, 20);
    self.pageControl.numberOfPages = self.scrollImageArray.count;
    [self.view addSubview:self.pageControl];
    
    if (tempImagesArray.count > 3) {
        if (self.scrollImageTimer) {
            [self.scrollImageTimer invalidate];
            self.scrollImageTimer = nil;
        }
        self.scrollImageTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                                                 target:self
                                                               selector:@selector(autoScrollImage:)
                                                               userInfo:nil
                                                                repeats:YES];
    }

}

- (void)addTheAddAppButton
{
    AppObject *addAppObj = [[AppObject alloc] init];
    addAppObj.businame = @"添加应用";
    addAppObj.picsrc = @"main_addApp.png";
    addAppObj.busicode = kAddAppObjBusicode;
    [self.appArray addObject:addAppObj];
}

#pragma mark - Request data
- (void)requestDataOfScrollImages
{
    for (int i = 0; i < 5; i ++) {
        NSDictionary *dict = [NSDictionary dictionary];
        ScrollImageObject *imageObj = [[ScrollImageObject alloc] initWithDict:dict];
        imageObj.imageURL = @"main_ad";
        [self.scrollImageArray addObject:imageObj];
    }
    
    [self createScrollImageButton];
}

- (void)requestDataOfDefaultApp
{
    CHECK_NETWORK_AND_SHOW_TOAST(self.view);
    
    [MBProgressHUD showHUDAddedTo:self.appTableView animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/app/getDefaultApps.do", HOST_URL];
    
    __weak typeof(self) weakSelf = self;
    
    self.defaultAppRequest = [[HttpRequest alloc] init];
    [self.defaultAppRequest postRequestWithURLString:url params:nil successBlock:^(id result) {
        DLog(@"default app result = %@", result);
        weakSelf.defaultAppRequest = nil;
        [weakSelf parseDataOfDefaultApp:result];
        [MBProgressHUD hideHUDForView:weakSelf.appTableView animated:YES];
        
    } failureBlock:^(NSString *failureString) {
        weakSelf.defaultAppRequest = nil;
        SHOW_BAD_NET_TOAST(weakSelf.appTableView);
        [MBProgressHUD hideHUDForView:weakSelf.appTableView animated:YES];
    }];
}

- (void)requestDataOfPersonalApps
{
    DLog(@"。。。。。。。。。。。。。。。。。。。。。。。。。。。");
    [MBProgressHUD showHUDAddedTo:self.appTableView animated:YES];
    
    UserInfoObject *userObj = [RunTimeData sharedData].userInfoObj;
    
    NSString *url = [NSString stringWithFormat:@"%@/app/getPersonalApps.do", HOST_URL];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:userObj.userId forKey:@"userid"];
    [paramDict setObject:userObj.token forKey:@"token"];
    
    __weak typeof(self) weakSelf = self;
    
    self.personalAppRequest = [[HttpRequest alloc] init];
    [self.personalAppRequest postRequestWithURLString:url params:paramDict successBlock:^(id result) {
        DLog(@"个人应用列表 = %@", result);
        weakSelf.personalAppRequest = nil;
        [weakSelf parseDataOfPersonalApp:(id)result];
        [MBProgressHUD hideHUDForView:weakSelf.appTableView animated:YES];
    } failureBlock:^(NSString *failureString) {
        weakSelf.personalAppRequest = nil;
        SHOW_BAD_NET_TOAST(weakSelf.appTableView);
        [MBProgressHUD hideHUDForView:weakSelf.appTableView animated:YES];
    }];
}


#pragma mark - Parse data
- (void)parseDataOfDefaultApp:(id)result
{
    NSDictionary *resultDict = result;
    if (IS_OK(resultDict)) {
        NSArray *dataArray = resultDict[@"defaultapps"];
        if ( ! [dataArray isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dict in dataArray) {
                AppObject *object = [[AppObject alloc] initWithDict:dict];
                [self.defaultAppArray addObject:object];
            }
            
        }
        [self.appArray addObjectsFromArray:self.defaultAppArray];
        [self addTheAddAppButton];
        [self.appTableView reloadData];
        
    } else {
        SHOW_ERROR_MESSAGE_TOAST(self.appTableView);
    }
}

- (void)parseDataOfPersonalApp:(id)result
{
    NSDictionary *resultDict = result;
    if (IS_OK(resultDict)) {
        [self.appArray removeAllObjects];
        [self addTheAddAppButton];
        
        NSArray *dataArray = resultDict[@"apps"];
        if ( ! [dataArray isKindOfClass:[NSNull class]] && dataArray.count > 0) {
            for (NSDictionary *dict in dataArray) {
                AppObject *object = [[AppObject alloc] initWithDict:dict];
                    [self.appArray insertObject:object atIndex:self.appArray.count - 1];
            }
        }
        [self.appTableView reloadData];
    } else {
        SHOW_ERROR_MESSAGE_TOAST(self.appTableView);
    }
}

#pragma mark - Button event
- (IBAction)mainpageLogin:(id)sender {
    BOOL hasLogin = [RunTimeData sharedData].hasLogin;
    if ( ! hasLogin) {
        LoginController *loginController = [[LoginController alloc] initWithNibName:@"LoginController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginController];
        
        [self.view.window.rootViewController presentViewController:navi animated:YES completion:nil];
    }
}

- (void)clickedScrollImageButton:(UIButton *)button
{
    DLog(@"scroll image...");
}


- (void)clickedAppThumb:(UIButton *)button
{
    if ( ! [RunTimeData sharedData].hasLogin) {
        [self.view makeToast:@"您还未登陆，请先登陆"];
        return;
    }
    AppGridView *gridView = (AppGridView *)button.superview;
    NSInteger index = gridView.tag - kAppGridViewTag;
    AppObject *appObj = self.appArray[index];
    if ([appObj.busicode isEqualToString:kAddAppObjBusicode]) {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        SortedAppController *sortedController = [[SortedAppController alloc] initWithNibName:@"SortedAppController" bundle:nil];
        sortedController.existedAppArray = [self.appArray mutableCopy];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:sortedController];
        
        [self.view.window.rootViewController presentViewController:navi animated:NO completion:nil];
        
    } else {
        CATransition *transition = [CATransition animation];
        transition.duration = 0.3;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        [self.view.window.layer addAnimation:transition forKey:nil];
        
        AppWebController *webController = [[AppWebController alloc] initWithNibName:@"AppWebController" bundle:nil];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:webController];
        
        [self.view.window.rootViewController presentViewController:navi animated:NO completion:nil];
        
    }
    DLog(@"点击了第 %d 个app, text = %@, busicode = %@", (int)index, gridView.stateLabel.text, appObj.busicode);
}

- (IBAction)showMoreChoice:(UIButton *)sender {
    [self.appTableView makeToast:@"功能开发中,敬请期待"];
}

#pragma mark - Timer event
- (void)autoScrollImage:(NSTimer *)timer
{
    [self.scrollView setContentOffset:CGPointMake(self.count * self.scrollView.frame.size.width, 0) animated:YES];
    if (self.count > self.scrollImageArray.count + 2) {
        self.count = 1;
    }else {
        self.count ++;
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == self.scrollView.frame.size.width) {
        self.flag = YES;
    }
    if (self.flag) {
        if (self.scrollView.contentOffset.x <= 0) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * self.scrollImageArray.count, 0) animated:NO];
        } else if (self.scrollView.contentOffset.x >= self.scrollView.frame.size.width *(self.scrollImageArray.count + 1)) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, 0) animated:NO];
        }
    }
    self.pageControl.currentPage = round(self.scrollView.contentOffset.x / self.scrollView.frame.size.width) - 1;
    self.count = (int)self.pageControl.currentPage + 2;
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollImageTimer) {
        [self.scrollImageTimer invalidate];
        self.scrollImageTimer = nil;
    }
    self.scrollImageTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
                                                             target:self
                                                           selector:@selector(autoScrollImage:)
                                                           userInfo:nil
                                                            repeats:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.scrollImageTimer) {
        [self.scrollImageTimer invalidate];
        self.scrollImageTimer = nil;
    }
}

#pragma mark - UITableView dataSource && delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int value = self.appArray.count % column > 0 ? 1 : 0;
    int line = (int)self.appArray.count / column + value;
    
    return line * gridHeight + 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"AppCell";
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    CGFloat contextWidth = self.appTableView.bounds.size.width;
    CGFloat contextHeight = ((self.appArray.count-1)/column + 1 ) * (gridHeight + 0);
    CGFloat xGap = (contextWidth - column * gridWith) / (column + 1);
    CGFloat yGap = (contextHeight - ((self.appArray.count-1)/column + 1) * gridHeight) / ((self.appArray.count-1)/column + 2);
    
    for (int i = 0; i < self.appArray.count; i ++) {
        CGFloat X = xGap + i % column * (gridWith + xGap);
        CGFloat Y = yGap + i / column * (gridHeight + yGap);
        
        AppObject *appObj = self.appArray[i];
        
        AppGridView *gridView = [AppGridView getInstance];
        gridView.frame = CGRectMake(X, Y, gridWith, gridHeight);
        gridView.tag = kAppGridViewTag + i;
        gridView.stateLabel.text = appObj.businame;
        if (i == self.appArray.count - 1) {
            [gridView.thumbButton setImage:[UIImage imageNamed:appObj.picsrc] forState:UIControlStateNormal];
        } else {
            [gridView.thumbButton setImageWithURL:[NSURL URLWithString:appObj.picsrc] placeholderImage:nil];
        }
        [gridView.thumbButton addTarget:self action:@selector(clickedAppThumb:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell.contentView addSubview:gridView];
    }

    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
