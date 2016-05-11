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
@property (nonatomic, assign) NSInteger currentPageNumber;
@property (nonatomic, assign) NSInteger totalPageNumber;
@end

static NSString *const URLSceneList = @"/scene_sight/";

@implementation PraisedViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:(UIStatusBarAnimationSlide)];
    [self setNavigationViewUI];
    [self requestDataForOderList];
    
    // 下拉刷新
    self.homeTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _currentPageNumber = 0;
        [self.sceneListMarr removeAllObjects];
        [self.sceneIdMarr removeAllObjects];
        [self requestDataForOderListOperation];
    }];
    
    //上拉加载更多
    self.homeTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_currentPageNumber < _totalPageNumber) {
//            [self.sceneListMarr removeAllObjects];
//            [self.sceneIdMarr removeAllObjects];
            [self requestDataForOderListOperation];
        } else {
            [self.homeTableView.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - Network
- (void)requestDataForOderList
{
    _currentPageNumber = 0;
    [self.sceneListMarr removeAllObjects];
    [self.sceneIdMarr removeAllObjects];
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    
    [self requestDataForOderListOperation];
}


//上拉下拉分页请求订单列表
- (void)requestDataForOderListOperation
{
    [SVProgressHUD show];
    UserInfoEntity *entity = [UserInfoEntity defaultUserInfoEntity];
    NSDictionary *  requestParams = @{@"size":@"10", @"page":@(_currentPageNumber + 1),@"user_id":entity.userId,@"type":@"sight",@"event":@"love"};
    self.sceneListRequest = [FBAPI getWithUrlString:@"/favorite" requestDictionary:requestParams delegate:self];
    [self.sceneListRequest startRequestSuccess:^(FBRequest *request, id result) {
        
        NSLog(@"场景  %@",result);
        NSArray * sceneArr = [[result valueForKey:@"data"] valueForKey:@"rows"];
    
        for (NSDictionary * sceneDic in sceneArr) {
            HomeSceneListRow * homeSceneModel = [[HomeSceneListRow alloc] initWithDictionary:sceneDic];
            [self.sceneListMarr addObject:homeSceneModel];
            [self.sceneIdMarr addObject:[NSString stringWithFormat:@"%zi", homeSceneModel.idField]];
        }
        [self.homeTableView reloadData];
        _currentPageNumber = [[[result valueForKey:@"data"] valueForKey:@"current_page"] integerValue];
        _totalPageNumber = [[[result valueForKey:@"data"] valueForKey:@"total_page"] integerValue];
        
        BOOL isLastPage = (_currentPageNumber == _totalPageNumber);
        
        if (!isLastPage) {
            if (self.homeTableView.mj_footer.state == MJRefreshStateNoMoreData) {
                [self.homeTableView.mj_footer resetNoMoreData];
            }
        }
        if (_currentPageNumber == _totalPageNumber == 1) {
            self.homeTableView.mj_footer.state = MJRefreshStateNoMoreData;
            self.homeTableView.mj_footer.hidden = true;
        }
        
        if ([self.homeTableView.mj_header isRefreshing]) {
            [self.homeTableView.mj_header endRefreshing];
        }
        if ([self.homeTableView.mj_footer isRefreshing]) {
            if (isLastPage) {
                [self.homeTableView.mj_footer endRefreshingWithNoMoreData];
            } else  {
                [self.homeTableView.mj_footer endRefreshing];
            }
        }
        
        [SVProgressHUD dismiss];
    } failure:^(FBRequest *request, NSError *error) {
        [SVProgressHUD showInfoWithStatus:[error localizedDescription]];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.homeTableView];
    
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
