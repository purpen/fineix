//
//  THNDiscoverViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDiscoverViewController.h"

@implementation THNDiscoverViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self thn_setNavigationViewUI];
    [self thn_setDiscoverViewUI];
}

#pragma mark - 设置视图UI
- (void)thn_setDiscoverViewUI {
    [self.view addSubview:self.discoverTable];
}

- (FBCategoryView *)categoryView {
    if (!_categoryView) {
        _categoryView = [[FBCategoryView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180)];
    }
    return _categoryView;
}

#pragma mark - tableView
- (UITableView *)discoverTable {
    if (!_discoverTable) {
        _discoverTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 108) style:(UITableViewStyleGrouped)];
        _discoverTable.delegate = self;
        _discoverTable.dataSource = self;
        _discoverTable.tableHeaderView = self.categoryView;
        _discoverTable.showsVerticalScrollIndicator = NO;
        _discoverTable.backgroundColor = [UIColor colorWithHexString:BLACK_COLOR];
        _discoverTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//        [self addMJRefresh:_discoverTable];
    }
    return _discoverTable;
}

#pragma mark tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellID"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.nav = self.navigationController;
    if (section == 0) {
        [self.headerView addGroupHeaderViewIcon:@"discover_newScene"
                                      withTitle:NSLocalizedString(@"newScene", nil)
                                   withSubtitle:@""
                                  withRightMore:@""
                                   withMoreType:0];
    }
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 44.0f;
    } else {
        return 0.01f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - 设置Nav
- (void)thn_setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self thn_addSearchBtnText:NSLocalizedString(@"discoverSearch", nil) type:1];
    [self thn_addBarItemLeftBarButton:@"" image:@"discover_user"];
    [self thn_addBarItemRightBarButton:@"" image:@"discover_ranking"];
}

- (void)thn_leftBarItemSelected {
    [SVProgressHUD showSuccessWithStatus:@"加好友"];
//    SearchViewController * searchVC = [[SearchViewController alloc] init];
//    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)thn_rightBarItemSelected {
    [SVProgressHUD showSuccessWithStatus:@"排行榜"];
//    SceneSubscribeViewController * sceneSubVC = [[SceneSubscribeViewController alloc] init];
//    [self.navigationController pushViewController:sceneSubVC animated:YES];
}

@end
