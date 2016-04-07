//
//  DiscoverViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DiscoverViewController.h"

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationViewUI];
    
    [self setDiscoverViewUI];
}

#pragma mark - 设置视图的UI
- (void)setDiscoverViewUI {
    [self.view addSubview:self.discoverTableView];
}

#pragma mark - 顶部轮播图
- (FBRollImages *)rollView {
    if (!_rollView) {
        _rollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollView.navVC = self.navigationController;
    }
    return _rollView;
}

#pragma mark - tableView
- (UITableView *)discoverTableView {
    if (!_discoverTableView) {
        _discoverTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _discoverTableView.delegate = self;
        _discoverTableView.dataSource = self;
        _discoverTableView.tableHeaderView = self.rollView;
        _discoverTableView.showsVerticalScrollIndicator = NO;
    }
    return _discoverTableView;
}

#pragma mark - tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellId = @"discoverTableViewCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellId];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 200;
    } else if (indexPath.section == 1) {
        return 266.5;
    } else if (indexPath.section == 2) {
        return 200;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    if (section == 0) {
        [self.headerView addGroupHeaderViewIcon:@"Group_friend" withTitle:@"最Fiu伙伴" withSubtitle:@"[越喜欢头像越大]"];
    } else if (section ==1) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"最Fiu情景" withSubtitle:@"[我的地盘我收益]"];
    } else if (section == 2) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"最Fiu场景" withSubtitle:@"[发现不一样]"];
    }
    
    return self.headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.delegate = self;
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search"];
    [self addBarItemRightBarButton:@"" image:@"Nav_Location"];
    [self addNavLogo:@"Nav_Title"];
}

//  点击左边barItem
- (void)leftBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊搜索");
}

//  点击右边barItem
- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊位置");
}

@end
