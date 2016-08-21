//
//  THNDiscoverViewController.m
//  Fiu
//
//  Created by FLYang on 16/8/8.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "THNDiscoverViewController.h"
#import "THNDiscoverSceneTableViewCell.h"
#import "HomeSceneListRow.h"

static NSString *const URLSceneList = @"/scene_sight/";
static NSString *const URLCategory = @"/category/getlist";

static NSString *const DiscoverCellId = @"discoverCellId";

@interface THNDiscoverViewController ()

@pro_strong NSMutableArray *categoryMarr;

@end

@implementation THNDiscoverViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self thn_setNavigationViewUI];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self thn_setDiscoverViewUI];
    [self networkCategoryData];
    [self thn_networkSceneListData];
}

#pragma mark - 网络请求
#pragma mark 分类
- (void)networkCategoryData {
    self.categoryRequest = [FBAPI getWithUrlString:URLCategory requestDictionary:@{@"domain":@"13", @"page":@"1", @"size":@"10"} delegate:self];
    [self.categoryRequest startRequestSuccess:^(FBRequest *request, id result) {
        self.categoryMarr = [NSMutableArray arrayWithArray:[[result valueForKey:@"data"] valueForKey:@"rows"]];
        if (self.categoryMarr.count) {
            [self.categoryView setCategoryData:self.categoryMarr];
        }
        
    } failure:^(FBRequest *request, NSError *error) {
        NSLog(@"%@", error);
    }];
}

#pragma mark 情景列表
- (void)thn_networkSceneListData {
    [SVProgressHUD show];
    self.sceneListRequest = [FBAPI getWithUrlString:URLSceneList requestDictionary:@{@"page":@(self.currentpageNum + 1), @"size":@10, @"sort":@"0"} delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray *sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow *homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
            [self.userIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.userId]];
        }
        
        [self.discoverTable reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        [self requestIsLastData:self.discoverTable currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        [SVProgressHUD dismiss];
        
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
    if (total == 0) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    
    BOOL isLastPage = (current == total);
    
    if (!isLastPage) {
        if (table.mj_footer.state == MJRefreshStateNoMoreData) {
            [table.mj_footer resetNoMoreData];
        }
    }
    if (current == total == 1) {
        table.mj_footer.state = MJRefreshStateNoMoreData;
        table.mj_footer.hidden = true;
    }
    if ([table.mj_header isRefreshing]) {
        CGPoint tableY = table.contentOffset;
        tableY.y = 0;
        if (table.bounds.origin.y > 0) {
            [UIView animateWithDuration:.3 animations:^{
                table.contentOffset = tableY;
            }];
        }
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
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
        _discoverTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 113) style:(UITableViewStyleGrouped)];
        _discoverTable.delegate = self;
        _discoverTable.dataSource = self;
        _discoverTable.tableHeaderView = self.categoryView;
        _discoverTable.tableFooterView = [UIView new];
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
    if (section == 0) {
        return self.sceneListMarr.count/2;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        THNDiscoverSceneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscoverCellId];
        cell = [[THNDiscoverSceneTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:DiscoverCellId];
        if (self.sceneListMarr.count) {
            [cell thn_setSceneUserInfoData:self.sceneListMarr[indexPath.row]];
        }
        return cell;
        
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cellID"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return ((SCREEN_WIDTH - 45)/2)*1.21 + 15;
    }
    return 0.01;
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
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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

#pragma mark - NSMutableArray
- (NSMutableArray *)categoryMarr {
    if (!_categoryMarr) {
        _categoryMarr = [NSMutableArray array];
    }
    return _categoryMarr;
}

- (NSMutableArray *)sceneListMarr {
    if (!_sceneListMarr) {
        _sceneListMarr = [NSMutableArray array];
    }
    return _sceneListMarr;
}

- (NSMutableArray *)sceneIdMarr {
    if (!_sceneIdMarr) {
        _sceneIdMarr = [NSMutableArray array];
    }
    return _sceneIdMarr;
}

- (NSMutableArray *)userIdMarr {
    if (!_userIdMarr) {
        _userIdMarr = [NSMutableArray array];
    }
    return _userIdMarr;
}

@end
