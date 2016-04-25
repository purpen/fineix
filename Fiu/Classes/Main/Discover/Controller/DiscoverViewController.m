//
//  DiscoverViewController.m
//  fineix
//
//  Created by FLYang on 16/2/26.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "DiscoverViewController.h"
#import "FiuSceneTableViewCell.h"
#import "SceneListTableViewCell.h"
#import "FiuTagTableViewCell.h"

#import "SearchViewController.h"
#import "SceneInfoViewController.h"

static NSString *const URLDiscoverSlide = @"/gateway/slide";

@implementation DiscoverViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setNavigationViewUI];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setDiscoverViewUI];
}

#pragma mark - 网络请求
//  轮播图
- (void)networkRollImgData {
    self.rollImgRequest = [FBAPI getWithUrlString:URLDiscoverSlide requestDictionary:@{} delegate:self];
}

#pragma mark - 设置视图的UI
- (void)setDiscoverViewUI {
    [self.view addSubview:self.discoverTableView];
    if ([self.discoverTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.discoverTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self.discoverTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.discoverTableView setLayoutMargins:UIEdgeInsetsZero];
    }
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
- (UITableView *)discoverTableView {
    if (!_discoverTableView) {
        _discoverTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:(UITableViewStyleGrouped)];
        _discoverTableView.delegate = self;
        _discoverTableView.dataSource = self;
        _discoverTableView.showsVerticalScrollIndicator = NO;
        _discoverTableView.tableHeaderView = self.rollView;
        _discoverTableView.backgroundColor = [UIColor whiteColor];
    }
    return _discoverTableView;
}

#pragma mark - tableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            static NSString * fiuFriendCellId = @"fiuFriendCellId";
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuFriendCellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuFriendCellId];
            }
            return cell;
            
        } else if (indexPath.row == 1) {
            static NSString * fiuSceneTagCellId = @"fiuSceneTagCellId";
            FiuTagTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuSceneTagCellId];
            if (!cell) {
                cell = [[FiuTagTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuSceneTagCellId];
            }
            [cell setUI];
            cell.nav = self.navigationController;
            return cell;
        }
    
    } else if (indexPath.section == 1) {
        static NSString * fiuSceneCellId = @"fiuSceneCellId";
        FiuSceneTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:fiuSceneCellId];
        if (!cell) {
            cell = [[FiuSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:fiuSceneCellId];
        }
        cell.nav = self.navigationController;
        return cell;
        
    } else if (indexPath.section == 2) {
        static NSString * sceneListCellId = @"sceneListCellId";
        SceneListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:sceneListCellId];
        if (!cell) {
            cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:sceneListCellId];
        }
//        [cell setUI];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 155;
        } else if (indexPath.row == 1) {
            return 80;
        }
        
    } else if (indexPath.section == 1) {
        return 266.5;
        
    } else if (indexPath.section == 2) {
        return SCREEN_HEIGHT;
        
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.headerView = [[GroupHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    self.headerView.nav = self.navigationController;
    
    if (section == 0) {
        [self.headerView addGroupHeaderViewIcon:@"Group_friend" withTitle:@"最Fiu伙伴" withSubtitle:@"[越喜欢头像越大]"];
    } else if (section ==1) {
        [self.headerView addLookMoreBtn];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 跳转场景页面
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        SceneInfoViewController * sceneVC = [[SceneInfoViewController alloc] init];
        [self.navigationController pushViewController:sceneVC animated:YES];
    }
}

#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [self navBarNoTransparent];
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    [self addBarItemLeftBarButton:@"" image:@"Nav_Search"];
    [self addBarItemRightBarButton:@"" image:@"Nav_Location"];
    [self addNavLogo:@"Nav_Title"];
}

//  点击左边barItem
- (void)leftBarItemSelected {
    SearchViewController * searchVC = [[SearchViewController alloc] init];
    searchVC.searchType = 1;
    [self.navigationController pushViewController:searchVC animated:YES];
}

//  点击右边barItem
- (void)rightBarItemSelected {
    NSLog(@"＊＊＊＊＊＊＊＊＊位置");
}

@end
