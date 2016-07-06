//
//  FiuPeopleListViewController.m
//  Fiu
//
//  Created by FLYang on 16/7/4.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "FiuPeopleListViewController.h"
#import "FiuPeopleListTableViewCell.h"

static NSString *const FiuPeople = @"/user/activity_user";

@interface FiuPeopleListViewController ()

@end

@implementation FiuPeopleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationViewUI];
    
    [self networkFiuPeople];
    
    [self.view addSubview:self.userListTable];
}

#pragma mark - 网络请求
- (void)networkFiuPeople {
    self.fiuPeopleRequest = [FBAPI getWithUrlString:FiuPeople requestDictionary:@{@"sort":@"1", @"page":@"1", @"size":@"100"} delegate:self];
    [self.fiuPeopleRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSLog(@"＝＝＝＝＝＝＝＝＝＝ 用户排行%@", result);
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma makr - 用户排行列表
- (UITableView *)userListTable {
    if (!_userListTable) {
        _userListTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStylePlain)];
        _userListTable.delegate = self;
        _userListTable.dataSource = self;
    }
    return _userListTable;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * fiuPeopleListCellId = @"fiuPeopleListCellId";
    FiuPeopleListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuPeopleListCellId];
    if (!cell) {
        cell = [[FiuPeopleListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuPeopleListCellId];
    }
    return cell;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navViewTitle.text = NSLocalizedString(@"FiuPeopleListVC", nil);
    self.delegate = self;
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

@end
