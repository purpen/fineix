//
//  PraisedViewController.m
//  Fiu
//
//  Created by THN-Dong on 16/4/19.
//  Copyright © 2016年 taihuoniao. All rights reserved.
//

#import "PraisedViewController.h"
#import "SceneListTableViewCell.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"
#import "SceneInfoViewController.h"
#import "UserInfoEntity.h"

@interface PraisedViewController ()<FBNavigationBarItemsDelegate,UITableViewDelegate,UITableViewDataSource>
@pro_strong NSMutableArray      *   sceneListMarr;
@pro_strong NSMutableArray      *   sceneIdMarr;
@end

static NSString *const URLSceneList = @"/scene_sight/";

@implementation PraisedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [self setNavigationViewUI];
    [self networkRequestData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currentpageNum = 0;
    [self.view addSubview:self.homeTableView];
    
}

#pragma mark - 网络请求
- (void)networkRequestData {
    [SVProgressHUD show];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    NSDictionary *  requestParams = @{@"size":@"10", @"page":@(self.currentpageNum + 1),@"user_id":entity.userId,@"type":@"sight",@"event":@"love"};
    self.sceneListRequest = [FBAPI getWithUrlString:@"/favorite" requestDictionary:requestParams delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
        if ([[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue] == 1) {
            [self.sceneListMarr removeAllObjects];
            [self.sceneIdMarr removeAllObjects];
        }
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
        }
        [self.homeTableView reloadData];
        self.currentpageNum = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        self.totalPageNum = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        if (self.totalPageNum > 1) {
            [self addMJRefresh:self.homeTableView];
            [self requestIsLastData:self.homeTableView currentPage:self.currentpageNum withTotalPage:self.totalPageNum];
        }
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[error localizedDescription]];
    }];
}

//  判断是否为最后一条数据
- (void)requestIsLastData:(UITableView *)table currentPage:(NSInteger )current withTotalPage:(NSInteger)total {
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
        [table.mj_header endRefreshing];
    }
    if ([table.mj_footer isRefreshing]) {
        if (isLastPage) {
            [table.mj_footer endRefreshingWithNoMoreData];
        } else  {
            [table.mj_footer endRefreshing];
        }
    }
    [SVProgressHUD dismiss];
}

#pragma mark - 上拉加载 & 下拉刷新
- (void)addMJRefresh:(UITableView *)table {
    table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.currentpageNum = 0;
        [self networkRequestData];
    }];
    
    table.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.currentpageNum < self.totalPageNum) {
            [self networkRequestData];
        } else {
            [table.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - 加载首页表格
- (UITableView *)homeTableView {
    if (!_homeTableView) {
        _homeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _homeTableView.delegate = self;
        _homeTableView.dataSource = self;
        _homeTableView.showsVerticalScrollIndicator = NO;
        _homeTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _homeTableView;
}

#pragma mark - tableView Delegate & dataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sceneListMarr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * homeTableViewCellID = @"hqzomeTableViewCellID";
    SceneListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:homeTableViewCellID];
    if (!cell) {
        cell = [[SceneListTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:homeTableViewCellID];
    }
    if (self.sceneListMarr.count) {
        [cell setHomeSceneListData:self.sceneListMarr[indexPath.row]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT + 5;
}

#pragma mark - 跳转到场景的详情
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SceneInfoViewController * sceneInfoVC = [[SceneInfoViewController alloc] init];
    sceneInfoVC.sceneId = self.sceneIdMarr[indexPath.row];
    [self.navigationController pushViewController:sceneInfoVC animated:YES];
}


#pragma mark - 设置Nav
- (void)setNavigationViewUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.delegate = self;
    self.navViewTitle.text = @"赞过的场景";
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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

@end
