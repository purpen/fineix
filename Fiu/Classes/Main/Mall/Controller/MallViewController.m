//
//  MallViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "MallViewController.h"

@implementation MallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationViewUI];
    
    [self setMallViewUI];
}


#pragma mark - 设置视图的UI
- (void)setMallViewUI {
    [self.view addSubview:self.mallTableView];
}

#pragma mark - 顶部轮播图
- (FBRollImages *)rollView {
    if (!_rollView) {
        _rollView = [[FBRollImages alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Banner_height)];
        _rollView.navVC = self.navigationController;
        [_rollView setRollimageView];
    }
    return _rollView;
}

#pragma mark - tableView
- (UITableView *)mallTableView {
    if (!_mallTableView) {
        _mallTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _mallTableView.delegate = self;
        _mallTableView.dataSource = self;
        _mallTableView.tableHeaderView = self.rollView;
        _mallTableView.showsVerticalScrollIndicator = NO;
    }
    return _mallTableView;
}

#pragma mark - tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellId = @"mallTableViewCell";
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
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    
    if (section == 0) {
        [self.headerView addGroupHeaderViewIcon:@"Group_Brand" withTitle:@"最Fiu品牌" withSubtitle:@"[越喜欢头像越大]"];
    } else if (section ==1) {
        [self.headerView addGroupHeaderViewIcon:@"Group_scene" withTitle:@"最Fiu商品" withSubtitle:@"[生活有你才够美]"];
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
    [self addBarItemRightBarButton:@"" image:@"Nav_Car"];
    [self addNavLogo:@"Nav_Title"];
}

//  点击左边barItem
- (void)leftBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊搜索");
}

//  点击右边barItem
- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊购物车");
}
@end
