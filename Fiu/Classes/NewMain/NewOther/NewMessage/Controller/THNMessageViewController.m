//
//  THNMessageViewController.m
//  Fiu
//
//  Created by FLYang on 16/9/21.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNMessageViewController.h"
#import "THNUserModelCounter.h"
#import "THNMessageTableViewCell.h"
#import "SystemInformsViewController.h"
#import "CommentsViewController.h"
#import "MessagesssViewController.h"
#import "THNRemindViewController.h"
#import "MyFansViewController.h"

static NSString *const URLUserMessage = @"/auth/user";
static NSString *const messageTableCellId = @"MessageTableCellId";

@interface THNMessageViewController () {
    THNUserModelCounter *_userMessageModel;
    NSIndexPath *_selectedIndexPath;
    BOOL _isSelectedCell;
}

@end

@implementation THNMessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setMessageVcUI];
    [self thn_networkUserMessageData];
}

#pragma mark - 网络请求
- (void)thn_networkUserMessageData {
    self.userMessageRequest = [FBAPI getWithUrlString:URLUserMessage requestDictionary:@{} delegate:self];
    [self.userMessageRequest startRequestSuccess:^(FBRequest *request, id result) {
        _userMessageModel = [[THNUserModelCounter alloc] initWithDictionary:[[result valueForKey:@"data"] valueForKey:@"counter"]];
        [self.messageTable reloadData];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 设置视图
- (void)thn_setMessageVcUI {
    [self.view addSubview:self.messageTable];
}

#pragma mark - 提醒列表
- (UITableView *)messageTable {
    if (!_messageTable) {
        _messageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:(UITableViewStylePlain)];
        _messageTable.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        _messageTable.delegate = self;
        _messageTable.dataSource = self;
        _messageTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _messageTable.tableFooterView = [UIView new];
    }
    return _messageTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    THNMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:messageTableCellId];
    cell = [[THNMessageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:messageTableCellId];
    [cell thn_setMessageData:indexPath.row withCount:_userMessageModel];
    if (_isSelectedCell) {
        [cell thn_hiddenCountPop:_isSelectedCell];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_selectedIndexPath && _selectedIndexPath.row == indexPath.row) {
        _selectedIndexPath = nil;
        _isSelectedCell = NO;
    } else {
        _isSelectedCell = YES;
        _selectedIndexPath = indexPath;
    }
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (indexPath.row == 0) {
        SystemInformsViewController *systemInfoVC = [[SystemInformsViewController alloc] init];
        systemInfoVC.num = _userMessageModel.fiuNoticeCount;
        [self.navigationController pushViewController:systemInfoVC animated:YES];
        
    } else if (indexPath.row == 1) {
        CommentsViewController *commentVC = [[CommentsViewController alloc] init];
        commentVC.num = _userMessageModel.fiuCommentCount;
        [self.navigationController pushViewController:commentVC animated:YES];
        
    } else if (indexPath.row == 2) {
        MessagesssViewController *MessagessVC = [[MessagesssViewController alloc] init];
        [self.navigationController pushViewController:MessagessVC animated:YES];
        
    } else if (indexPath.row == 3) {
        THNRemindViewController *remindVC = [[THNRemindViewController alloc] init];
        [self.navigationController pushViewController:remindVC animated:YES];
        
    } else if (indexPath.row == 4) {
        MyFansViewController *fansVC = [[MyFansViewController alloc] init];
        fansVC.userId = [self getLoginUserID];
        fansVC.num = _userMessageModel.fansCount;
        fansVC.cleanRemind = @"1";
        [self.navigationController pushViewController:fansVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationFade)];
    self.navViewTitle.text = NSLocalizedString(@"MessageVC", nil);
}

@end
