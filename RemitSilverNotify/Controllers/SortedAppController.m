//
//  SortedAppController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//

#import "SortedAppController.h"
#import "AppDelegate.h"
#import "SortAppObject.h"
#import "SortedAppCell.h"
#import "AddAppController.h"

@interface SortedAppController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) HttpRequest *sortAppRequest;
@property (nonatomic, strong) NSMutableArray *sortAppArray;

@end

@implementation SortedAppController

- (void)dealloc
{
    DLog(@"SortedAppController dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.showNavi = YES;
        self.enableBack = YES;
        self.showBgImage = YES;
        
        self.title = @"应用分类";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setup];
    [self requestDataOfAppList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
#pragma mark - Private methods
- (void)setup
{
    self.sortAppArray = [NSMutableArray array];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SortedAppCell" bundle:nil] forCellReuseIdentifier:@"SortedAppCell"];
}

#pragma mark - Request data
- (void)requestDataOfAppList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/app/getAllApps.do", HOST_URL];
    
    __weak typeof(self) weakSelf = self;
    
    self.sortAppRequest = [[HttpRequest alloc] init];
    [self.sortAppRequest postRequestWithURLString:url params:nil successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        DLog(@"所有应用列表 ＝ %@", result);
        weakSelf.sortAppRequest = nil;
        [weakSelf parseDataOfSortApp:result];
    } failureBlock:^(NSString *failureString) {
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
        NSArray *dataArray = resultDict[@"allapps"];
        for (NSDictionary *dict in dataArray) {
            SortAppObject *sortAppObj = [[SortAppObject alloc] initWithDict:dict];
            NSArray *appArray = sortAppObj.appArray;
            if (appArray.count > 0) {
                for (AppObject *appObj in appArray) {
                    BOOL existed = NO;
                    for (AppObject *existedObj in self.existedAppArray) {
                        if ([existedObj.busicode isEqualToString:appObj.busicode]) {
                            existed = YES;
                            break;
                        }
                    }
                    if (existed) {
                        appObj.actiontype = kAddAction;
                    } else {
                        appObj.actiontype = kDeleteAction;
                    }
                }
            }
            [self.sortAppArray addObject:sortAppObj];
        }
        [self.tableView reloadData];
    } else {
        SHOW_ERROR_MESSAGE_TOAST(self.view);
    }
}

#pragma mark - UITableView delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sortAppArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SortedAppCell";
    SortedAppCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.selectButton.hidden = YES;
    
    SortAppObject *sortAppObj = self.sortAppArray[indexPath.row];
    cell.sortLabel.text = sortAppObj.typeName;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddAppController *addAppController = [[AddAppController alloc] initWithNibName:@"AddAppController" bundle:nil];
    SortAppObject *sortAppObj = self.sortAppArray[indexPath.row];
    addAppController.appArray = sortAppObj.appArray;  //[NSArray arrayWithArray:sortAppObj.appArray];
    addAppController.existedAppArray = [self.existedAppArray mutableCopy];
    
    [self.navigationController pushViewController:addAppController animated:YES];
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
