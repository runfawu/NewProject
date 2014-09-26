//
//  AddAppController.m
//  RemitSilverNotify
//
//  Created by Oliver on 14-9-12.
//  Copyright (c) 2014年 iOS_Group. All rights reserved.
//



#import "AddAppController.h"
#import "AppObject.h"
#import "SortedAppCell.h"
#import "AppObject.h"
#import "UIImageView+WebCache.h"

@interface AddAppController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *sourceAppArray;
@property (nonatomic, strong) HttpRequest *commitRequest;

@end

@implementation AddAppController

- (void)dealloc
{
    DLog(@"AddAppController dealloc");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        self.showNavi = YES;
        self.enableBack = YES;
        self.title = @"添加应用";
    }
    return self;
}

- (void)loadView
{
    [super loadView];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configRightBarButtonItem];
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Private methods
- (void)setup
{
//    for (AppObject *appObj in self.appArray) {
//        BOOL existed = NO;
//        for (AppObject *existedObj in self.existedAppArray) {
//            if ([existedObj.busicode isEqualToString:appObj.busicode]) {
//                existed = YES;
//                break;
//            }
//        }
//        if (existed) {
//            appObj.actiontype = kAddAction;
//        } else {
//            appObj.actiontype = kDeleteAction;
//        }
//    }
    
    self.sourceAppArray = [NSMutableArray array];
    for (AppObject *displayObj in self.appArray) {
        DLog(@"displayObj.name = %@, action = %@, code = %@", displayObj.businame, displayObj.actiontype, displayObj.busicode);
        AppObject *sourceObj = [[AppObject alloc] init];
        sourceObj.businame = displayObj.businame;
        sourceObj.busicode = displayObj.busicode;
        sourceObj.actiontype = displayObj.actiontype;
        [self.sourceAppArray addObject:sourceObj];
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SortedAppCell" bundle:nil] forCellReuseIdentifier:@"SortedAppCell"];

}

- (void)configRightBarButtonItem
{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(18, 0, 45, 26);
    [rightButton setBackgroundImage:[UIImage imageNamed:@"main_confim_n"] forState:UIControlStateNormal];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"main_confim_h"] forState:UIControlStateHighlighted];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(addOrDeleteCommit:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
}

#pragma mark - UITableView delegate && dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.appArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

#define kAddAppSelectButtonTag      430

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //FIXME: be careful of memory warning !!!
    static NSString *identifier = @"SortedAppCell";
    SortedAppCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    cell.checkMarkImageView.hidden = YES;
    
    AppObject *appObj = self.appArray[indexPath.row];
    if (cell.appObj == nil) {
       cell.appObj = appObj;
    }
    cell.sortLabel.text = appObj.businame;
    [cell.thumbImageView setImageWithURL:[NSURL URLWithString:appObj.picsrc] placeholderImage:nil];
    [cell.selectButton addTarget:self action:@selector(selectThissApp:) forControlEvents:UIControlEventTouchUpInside];
    if ([cell.appObj.actiontype isEqualToString:kAddAction]) {
        cell.selectButton.selected = YES;
    }
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SortedAppCell *cell = (SortedAppCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.appObj.actiontype = cell.selectButton.selected ? kDeleteAction : kAddAction;
    cell.selectButton.selected = !cell.selectButton.selected;
}

#pragma mark - Button events
- (void)selectThissApp:(UIButton *)button
{
    SortedAppCell *cell = (SortedAppCell *)button.superview.superview.superview;
    cell.appObj.actiontype = cell.selectButton.selected ? kDeleteAction : kAddAction;
    cell.selectButton.selected = !cell.selectButton.selected;
}

- (void)addOrDeleteCommit:(id)sender
{
    
    NSMutableArray *commitArray = [NSMutableArray array];
    for (AppObject *variedObj in self.appArray) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"busicode", variedObj.busicode];
        NSArray *tempArray = [self.sourceAppArray filteredArrayUsingPredicate:predicate];
        AppObject *filteredObj = [tempArray firstObject];
        
        if ( ! [filteredObj.actiontype isEqualToString:variedObj.actiontype]) {
            [commitArray addObject:variedObj];
        }
    }
    
    DLog(@"\n\n");
    DLog(@"********************* commit *************");
    for (AppObject *commitObj in commitArray) {
        DLog(@"commit appObj.name = %@, action = %@, code = %@", commitObj.businame, commitObj.actiontype, commitObj.busicode);
//        for (AppObject * in <#collection#>) {
//            <#statements#>
//        }
    }
    
    NSMutableArray *addOrDeleteAppArray = [NSMutableArray array];
    for (AppObject *addOrDeleteObj in commitArray) {
        NSMutableDictionary *objDict = [NSMutableDictionary dictionary];
        [objDict setObject:addOrDeleteObj.busicode forKey:@"busicode"];
        [objDict setObject:addOrDeleteObj.actiontype forKey:@"actiontype"];
        [addOrDeleteAppArray addObject:objDict];
    }
    
    RunTimeData *sharedData = [RunTimeData sharedData];
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    [paramDict setObject:sharedData.userInfoObj.userId forKey:@"userid"];
    [paramDict setObject:sharedData.userInfoObj.token forKey:@"token"];
    [paramDict setObject:addOrDeleteAppArray forKey:@"apps"];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *url = [NSString stringWithFormat:@"%@/app/addOrDeleteApps.do", HOST_URL];
    __weak typeof(self) weakSelf = self;
    
    self.commitRequest = [[HttpRequest alloc] init];
    [self.commitRequest postRequestWithURLString:url params:paramDict successBlock:^(id result) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        DLog(@"变更应用success = %@", result);
        NSDictionary *resultDict = result;
        if (IS_OK(resultDict)) {
            SHOW_ERROR_MESSAGE_TOAST(weakSelf.view);
//            [USER_DEFAULT setBool:YES forKey:kDidAddOrDeleteAppNotification];
//            [USER_DEFAULT synchronize];
            [self performSelector:@selector(clickBack:) withObject:nil afterDelay:kToastDefaultDuration];
        } else {
            SHOW_ERROR_MESSAGE_TOAST(weakSelf.view);
        }
        
    } failureBlock:^(NSString *failureString) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        SHOW_BAD_NET_TOAST(weakSelf.view);
    }];
}

#pragma mark - Override
- (void)clickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
